#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package SSP;


use Inline (C => <<'END_C', CLEAN_AFTER_BUILD => 0, CCFLAGS => '-g', OPTIMIZE => '-g');


struct schedulee
{
    int (*pf)();
    void *pv;
};


#define MAX_SCHEDULEES 100

static struct schedulee pschedule[MAX_SCHEDULEES];

static int iSchedule = 0;

int c_register_driver(SV *psvPF, SV *psvPV, char *pcName)
{
    if (!psvPF || !SvRV((SV *)psvPF))
    {
	return -1;
    }

    if (!psvPV || !SvRV((SV *)psvPV))
    {
	return -1;
    }

    void *pf = (void *)SvIV(SvRV((SV *)psvPF));
    void *pv = (void *)SvIV(SvRV((SV *)psvPV));

    pschedule[iSchedule].pf = pf;
    pschedule[iSchedule].pv = pv;

    iSchedule++;

    if (iSchedule >= MAX_SCHEDULEES)
    {
	return -1;
    }

    return iSchedule;
}


double c_steps(int iSteps, double dSimulationTime, double dStep)
{
    int i;

    for (i = 1; i <= iSteps ; i++)
    {
	dSimulationTime += dStep;/*  + (1e-9); */

	int j;

	for (j = 0 ; j < iSchedule ; j++)
	{
	    if (pschedule[j].pf(pschedule[j].pv, dSimulationTime) == 0)
	    {
		return(-1);
	    }
	}
    }

    return(dSimulationTime);
}


END_C


sub advance
{
    my $self = shift;

    my $scheduler = shift;

    my $time = shift;

    my $options = shift || {};

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

    my $result = $self->steps($scheduler, $steps, { %$options, time_step => $time_step_min, }, );

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

    return '';

}


sub apply_runtime_parameters
{
    my $self = shift;

    my $scheduler = shift;

    my $runtime_settings = [ @_, ];

    # set default result: ok

    my $result = '';

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
	    if ($runtime_setting->{warn_only})
	    {
		warn "$0: Failed to construct solver info for the runtime_setting " . $runtime_setting->{component_name} . "->" . $runtime_setting->{field} . " ($solverinfo)";

		next;
	    }
	    else
	    {
		die "$0: Failed to construct solver info for the runtime_setting " . $runtime_setting->{component_name} . "->" . $runtime_setting->{field} . " ($solverinfo)";
	    }
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

    my $result = '';

    # construct a schedule

    my $schedule = $self->{schedule} || [];

    $self->{schedule} = $schedule;

    # define the compilation_priorities

    my $compilation_priorities
	= {
	   events => 1,
	   numerical => 3,
	  };

    # assign a compile priority to each model

    my $solverclasses = $self->{solverclasses};

    my $models = $self->{models};

    foreach my $model (@$models)
    {
	if (!defined $solverclasses->{$model->{solverclass}}->{compilation_priority})
	{
	    # and the default is numerical (solver)

	    $solverclasses->{$model->{solverclass}}->{compilation_priority} = 'numerical';
	}
    }

    # loop over all models

    $models
	= [
	   # sorted by solver class priority

	   sort
	   {
	       my $compilation_priority1 = $solverclasses->{$a->{solverclass}}->{compilation_priority};

	       my $compilation_priority2 = $solverclasses->{$b->{solverclass}}->{compilation_priority};

	       $compilation_priorities->{$compilation_priority1} <=> $compilation_priorities->{$compilation_priority2}
	   }
	   @$models,
	  ];

    foreach my $model (@$models)
    {
	my $modelname = $model->{modelname};

	my $solverclass = $model->{solverclass};

	my $service = $self->{services}->{$solverclasses->{$solverclass}->{service_name}};

	my $event_distributor = $self->{services}->{event_distributor};

	my $event_queuer = $self->{services}->{event_queuer};

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
	    my $granular_parameters = $model->{granular_parameters};

	    foreach my $granular_parameter (@$granular_parameters)
	    {
		my $granular_parameter_application
		    = $service->{ssp_service}->apply_granular_parameters( [ $granular_parameter, ], );

		if (defined $granular_parameter_application)
		{
		    if ($granular_parameter->{warn_only})
		    {
			warn "$0: Cannot apply granular_parameters: $granular_parameter_application";
		    }
		    else
		    {
			die "$0: Cannot apply granular_parameters: $granular_parameter_application";
		    }
		}
	    }
	}

	# instantiate a schedulee

	my $solverclass_options = $solverclasses->{$solverclass};

	my $options
	    = {
	       %$solverclass_options,
	       event_distributor => $event_distributor,
	       event_queuer => $event_queuer,
	       modelname => $modelname,
	       solverclass => $solverclass,
	       service => $service,
	       scheduler => $self,
	      };

# 	my $engine = SSP::Engine->new($solverclass, $service, $modelname);

	my $engine = SSP::Engine->new( { %$options, }, );

	# compile the model

	my $compilation_result = $engine->compile($self);

	if ($compilation_result)
	{
	    return $compilation_result;
	}

	# register the schedulee in the service

	my $registration_result = $service->{ssp_service}->register_engine($engine, $modelname);

	if ($registration_result)
	{
	    return $registration_result;
	}

	# register the schedulee in the schedule

	push @$schedule, $engine;
    }

    # return result

    return $result;
}


#
# connect()
#
# Connect the numerical solvers and the event processors.
#

sub connect
{
    my $self = shift;

    # set default result: ok

    my $result = '';

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# connect the schedulee

	my $error = $schedulee->connect($self);

	if ($error)
	{
	    die "$0: connect failed for $schedulee->{name}";
	}
    }

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

    use POSIX qw(_SC_OPEN_MAX);

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

    my $result = '';

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# allow the engine to finish pending operations

	my $success = $schedulee->finish();

	if (!$success)
	{
	    die "$0: Finishing failed";
	}
    }

    # return result

    return $result;
}


sub get_engine_outputs
{
    my $self = shift;

    my $engine = shift;

    # start with empty result

    my $result = [];

    # get modelname from this engine

    my $modelname = $engine->{model_source}->{modelname};

    # loop over all outputs

    my $outputs = $self->{outputs};

    foreach my $output (@$outputs)
    {
	# if this output belongs to this engine

	#t this test should be using solver registrations in the
	#t model-container service

	if ($output->{component_name} =~ /^$modelname/)
	{
	    # add to result

	    push @$result, $output;
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


sub help
{
    my $topic = shift;

    my $subtopic = shift;

    my $subsubtopic = shift;

    print "description: simple scheduler in perl
usage: |-
  The simple scheduler in perl binds together software components for
  running simulations.  It is based on services and solvers: services
  provide functionality to assist the solvers to construct an
  efficient simulation run-time environment, solvers apply algorithms
  to solve the problem posed, numerically or otherwise.
";

    return "*** Ok";
}


sub history
{
    my $self = shift;

    my $options = shift || {};

    my $result
	= [
	   map
	   {
	       my $result = { %$_, };

	       if (%$options)
	       {
		   if (!$options->{time_stamps})
		   {
		       delete $result->{time_stamp};
		   }
	       }

	       $result;
	   }
	   @{$self->{history}},
	  ];

    return $result;
}


sub initiate
{
    my $self = shift;

    # set default result: ok

    my $result = '';

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
	# initiate the engine

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
# 		die "$0: Initializer $method for $communicator_name failed";
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
	    die "$0: Unable to create an input_engine for $inputclass_name";
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

	# determine the service for this output

	my $service_name
	    = $input->{service_name} || 'model_container';

	# ask the service the solverinfo for this input

	my $service = $self->{services}->{$service_name}->{ssp_service};

	my $solverinfo = $service->input_2_solverinfo($input);

	if (!ref $solverinfo)
	{
	    if ($input->{warn_only})
	    {
		warn "$0: *** Warning: Failed to construct solver info for the input " . $input->{component_name} . "->" . $input->{field} . " ($solverinfo): " . $input->{warn_only};

		next;
	    }
	    else
	    {
		die "$0: Failed to construct solver info for the input " . $input->{component_name} . "->" . $input->{field} . " ($solverinfo)";
	    }
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

    return '';
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
	    die "$0: Unable to create an output_engine for $outputclass_name";
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

	my $service_name
	    = $output->{service_name} || 'model_container';

	# ask the service the solverinfo for this output

	my $service = $self->{services}->{$service_name}->{ssp_service};

	my $solverinfo = $service->output_2_solverinfo($output);

	if (!ref $solverinfo)
	{
	    if ($output->{warn_only})
	    {
		warn "$0: *** Warning: Failed to construct solver info for the output " . $output->{component_name} . "->" . $output->{field} . " ($solverinfo): " . $output->{warn_only};

		next;
	    }
	    else
	    {
		die "$0: Failed to construct solver info for the output " . $output->{component_name} . "->" . $output->{field} . " ($solverinfo)";
	    }
	}

	# lookup the solver

	my $solver_engine = $self->lookup_solver_engine($solverinfo->{solver});

	# if this is a discrete output

	if ($output->{field} eq 'spike')
	{
	    #1

	    #t connect the solver with the service

	    #t fills in the iTable member for the spikegen intermediary

	    #t fills in the event send function

	    #2

	    #t connect the service with the output engine

	    #t fills in the output object and OutputGeneratorAnnotatedStep() in the distributor_service

	    # get the output field from the solver (is a double *)

	    my $solverfield = $solver_engine->solverfield($solverinfo);

	    if (!defined $solverfield)
	    {
		die "$0: The output " . $output->{component_name} . "->" . $output->{field} . " cannot be found";
	    }

	    # find the output for the output class

	    my $outputclass_name = $output->{outputclass};

	    my $outputclass = $self->{outputclasses}->{$outputclass_name};

	    if (!defined $outputclass)
	    {
		die "$0: The output " . $output->{component_name} . "->" . $output->{field} . " has as outputclass $outputclass_name, but this class cannot be found";
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
		die "$0: The output " . $output->{component_name} . "->" . $output->{field} . " cannot be connected to its output engine (which is determined by the output class in the schedule).";
	    }
	}
	else
	{
	    # get the output field from the solver (is a double *)

	    my $solverfield = $solver_engine->solverfield($solverinfo);

	    if (!defined $solverfield)
	    {
		die "$0: The output " . $output->{component_name} . "->" . $output->{field} . " cannot be found";
	    }

	    # find the output for the output class

	    my $outputclass_name = $output->{outputclass};

	    my $outputclass = $self->{outputclasses}->{$outputclass_name};

	    if (!defined $outputclass)
	    {
		die "$0: The output " . $output->{component_name} . "->" . $output->{field} . " has as outputclass $outputclass_name, but this class cannot be found";
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
		die "$0: The output " . $output->{component_name} . "->" . $output->{field} . " cannot be connected to its output engine (which is determined by the output class in the schedule).";
	    }
	}
    }

    # return success

    return '';
}


sub instantiate_services
{
    my $self = shift;

    # loop over all services

    my $services = $self->{services};

    foreach my $service_name (sort
			      {
				  (
				   (
				    defined $services->{$a}->{order}
				    and defined $services->{$b}->{order}
				    and $services->{$a}->{order} <=> $services->{$b}->{order}
				   )
				   ||
				   1
				  )
			      }
			      keys %$services)
    {
	my $service = $services->{$service_name};

	# start constructing the SSP proxy for the service

	my $ssp_service;

	# if the schedule provides an instantiated backend

	if ($service->{backend})
	{
	    # construct the SSP service for this backend

	    $ssp_service = SSP::Service->new( { backend => $service->{backend}, scheduler => $self, }, );
	}

	# else we have to construct the backend

	else
	{
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

	    $ssp_service = SSP::Service->new( { backend => $backend, scheduler => $self, }, );

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
	}

	# bind the SSP service in the scheduler

	$service->{ssp_service} = $ssp_service;
    }

    # return success

    return '';
}


sub load
{
    my $package = shift;

    my $filename = shift;

    require YAML;

    my $self;

    eval
    {
	$self = YAML::LoadFile($filename);
    };

    if ($@)
    {
	$self = $@;
    }

    return $self;
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
	   # turning on optimize by default currently breaks DES based
	   # simulations because it does not implement the
	   # get_driver() method.

# 	   optimize => 'by default turned on',
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


sub optimize
{
    my $self = shift;

    # set default result: ok

    my $result = '';

    # first update the time

    $self->{simulation_time}
	= {
	   steps => 0,
	   time => 0,
	  };

    # we try to optimize the schedule

    my $optimize = $self->{optimize};

    # if we should try to optimize

    if ($optimize)
    {
	# loop over all schedulees

	my $schedule = $self->{schedule};

	foreach my $schedulee (@$schedule)
	{
	    # optimize the engine

	    my $driver = $schedulee->get_driver();

	    if (!$driver)
	    {
		die "$0: SSP::optimize() failed, no driver found for $schedulee->{name}";
	    }

	    $self->register_driver($driver->{method}, $driver->{data}, $driver->{name} || $schedulee->{name}, );
	}
    }

    # return result

    return $result;
}


sub pause
{
    my $self = shift;

    # set default result: ok

    my $result = '';

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# tell the schedulee that we are pausing the simulation

	my $success = $schedulee->pause();

	if (!$success)
	{
	    die "$0: pause() failed";
	}
    }

    # return result

    return $result;
}


sub reconstruct
{
    my $self = shift;

    #t go through the history and reconstruct the simulation

    return "SSP::reconstruct() is not implemented yet";
}


sub register_driver
{
    my $self = shift;

    my $driver = shift;

    my $driver_data = shift;

    my $driver_name = shift;

    if (c_register_driver($driver, $driver_data, $driver_name) == -1)
    {
	die "$0: register_driver() failed for $driver_name, error return from c_register_driver()";
    }
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

	if ($self->{verbose})
	{
	    print "$0: applying method '$method' to $self->{name}\n";
	}

	my $error = $object->$method($peer, @$arguments);

	if ($error)
	{
	    die "$0: While running $self->{name}: $method failed ($error)";
	}

	# register the method and arguments

	#! note: only adding time() if not running the tests

	push
	    @{$self->{history}},
	    {
	     method => $method,
	     arguments => $arguments,
	     time_stamp => time(),
	    };
    }

    return undef;
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
					    { method => 'connect', },
					    { method => 'initiate', },
					    { method => 'optimize', },
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


sub save
{
    my $self = shift;

    my $filename = shift;

    my $options = shift;

    # simplify the schedule to keep important keys only

    #t perhaps should use Storable::dclone() here

    require Clone;

    my $schedule = Clone::clone($self);

    delete $schedule->{application_classes};

    if (!keys %{$schedule->{analyzers}})
    {
	delete $schedule->{analyzers};
    }

    foreach my $applicator (keys %{$schedule->{apply}})
    {
	if (!@{$schedule->{apply}->{$applicator}})
	{
	    delete $schedule->{apply}->{$applicator};
	}
    }

    if (!keys %{$schedule->{inputclasses}})
    {
	delete $schedule->{inputclasses};
    }

    if (!@{$schedule->{inputs}})
    {
	delete $schedule->{inputs};
    }

    foreach my $model (@{$schedule->{models}})
    {
	if (!@{$model->{conceptual_parameters}})
	{
	    delete $model->{conceptual_parameters};
	}

	if (!@{$model->{granular_parameters}})
	{
	    delete $model->{granular_parameters};
	}
    }

    # process timestamps if requested

    if ($options->{no_history_time_stamps})
    {
	my $history = $schedule->{history};

	foreach my $event (@$history)
	{
	    delete $event->{time_stamp};
	}
    }

    #t settings for event distributor in the heccer solver

    # now put the schedule in the file

    require YAML;

    eval
    {
	YAML::DumpFile($filename, $schedule);
    };

    return $@;
}


sub service_register
{
    my $self = shift;

    my $name = shift;

    my $options = shift;

    if ($self->{services}->{$name})
    {
	die "$0: multiple attempts to create an SSP service with name $name";
    }

    my $ssp_service = SSP::Service->new( $options, );

    $self->{services}->{$name}->{ssp_service} = $ssp_service;

    return undef;
}


sub shell
{
    my $self = shift;

    my $scheduler = shift;

    my $result = '';

    while (my $options = shift)
    {
	my $commands = $options->{commands};

	foreach my $command (@$commands)
	{
	    system "$command";

	    if ($?)
	    {
		print "$0: shell '$command' failed: $?";

		$result = "$0: shell '$command' failed: $?";
	    }
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

    if (!$options->{time_step})
    {
	$options->{time_step} = $self->get_time_step();
    }

    # set default result: ok

    my $result = '';

    # initialize current simulation time

    my $simulation_time = $self->{simulation_time}->{time} || 0;

    my $simulation_steps = $self->{simulation_time}->{steps};

    # if optimization enabled

    my $optimize = $self->{optimize};

    if ($optimize)
    {
	# use the optimizer

	$simulation_time = c_steps($steps, $simulation_time, $self->get_time_step());

	if ($simulation_time == -1)
	{
	    die "$0: scheduling for $steps failed";
	}

	$self->{simulation_time}->{steps} += $steps;
	$self->{simulation_time}->{time} = $simulation_time;

	# return result

	return $result;
    }

    # initial dump

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	my $backend = $schedulee->backend();

	$backend->report( $schedulee, { %$options, steps => undef, time => $simulation_time, }, );
    }

    # a couple of times

    foreach my $step (0 .. $steps - 1)
    {
	$simulation_time += $options->{time_step};

	# loop over all schedulees

	my $schedule = $self->{schedule};

	foreach my $schedulee (@$schedule)
	{
	    # advance the engine

	    my $error = $schedulee->step( $self, { %$options, steps => $simulation_steps, time => $simulation_time, }, );

	    if ($error)
	    {
		die "$0: scheduling for $steps failed ($error)";
	    }

	    # dump

	    my $backend = $schedulee->backend();

	    $backend->report( $schedulee, { %$options, steps => $simulation_steps, time => $simulation_time, }, );
	}

	# update the global time

	$simulation_steps++;
    }

    # maintain global simulation time

    $self->{simulation_time}->{steps} = $simulation_steps;

    $self->{simulation_time}->{time} = $simulation_time;

#     if ($options->{time_step})
#     {
# 	$self->{simulation_time}->{time} += $simulation_steps * $options->{time_step};
#     }
#     else
#     {
# 	undef $self->{simulation_time}->{time};
#     }

    # final report

    foreach my $schedulee (@$schedule)
    {
	my $backend = $schedulee->backend();

	$backend->report( $schedulee, { %$options, steps => -1, time => $simulation_time, }, );
    }

    # return result

    return $result;
}


sub version
{
    # $Format: "    my $version=\"${package}-${label}\";"$
    my $version="ssp-alpha";

    return $version;
}


package SSP::Debug;


our $debug_output_file;


# the SSP::Debug package dumps a small report on each scheduler method
# invocation, then forwards each invocation to the original package
# (by removing ::Debug from the name of the package of the sub).

sub AUTOLOAD
{
    no strict "refs";

    my $subname = $SSP::Debug::AUTOLOAD;

    my $report = { '1_DEBUG_subname' => $subname, '2_DEBUG_arguments' => \@_ };

    require YAML;

    my $report_text = YAML::Dump($report);

    if ($debug_output_file)
    {
	print $debug_output_file $report_text;
    }
    else
    {
	print $report_text;
    }

    #! this assumes that there is only one possible SSP package,
    #! something that seems true for the foreseeable future.

    $subname =~ s/::Debug//;

    # these methods do not get defined perhaps, so we should not call them if so

    my $undefined_methods
	= {
	   '::DESTROY' => 1,
	   'others ?' => 0,
	  };

    # if attempt to call an undefined method

    foreach my $undefined_method (grep { $undefined_methods->{$_} } keys %$undefined_methods)
    {
	if ($subname =~ /$undefined_method$/
	    && !eval "defined(\&$undefined_method)")
	{
	    if ($::option_verbose)
	    {
		print "undefined_method $subname\n";
	    }

	    # just return success

	    #! or should we return something else ?  perhaps undef ?

	    return 1;
	}
    }

    # call method, return result

    return &$subname(@_);
}


package SSP::Base;



sub backend
{
    my $self = shift;

    return $self->{backend};
}


# sub optimize
# {
#     my $self = shift;

#     my $backend = $self->backend();

# #     my $method = $backend->optimize();

#     return 0;
# }


package SSP::Schedulee;


BEGIN { our @ISA = qw(SSP::Base); }


sub get_driver
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->get_driver();

    return $result;
}


sub get_time_step
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->get_time_step($self);

    return $result;
}


sub pause
{
    my $self = shift;

    my $backend = $self->backend();

    # if this schedulee does not know about pause

    if ($backend->can('pause'))
    {
	return $backend->pause();
    }
    else
    {
	return 1;
    }
}


package SSP::Analyzer;


BEGIN { our @ISA = qw(SSP::Base); }


sub analyze
{
    my $self = shift;
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

    return $self;
}


package SSP::Engine;


BEGIN { our @ISA = qw(SSP::Schedulee); }


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

    my $result = '';

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

    my $event_distributor = $self->{event_distributor}->{ssp_service};

    my $event_distributor_backend
	= $event_distributor && $event_distributor->backend();

    my $event_queuer = $self->{event_queuer}->{ssp_service};

    my $event_queuer_backend
	= $event_queuer && $event_queuer->backend();

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
	= $package->new
	    (
	     {
	      #t can create a circular reference but is convenient, not sure

	      %$constructor_settings,

	      #t it would be much better if the constructor uses the
	      #t services of SSP: model_container, event_distributor and
	      #t possibly others.

	      model_source => {
			       service_name => $service_name,
			       service_backend => $service_backend,
			       modelname => $modelname,
			      },
	      event_distributor => {
# 				    event_distributor_name => $event_distributor_name,
				    event_distributor_backend => $event_distributor_backend,
				   },
	      event_queuer => {
# 			       event_queuer_name => $event_queuer_name,
			       event_queuer_backend => $event_queuer_backend,
			      },
	     },
	    );

    # register the engine with the schedulee

    $self->{backend} = $engine;

    if (ref $engine)
    {
	$result = $engine->compile($scheduler);
    }
    else
    {
	$result = "error: $engine";
    }

    # return result

    return $result;
}


sub connect
{
    my $self = shift;

    my $scheduler = shift;

    # set default result: ok

    my $result = 1;

    # connect this solver

    my $backend = $self->{backend};

    $result = $backend->connect($scheduler);

    # return result

    return $result;
}


sub deserialize
{
    my $self = shift;

    my $filename = shift;

    my $backend = $self->backend();

    # we replace the backend with the one we create from the file

    my $new_backend = $backend->deserialize2($filename);

    if ($new_backend)
    {
	$self->{backend} = $new_backend;

	return 1;
    }
    else
    {
	return 0;
    }
}


sub deserialize_state
{
    my $self = shift;

    my $filename = shift;

    my $backend = $self->backend();

    return $backend->deserialize_state($filename);
}


sub finish
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->finish($self);

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


sub serialize
{
    my $self = shift;

    my $filename = shift;

    my $backend = $self->backend();

    return $backend->serialize($filename);
}


sub serialize_state
{
    my $self = shift;

    my $filename = shift;

    my $backend = $self->backend();

    return $backend->serialize_state($filename);
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

    #t my $scheduler = shift;

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


BEGIN { our @ISA = qw(SSP::Schedulee); }


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


sub connect
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->connect($self);
}


sub finish
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->finish($self);
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
	$result = "SSP::Input::step() failed";
    }

    # return result

    return $result;
}


package SSP::Output;


BEGIN { our @ISA = qw(SSP::Schedulee); }


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


sub connect
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->connect($self);
}


sub finish
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->finish($self);
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
	$result = "SSP::Output::step() failed";
    }

    # return result

    return $result;
}


package SSP::Service;


BEGIN { our @ISA = qw(SSP::Base); }


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


