#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package SSP;


sub advance
{
    my $self = shift;

    my $scheduler = shift;

    my $time = shift;

    my $options = shift;

    # determine the time step

    my $time_step_min = $self->get_time_step();

    # if we were not able to define a time step

    if (!defined $time_step_min)
    {
	die "$0: Cannot determine a minimal time step";
    }

    # calculate number of steps

    my $steps = $time / $time_step_min;

    # do a number of steps based on this time step

    my $result = $self->steps($scheduler, $steps);

    # return result

    return $result;
}


sub analyze
{
    my $self = shift;

    # loop over all analyzers

    my $analyzers = $self->{analyzers};

    foreach my $analyzer_name (keys %$analyzers)
    {
	my $analyzer = $analyzers->{$analyzer_name};

	# construct the analyzer backend

	my $analyzer_module = $analyzer->{module_name};

	eval
	{
	    local $SIG{__DIE__};

	    require "$analyzer_module.pm";
	};

	if ($@)
	{
	    die "$0: Cannot load analyzer module ($analyzer_module.pm) for analyzer $analyzer_name

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this analyzer.
3. The analyzer module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $analyzer_module', and see if perl can find and compile the analyzer module
4. Contact your system administrator.

$@";
	}

	my $package = $analyzer->{package} || $analyzer_module;

	my $backend = $package->new($analyzer);

	# construct the SSP analyzer for this backend

	my $ssp_analyzer = SSP::Analyzer->new( { backend => $backend, scheduler => $self, }, );

	# initialize the analyzer backend with the user settings

	my $initializers = $analyzer->{initializers};

	foreach my $initializer (@$initializers)
	{
	    my $method = $initializer->{method};

	    my $arguments = $initializer->{arguments};

	    my $success = $backend->$method($ssp_analyzer, @$arguments);

	    if (!$success)
	    {
		die "$0: Initializer $method for $analyzer_name failed";
	    }
	}

	# bind the SSP analyzer in the scheduler

	$analyzer->{ssp_analyzer} = $ssp_analyzer;
    }

    # return success

    return 1;

}


sub apply_granular_parameters
{
    my $self = shift;

    my $scheduler = shift;

    my $runtime_settings = [ @_, ];

    # set default result: ok

    my $result = 1;

    # loop over all the runtime_settings

    my $solverclasses = $self->{solverclasses};

    foreach my $runtime_setting (@$runtime_settings)
    {
	# fetch the model registration

	my $modelname = $runtime_setting->{modelname};

	my $model = $self->lookup_model($modelname);

	my $solverclass = $model->{solverclass};

	my $service = $self->{services}->{$solverclasses->{$solverclass}->{service_name}}->{ssp_service};

	my $solverinfo = $service->input_2_solverinfo($runtime_setting);

	if (!ref $solverinfo)
	{
	    die "$0: Failed to construct solver info for the runtime_setting " . $runtime_setting->{component_name} . "->" . $runtime_setting->{field} . " ($solverinfo)";
	}

	# lookup the solver

	my $solver_engine = $self->lookup_solver_engine($solverinfo->{solver});

# 	# get the input field from the solver (is a double *)

# 	my $solverfield = $solver_engine->solverfield($solverinfo);

# 	if (!defined $solverfield)
# 	{
# 	    die "$0: The runtime_setting " . $runtime_setting->{component_name} . "->" . $runtime_setting->{field} . " cannot be found";
# 	}

	# apply the setting to the solver

	my $application = $solver_engine->set_solverfield($solverinfo, $runtime_setting->{value});

	if ($application)
	{
	    die "$0: Failed to set the runtime_setting " . $runtime_setting->{component_name} . "->" . $runtime_setting->{field} . " ($application)";
	}
    }

    # return result

    return $result;
}


sub compile
{
    my $self = shift;

    # set default result: ok

    my $result = 1;

    # construct a schedule

    my $schedule = $self->{schedule} || [];

    # loop over all models

    my $solverclasses = $self->{solverclasses};

    my $models = $self->{models};

    foreach my $model (@$models)
    {
	my $modelname = $model->{modelname};

	my $solverclass = $model->{solverclass};

	my $service = $self->{services}->{$solverclasses->{$solverclass}->{service_name}};

	# apply the conceptual parameter settings to the model

	if ($model->{conceptual_parameters})
	{
	    my $conceptual_parameter_application
		= $service->{ssp_service}->apply_conceptual_parameters($model->{conceptual_parameters});

	    if (defined $conceptual_parameter_application)
	    {
		die "$0: Cannot apply conceptual_parameters: $conceptual_parameter_application";
	    }
	}

	# apply the granular_parameter settings to the model

	if ($model->{granular_parameters})
	{
	    my $granular_parameter_application
		= $service->{ssp_service}->apply_granular_parameters($model->{granular_parameters});

	    if (defined $granular_parameter_application)
	    {
		die "$0: Cannot apply granular_parameters: $granular_parameter_application";
	    }
	}

	# instantiate a schedulee

	my $solverclass_options = $solverclasses->{$solverclass};

	my $options
	    = {
	       %$solverclass_options,
	       modelname => $modelname,
	       solverclass => $solverclass,
	       service => $service,
	       scheduler => $self,
	      };

# 	my $engine = SSP::Engine->new($solverclass, $service, $modelname);

	my $engine = SSP::Engine->new( { %$options, }, );

	# compile the model

	if (!$engine->compile($self))
	{
	    return 0;
	}

	# register the schedulee in the service

	if (!$service->{ssp_service}->register_engine($engine, $modelname))
	{
	    return 0;
	}

	# register the schedulee in the schedule

	push @$schedule, $engine;
    }

    # register the schedule

    $self->{schedule} = $schedule;

    # return result

    return $result;
}


#
# daemonize()
#
# Daemonize the running process by setting a session id, optionally close
# shared resources between child and parent (files), and print a diagnostic
# message on STDOUT.  '$pid' is replaced with the child process id in the
# diagnostic message.
#
# returns the created process id if $options->{return} is set, otherwise
# exits.
#

sub daemonize
{
    my $self = shift;

    my $scheduler = shift;

    my $close_files = shift;

    my $options = shift;

    my $message = $options->{message} || '';

    my $pid;

#     mlog("daemonize ($$)", "forking");

    if ($pid = fork())
    {
# 	mlog("daemonize ($$)", "forked");

        # parent : print optional message and exit or return

	if ($message)
	{
	    $message =~ s/\$pid/$pid/g;

	    print($message);
	}

	if ($options->{return})
	{
# 	    mlog("daemonize ($$)", "forked : return");

	    return $pid;
	}
	else
	{
# 	    mlog("daemonize ($$)", "forked : exit");

	    exit(0);
	}
    }

    # child : create session, optionally close shared resources.

    # set default result

    my $result = 1;

#     mlog("daemonize ($$)", "forked : cd");

    use POSIX;

    POSIX::setsid();
    chdir('/');

    if ($close_files)
    {
# 	mlog("daemonize ($$)", "closing files");

	# unlock shared resources : close all file descriptors.

	use FileHandle;

	my $closed = FileHandle->new(">/tmp/closed.txt");

	my $files = POSIX::sysconf(POSIX::_SC_OPEN_MAX);

	if ($closed)
	{
	    print $closed "Closing $files file handles.\n";
	}

	if ($close_files > 0)
	{
	    $files = $close_files;
	}

	while ($files > -1)
	{
	    my $result = "not done";

	    if (!defined $closed || $closed->fileno() != $files)
	    {
		$result = POSIX::close($files) || -1;
	    }

	    if (defined $closed)
	    {
		print $closed "Closed file handle $files : $result\n";
	    }

	    $files--;
	}

	$closed->close();
    }

#     mlog("daemonize ($$)", "done");

    return $result;
}


sub finish
{
    my $self = shift;

    # set default result: ok

    my $result = 1;

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# advance the engine

	my $success = $schedulee->finish();

	if (!$success)
	{
	    die "Finishing failed";
	}
    }

    # return result

    return $result;
}


sub get_time_step
{
    my $self = shift;

    my $result;

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# get the time step

	my $time_step = $schedulee->get_time_step();

	if (!defined $result)
	{
	    $result = $time_step;
	}

	if (defined $time_step
	    and $time_step < $result)
	{
	    $result = $time_step;
	}
    }

    # return result

    return $result;
}


sub initiate
{
    my $self = shift;

    # set default result: ok

    my $result = 1;

    # first update the time

    $self->{simulation_time}
	= {
	   steps => 0,
	   time => 0,
	  };

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# advance the engine

	my $success = $schedulee->initiate();

	if (!$success)
	{
	    die "$0: Initiation failed";
	}
    }

    # return result

    return $result;
}


# sub instantiate_communicators
# {
#     my $self = shift;

#     # loop over all services

#     my $communicators = $self->{communicators};

#     foreach my $communicator_name (keys %$communicators)
#     {
# 	my $communicator = $communicators->{$communicator_name};

# 	# construct the communicator backend

# 	my $communicator_module = $communicator->{module_name};

# 	eval
# 	{
# 	    local $SIG{__DIE__};

# 	    require "$communicator_module.pm";
# 	};

# 	if ($@)
# 	{
# 	    die "$0: Cannot load communicator module ($communicator_module.pm) for communicator $communicator_name

# Possible solutions:
# 1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
# 2. Install the correct integration module for this communicator.
# 3. The communicator module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $communicator_module', and see if perl can find and compile the communicator module
# 4. Contact your system administrator.

# $@";
# 	}

# 	my $package = $communicator->{package} || $communicator_module;

# 	my $backend = $package->new($communicator);

# 	# construct the SSP communicator for this backend

# 	my $ssp_communicator = SSP::Engine->new( { backend => $backend, scheduler => $self, }, );

# 	# initialize the communicator backend with the user settings

# 	my $initializers = $communicator->{initializers};

# 	foreach my $initializer (@$initializers)
# 	{
# 	    my $method = $initializer->{method};

# 	    my $arguments = $initializer->{arguments};

# 	    my $success = $backend->$method($ssp_communicator, @$arguments);

# 	    if (!$success)
# 	    {
# 		die "$0: initializer $method for $communicator_name failed";
# 	    }
# 	}

# 	# bind the SSP communicator in the scheduler

# 	$communicator->{ssp_communicator} = $ssp_communicator;
#     }

#     # return success

#     return 1;
# }


sub instantiate_inputs
{
    my $self = shift;

    # loop over all input classes

    my $schedule = $self->{schedule};

    my $inputclasses = $self->{inputclasses};

    foreach my $inputclass_name (keys %$inputclasses)
    {
	# instantiate the input class

	my $inputclass = $inputclasses->{$inputclass_name};

	# create the engine for the input

	my $input_engine
	    = SSP::Input->new
		(
		 {
		  name => $inputclass_name,
		  scheduler => $self,
		  %$inputclass,
		 },
		);

	if (!$input_engine)
	{
	    die "Unable to create an input_engine for $inputclass_name";
	}

	# link the input engine to the input class

	#! such that later on the inputs can find the input engine

	$inputclass->{ssp_inputclass} = $input_engine;

	# schedule the input_engine, such that it inputs something
	# when variables are added to it

	push @$schedule, $input_engine;
    }

    # loop over all inputs

    my $inputs = $self->{inputs};

    foreach my $input (@$inputs)
    {
	# determine the service for this input

	my $service_name;

	if (exists $input->{service_name})
	{
	    $service_name = $input->{service_name};
	}
	else
	{
	    #t the service of the first model ...  not really good
	    #t basically this says that SSP can currently only run one service at a time.

	    my $solverclass = $self->{models}->[0]->{solverclass};

	    $service_name = $self->{solverclasses}->{$solverclass}->{service_name};
	}

	# ask the service the solverinfo for this input

	my $service = $self->{services}->{$service_name}->{ssp_service};

	my $solverinfo = $service->input_2_solverinfo($input);

	if (!ref $solverinfo)
	{
	    die "$0: Failed to construct solver info for the input " . $input->{component_name} . "->" . $input->{field} . " ($solverinfo)";
	}

	# lookup the solver

	my $solver_engine = $self->lookup_solver_engine($solverinfo->{solver});

	# get the input field from the solver (is a double *)

	my $solverfield = $solver_engine->solverfield($solverinfo);

	if (!defined $solverfield)
	{
	    die "$0: The input " . $input->{component_name} . "->" . $input->{field} . " cannot be found";
	}

	# find the input for the input class

	my $inputclass_name = $input->{inputclass};

	my $inputclass = $self->{inputclasses}->{$inputclass_name};

	if (!defined $inputclass)
	{
	    die "$0: The input " . $input->{component_name} . "->" . $input->{field} . " has as inputclass $inputclass_name, but this class cannot be found";
	}

	# add the input field to the input engine

	#! note that inputclass is not an object

	my $input_backend = $inputclass->{ssp_inputclass};

	my $connected
	    = $input_backend->add
		(
		 {
		  address => $solverfield,
		  service_request => $input,
		 },
		);

	if (!$connected)
	{
	    die "$0: The input " . $input->{component_name} . "->" . $input->{field} . " cannot be connected to its input engine (which is determined by the input class in the schedule).";
	}
    }

    # return success

    return 1;
}


sub instantiate_outputs
{
    my $self = shift;

    # loop over all output classes

    my $schedule = $self->{schedule};

    my $outputclasses = $self->{outputclasses};

    foreach my $outputclass_name (keys %$outputclasses)
    {
	# instantiate the output class

	my $outputclass = $outputclasses->{$outputclass_name};

	# create the engine for the output

	my $output_engine
	    = SSP::Output->new
		(
		 {
		  name => $outputclass_name,
		  scheduler => $self,
		  %$outputclass,
		 },
		);

	if (!$output_engine)
	{
	    die "Unable to create an output_engine for $outputclass_name";
	}

	# link the output engine to the output class

	#! such that later on the outputs can find the output engine

	$outputclass->{ssp_outputclass} = $output_engine;

	# schedule the output_engine, such that it outputs something
	# when variables are added to it

	push @$schedule, $output_engine;
    }

    # loop over all outputs

    my $outputs = $self->{outputs};

    foreach my $output (@$outputs)
    {
	# determine the service for this output

	my $service_name;

	if (exists $output->{service_name})
	{
	    $service_name = $output->{service_name};
	}
	else
	{
	    #t the service of the first model ...  not really good
	    #t basically this says that SSP can currently only run one service at a time.

	    my $solverclass = $self->{models}->[0]->{solverclass};

	    $service_name = $self->{solverclasses}->{$solverclass}->{service_name};
	}

	# ask the service the solverinfo for this output

	my $service = $self->{services}->{$service_name}->{ssp_service};

	my $solverinfo = $service->output_2_solverinfo($output);

	if (!ref $solverinfo)
	{
	    die "Failed to construct solver info for the output " . $output->{component_name} . "->" . $output->{field} . " ($solverinfo)";
	}

	# lookup the solver

	my $solver_engine = $self->lookup_solver_engine($solverinfo->{solver});

	# if there is a relay service

	if ($output->{distributor_service})
	{
	    #1

	    #t connect the solver with the service

	    #t fills in the iTable member for the spikegen intermediary

	    #t fills in the event send function

	    #2

	    #t connect the service with the output engine

	    #t fills in the output object and OutputGeneratorAnnotatedStep() in the distributor_service
	}
	else
	{
	    # get the output field from the solver (is a double *)

	    my $solverfield = $solver_engine->solverfield($solverinfo);

	    if (!defined $solverfield)
	    {
		die "The output " . $output->{component_name} . "->" . $output->{field} . " cannot be found";
	    }

	    # find the output for the output class

	    my $outputclass_name = $output->{outputclass};

	    my $outputclass = $self->{outputclasses}->{$outputclass_name};

	    if (!defined $outputclass)
	    {
		die "The output " . $output->{component_name} . "->" . $output->{field} . " has as outputclass $outputclass_name, but this class cannot be found";
	    }

	    # add the output field to the output engine

	    #! note that outputclass is not an object

	    my $output_backend = $outputclass->{ssp_outputclass};

	    my $connected
		= $output_backend->add
		    (
		     {
		      address => $solverfield,
		      service_request => $output,
		     },
		    );

	    if (!$connected)
	    {
		die "The output " . $output->{component_name} . "->" . $output->{field} . " cannot be connected to its output engine (which is determined by the output class in the schedule).";
	    }
	}
    }

    # return success

    return 1;
}


sub instantiate_services
{
    my $self = shift;

    # loop over all services

    my $services = $self->{services};

    foreach my $service_name (keys %$services)
    {
	my $service = $services->{$service_name};

	# construct the service backend

	my $service_module = $service->{module_name};

	eval
	{
	    local $SIG{__DIE__};

	    require "$service_module.pm";
	};

	if ($@)
	{
	    die "$0: Cannot load service module ($service_module.pm) for service $service_name

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this service.
3. The service module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $service_module', and see if perl can find and compile the service module
4. Contact your system administrator.

$@";
	}

	my $package = $service->{package} || $service_module;

	my $backend = $package->new($service);

	# construct the SSP service for this backend

	my $ssp_service = SSP::Service->new( { backend => $backend, scheduler => $self, }, );

	# initialize the service backend with the user settings

	my $initializers = $service->{initializers};

	foreach my $initializer (@$initializers)
	{
	    my $method = $initializer->{method};

	    my $arguments = $initializer->{arguments};

	    my $success = $backend->$method($ssp_service, @$arguments);

	    if (!$success)
	    {
		die "$0: Initializer $method for $service_name failed";
	    }
	}

	# bind the SSP service in the scheduler

	$service->{ssp_service} = $ssp_service;
    }

    # return success

    return 1;
}


sub lookup_model
{
    my $self = shift;

    my $modelname = shift;

    # default result: not found

    my $result;

    # loop over all models

    my $models = $self->{models};

    foreach my $model (@$models)
    {
	# if modelname matches

	if ($model->{modelname} eq $modelname)
	{
	    # set result

	    $result = $model;

	    # break searching loop

	    last;
	}
    }

    # return result

    return $result;
}


sub lookup_object
{
    my $self = shift;

    my $object_name = shift;

    # default: not found

    my $result;

    if (!defined $result)
    {
	# search in the services

	my $services = $self->{services};

	foreach my $service_name (keys %$services)
	{
	    my $service = $services->{$service_name};

	    # if name matches

	    if ($service_name =~ /$object_name/)
	    {
		# set result: matching object, isa SSP::Service

		$result = $service->{ssp_service};

		last;
	    }
	}
    }

    if (!defined $result)
    {
	# search in the solvers

	my $solverclasses = $self->{solverclasses};

	foreach my $solverclass_name (keys %$solverclasses)
	{
	    my $solverclass = $solverclasses->{$solverclass_name};

	    # if name matches

	    if ($solverclass_name =~ /$object_name/)
	    {
		# set result: matching object

		#t should be returning the SSP::Engine perhaps ?

		$result = $solverclass;

		last;
	    }
	}
    }

    if (!defined $result)
    {
	# search in the analyzers

	my $analyzers = $self->{analyzers};

	foreach my $analyzer_name (keys %$analyzers)
	{
	    my $analyzer = $analyzers->{$analyzer_name};

	    # if name matches

	    if ($analyzer_name =~ /$object_name/)
	    {
		# set result: matching object, isa SSP::Analyzer

		$result = $analyzer->{ssp_analyzer};

		last;
	    }
	}
    }

    # return result

    return $result;
}


# sub lookup_output
# {
#     my $self = shift;

#     my $options = shift;

#     my $index = $options->{index};

#     return $self->{outputs}->[$index];
# }


sub lookup_solver_engine
{
    my $self = shift;

    my $solver_name = shift;

    my $result;

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# if name matches

	my $schedulee_name = $schedulee->name();

	if ($schedulee_name eq $solver_name)
	{
	    # set result

	    $result = $schedulee;

	    # break searching loop

	    last;
	}
    }

    return $result;
}


sub new
{
    my $package = shift;

    my $options = shift;

    my $self
	= {
	   %$options,
	  };

    bless $self, $package;

    # do a sanity check: no solverclasses and services with the same name

    my $named_objects_array
	= [
	   keys %{$self->{analyzers}},
	   keys %{$self->{services}},
	   keys %{$self->{solverclasses}},
	  ];

    my $named_objects_hash
	= {
	   map { $_ => 1; } @$named_objects_array,
	  };

    if (scalar @$named_objects_array ne scalar keys %$named_objects_hash)
    {
	die "$0: schedule contains duplicate object names (check service names and solver names).";
    }

    # we always need application_classes etc.

    $self->salvage();

    return $self;
}


sub run
{
    my $self = shift;

    my $options = shift;

    # we always need application_classes etc.

    $self->salvage();

#     # get initializers and simulation specifications, using defaults
#     # where needed

#     my $services
# 	= $self->{apply}->{services}
# 	    ||
# 		[
# 		 { method => 'instantiate_services', },
# 		];

#     my $modifiers = $self->{apply}->{modifiers} || [];

#     my $initializers
# 	= $self->{apply}->{initializers}
# 	    || [
# 		{ method => 'compile', },
# 		{ method => 'instantiate_inputs', },
# 		{ method => 'instantiate_outputs', },
# 		{ method => 'initiate', },
# 	       ],
# 		   ;

#     my $simulation = $self->{apply}->{simulation} || [];

#     my $finishers
# 	= $self->{apply}->{finishers}
# 	    || [
# 		{ method => 'finish', },
# 	       ],
# 		   ;

#     my $results = $self->{apply}->{results} || [];

    # loop through the application_classes

    my $application_classes = $self->{application_classes};

    foreach my $application_class_name (
					sort
					{
					    $application_classes->{$a}->{priority} <=> $application_classes->{$b}->{priority}
					}
					keys %$application_classes
				       )
    {
	my $application_class = $application_classes->{$application_class_name};

	# apply the default when needed

	$self->{apply}->{$application_class_name}
	    = $self->{apply}->{$application_class_name}
		|| $application_class->{default};

	# translate command hashes to schedule arrays

	if ($self->{apply}->{$application_class_name} =~ /HASH/)
	{
	    my $type = $self->{apply}->{$application_class_name}->{type};

	    # when pushing

	    #t I guess I have to redo this, overly complicated for what it does.

	    #t only used for daemonizing

	    if ($type eq 'push')
	    {
		my $applications
		    = [
		       @{$self->{apply}->{$application_class_name}->{have}},
		       @{$self->{apply}->{$application_class_name}->{push}},
		      ];

		$self->{apply}->{$application_class_name} = $applications;
	    }
	    else
	    {
		die "$0: schedule applies a type of $type to the $application_class application_class, but this type is not defined.";
	    }
	}
    }

    # construct the schedule we have to apply

    my $applications = [];

    foreach my $application_class_name (
					sort
					{
					    $application_classes->{$a}->{priority} <=> $application_classes->{$b}->{priority}
					}
					keys %$application_classes
				       )
    {
	push @$applications, @{$self->{apply}->{$application_class_name}};
    }

    # go through the schedule

    foreach my $application (@$applications)
    {
	# skip applications that were meant to switch off the defaults

	if (!ref $application
	    && !defined $application)
	{
	    next;
	}

	# start determining the ssp frontend peer for aliens

	#t so default is ssp itself, which seem far from logical ...

	my $peer = $self;

	# get object

	my $object_name = $application->{object} || $self;

	my $object;

	# translate a name to a real object

	if (!ref($object_name))
	{
	    $object = $self->lookup_object($object_name);

	    # we set the ssp frontend as peer

	    $peer = $object;

	    # get object backend

	    #! not sure, should be out of the if() ?

	    $object = ((defined $object) and ($object->backend()));
	}
	else
	{
	    $object = $object_name;
	}

	if (!defined $object)
	{
	    die "$0: schedule references service or object $object, but it cannot be found";
	}

	# get method and arguments

	my $method = $application->{method};

	my $arguments = $application->{arguments};

	# apply the method

	#t note that this verbosity level is not the same as the one
	#t in the configuration
	#t
	#t needs to be sorted out.

	if ($options->{verbosity})
	{
	    print "$0: applying method '$method' to $self->{name}\n";
	}

	my $success = $object->$method($peer, @$arguments);

	if (!$success)
	{
	    die "while running $self->{name}: $method failed";
	}

	# register the method and arguments

	push @{$self->{status}->{$method}}, $arguments;
    }
}


sub salvage
{
    my $self = shift;

    # set defaults for application classes

    if (!exists $self->{application_classes})
    {
	$self->{application_classes}
	    = {
	       services => {
			    default => [
					{ method => 'instantiate_services', },
				       ],
			    priority => 20,
			   },
	       modifiers => {
			     default => [],
			     priority => 50,
			    },
	       initializers => {
				default => [
					    { method => 'compile', },
					    { method => 'instantiate_inputs', },
					    { method => 'instantiate_outputs', },
					    { method => 'initiate', },
					   ],
				priority => 80,
			       },
	       analyzers => {
			     default => [
					 { method => 'analyze', },
					],
			     priority => 95,
			    },
	       simulation => {
			      default => [],
			      priority => 110,
			     },
	       finishers => {
			     default => [
					 { method => 'finish', },
					],
			     priority => 140,
			    },
	       results => {
			   default => [],
			   priority => 170,
			  },
	      };

    }
}


sub shell
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    my $result = 1;

    my $commands = $options->{commands};

    foreach my $command (@$commands)
    {
	system "$command";

	if ($?)
	{
	    print "$0: '$command' failed: $?";

	    $result = 0;
	}
    }

    return $result;
}


sub steps
{
    my $self = shift;

    my $scheduler = shift;

    my $steps = shift;

    my $options = shift || {};

    # set default result: ok

    my $result = 1;

    # initial dump

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	my $backend = $schedulee->backend();

	$backend->report( $schedulee, { %$options, steps => undef, }, );
    }

    # initialize current simulation time steps

    my $simulation_steps = $self->{simulation_time}->{steps};

    # a couple of times

    foreach my $step (0 .. $steps - 1)
    {
	# loop over all schedulees

	my $schedule = $self->{schedule};

	foreach my $schedulee (@$schedule)
	{
	    # advance the engine

	    my $error = $schedulee->step( $self, { %$options, steps => $simulation_steps, }, );

	    if ($error)
	    {
		die "Scheduling for $steps failed";
	    }

	    # dump

	    my $backend = $schedulee->backend();

	    $backend->report( $schedulee, { %$options, steps => $simulation_steps, }, );
	}

	# update the global time

	$simulation_steps++;
    }

    # maintain global simulation time

    $self->{simulation_time}->{steps} = $simulation_steps;

    if ($options->{time_step})
    {
	$self->{simulation_time}->{time} += $simulation_steps * $options->{time_step};
    }
    else
    {
	undef $self->{simulation_time}->{time};
    }

    # final report

    foreach my $schedulee (@$schedule)
    {
	my $backend = $schedulee->backend();

	$backend->report( $schedulee, { %$options, steps => -1, }, );
    }

    # return result

    return $result;
}


package SSP::Glue;



sub backend
{
    my $self = shift;

    return $self->{backend};
}


package SSP::Analyzer;



BEGIN { our @ISA = qw(SSP::Glue); }


sub analyze
{
    my $self = shift;
}


# sub backend
# {
#     my $self = shift;

#     return $self->{backend};
# }


sub new
{
    my $package = shift;

    my $options = shift;

    my $self
	= {
	   %$options,
	  };

    bless $self, $package;

    return $self;
}


package SSP::Engine;


BEGIN { our @ISA = qw(SSP::Glue); }


sub advance
{
    my $self = shift;

    my $scheduler = shift;

    my $time = shift;

    # set result : ok

    my $result;

    my $backend = $self->backend();

    my $success = $backend->advance($self, $time);

    if (!$success)
    {
	$result = "HeccerHeccs() failed";
    }

    # return result

    return $result;
}


sub compile
{
    my $self = shift;

    my $scheduler = shift;

    # set default result: ok

    my $result = 1;

    #t do better error checking for this method

    # construct an engine for this model

    my $modelname = $self->{modelname};

    my $solverclass = $self->{solverclass};

    my $service_name = $self->{service_name};

    my $solver_module = $self->{module_name};

    #! the service points into the scheduler, but is not the service object

    #t use ->backend() method twice ?

    my $service = $self->{service}->{ssp_service};

    my $service_backend = $service->backend();

    eval
    {
	local $SIG{__DIE__};

	require "$solver_module.pm";
    };

    if ($@)
    {
	die "$0: Cannot load solver module ($solver_module.pm) for solverclass $solverclass

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this solver.
   e.g. for Heccer, you need to configure Heccer with --with-neurospaces
3. The solverclass module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $solver_module', and see if perl can find and compile the solverclass module
4. Contact your system administrator.

$@";
    }

    my $constructor_settings = $self->{constructor_settings} || {};

    my $package = $self->{package} || $solver_module;

    my $engine
	= $solver_module->new
	    (
	     {
	      #t can create a circular reference but is convenient, not sure

	      %$constructor_settings,
	      model_source => {
			       service_name => $service_name,
			       service_backend => $service_backend,
			       modelname => $modelname,
			      },
	     },
	    );

    # register the engine with the schedulee

    $self->{backend} = $engine;

    if (ref $engine)
    {
	$result = $engine->compile();
    }
    else
    {
	$result = 0;
    }

    # return result

    return $result;
}


sub finish
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->finish($self);

    return $result;
}


sub get_time_step
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->get_time_step($self);

    return $result;
}


sub initiate
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->initiate($self);

    return $result;
}


sub name
{
    my $self = shift;

    return $self->{service_name} . "::" . $self->{modelname};
}


sub new
{
    my $package = shift;

    my $options = shift;

    my $self = { %$options, };

    bless $self, $package;

    return $self;
}


sub set_solverfield
{
    my $self = shift;

    my $fieldinfo = shift;

    my $value = shift;

    my $backend = $self->backend();

    #t should give $self as first argument

    my $result = $backend->set_addressable($fieldinfo, $value);

    return $result;
}


sub solverfield
{
    my $self = shift;

    my $fieldinfo = shift;

    my $backend = $self->backend();

    #t should give $self as first argument

    my $result = $backend->addressable($fieldinfo);

    return $result;
}


sub step
{
    my $self = shift;

    my $options = shift;

    # set result : ok

    my $result;

    # step

    my $backend = $self->backend();

    my $success = $backend->step($self, $options);

    if (!$success)
    {
	$result = "HeccerHecc() failed";
    }

    # return result

    return $result;
}


# steps is supposed to be used for a solver in standalone mode.  The
# solver is responsible for doing the appropriate output.

sub steps
{
    my $self = shift;

    my $steps = shift;

    my $options = shift || {};

    # set result : ok

    my $result;

    # initial dump

    my $backend = $self->backend();

    $backend->report( $self, { %$options, steps => undef, }, );

    # a couple of times

    foreach my $i (0 .. $steps - 1)
    {
	# step

	my $success = $backend->step( $self, );

	if (!$success)
	{
	    $result = "HeccerHecc() failed";
	}

	# dump

	$backend->report( $self, { %$options, steps => $i, }, );
    }

    $backend->report( $self, { %$options, steps => -1, }, );

    # return result

    return $result;
}


package SSP::Input;


BEGIN { our @ISA = qw(SSP::Glue); }


sub add
{
    my $self = shift;

    my $options = shift;

    my $backend = $self->backend();

    #t should give $self as first argument

    my $result = $backend->add($options);

    return $result;
}


sub advance
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    my $backend = $self->backend();

    my $result = $backend->advance($self, $options);

    return $result;
}


sub finish
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->finish($self);
}


sub get_time_step
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->get_time_step($self);

    return $result;
}


sub initiate
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->initiate($self);
}


sub new
{
    my $package = shift;

    my $options = shift;

    my $self = { %$options, };

    bless $self, $package;

    #t need todo the require on ->{module_name}

    my $input_name = $self->{name};

    my $input_module = $self->{module_name};

    eval
    {
	local $SIG{__DIE__};

	require "$input_module.pm";
    };

    if ($@)
    {
	die "$0: Cannot load input module ($input_module.pm) for input class $input_name

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this input class.
3. The input module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $input_module', and see if perl can find and compile the input module
4. Contact your system administrator.

$@";
    }

    # construct the backend for this input

    {
	no strict "refs";

	my $input_options = $self->{options} || {};

	my $input_package = $self->{package};

	my $backend
	    = $input_package->new
		(
		 {
		  %$options,
		  %$input_options,
		  name => $self->{name},
		 },
		);

	if (!defined $backend)
	{
	    return undef;
	}

	$self->{backend} = $backend;
    }

    # return result

    return $self;
}


sub step
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    # set result : ok

    my $result;

    # step

    my $backend = $self->backend();

    my $success = $backend->step($self, $options);

    if (!$success)
    {
	$result = "HeccerHecc() failed";
    }

    # return result

    return $result;
}


package SSP::Output;


BEGIN { our @ISA = qw(SSP::Glue); }


sub add
{
    my $self = shift;

    my $options = shift;

    my $backend = $self->backend();

    #t should give $self as first argument

    my $result = $backend->add($options);

    return $result;
}


sub advance
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    my $backend = $self->backend();

    my $result = $backend->advance($self, $options);

    return $result;
}


sub finish
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->finish($self);
}


sub get_time_step
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->get_time_step($self);

    return $result;
}


sub initiate
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->initiate($self);
}


sub name
{
    my $self = shift;

    #t this is broken: does not include a count (same field can be
    #t output many times).

    return $self->{output_module} . "::" . $self->{name};
}


sub new
{
    my $package = shift;

    my $options = shift;

    my $self = { %$options, };

    bless $self, $package;

    #t need todo the require on ->{module_name}

    my $output_name = $self->{name};

    my $output_module = $self->{module_name};

    eval
    {
	local $SIG{__DIE__};

	require "$output_module.pm";
    };

    if ($@)
    {
	die "$0: Cannot load output module ($output_module.pm) for output class $output_name

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this output class.
3. The output module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $output_module', and see if perl can find and compile the output module
4. Contact your system administrator.

$@";
    }

    # construct the backend for this output

    {
	no strict "refs";

	my $output_options = $self->{options} || {};

	my $output_package = $self->{package};

	my $backend
	    = $output_package->new
		(
		 {
		  %$options,
		  %$output_options,
		  name => $self->{name},
		 },
		);

	if (!defined $backend)
	{
	    return undef;
	}

	$self->{backend} = $backend;
    }

    # return result

    return $self;
}


sub step
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    # set result : ok

    my $result;

    # step

    my $backend = $self->backend();

    my $success = $backend->step($self, $options);

    if (!$success)
    {
	$result = "HeccerHecc() failed";
    }

    # return result

    return $result;
}


package SSP::Service;


BEGIN { our @ISA = qw(SSP::Glue); }


sub apply_conceptual_parameters
{
    my $self = shift;

    my $options = shift;

    my $service_backend = $self->backend();

    my $result = $service_backend->apply_conceptual_parameters($self, $options);

    return $result;
}


sub apply_granular_parameters
{
    my $self = shift;

    my $options = shift;

    my $service_backend = $self->backend();

    my $result = $service_backend->apply_granular_parameters($self, $options);

    return $result;
}


sub input_2_solverinfo
{
    my $self = shift;

    my $service_backend = $self->backend();

    #t should give $self as first argument

    my $result = $service_backend->input_2_solverinfo(@_);

    return $result;
}


sub new
{
    my $package = shift;

    my $options = shift;

    my $self = { %$options, };

    bless $self, $package;

    return $self;
}


sub output_2_solverinfo
{
    my $self = shift;

    my $service_backend = $self->backend();

    #t should give $self as first argument

    my $result = $service_backend->output_2_solverinfo(@_);

    return $result;
}


sub register_engine
{
    my $self = shift;

    my $engine = shift;

    my $modelname = shift;

    # have the service register the solver for this model

    my $backend = $self->backend();

    #t should give $self as first argument

    my $result = $backend->register_engine($engine, $modelname);

    return $result;
}


1;


