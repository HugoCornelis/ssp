#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package SSP;


sub advance
{
    my $self = shift;

    my $time = shift;

    my $verbose = shift;

    # set default result : ok

    my $result = 1;

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# advance the engine

	my $error = $schedulee->advance($time, $verbose);

	if ($error)
	{
	    die "Advancing time to $time failed";
	}
    }

    # return result

    return $result;
}


sub compile
{
    my $self = shift;

    # set default result : ok

    my $result = 1;

    # first instantiate the services

    if (!$self->instantiate_services())
    {
	return 0;
    }

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

	my $conceptual_parameter_application
	    = $service->{ssp_service}->apply_conceptual_parameters($model->{conceptual_parameters});

	if (defined $conceptual_parameter_application)
	{
	    die "Cannot apply conceptual_parameters: $conceptual_parameter_application";
	}

	# apply the granular_parameter settings to the model

	my $granular_parameter_application
	    = $service->{ssp_service}->apply_granular_parameters($model->{granular_parameters});

	if (defined $granular_parameter_application)
	{
	    die "Cannot apply granular_parameters: $granular_parameter_application";
	}

	# instantiate a schedulee

	my $solverclass_options = $solverclasses->{$solverclass};

	my $options
	    = {
	       %$solverclass_options,
	       modelname => $modelname,
	       solverclass => $solverclass,
	       service => $service,
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

    # prepare outputs

    if (!$self->instantiate_outputs())
    {
	return 0;
    }

    # return result

    return $result;
}


sub finish
{
    my $self = shift;

    # set default result : ok

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


sub initiate
{
    my $self = shift;

    # set default result : ok

    my $result = 1;

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# advance the engine

	my $success = $schedulee->initiate();

	if (!$success)
	{
	    die "Initiation failed";
	}
    }

    # return result

    return $result;
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

	# get the output field from the solver (is a double *)

	my $solverfield = $solver_engine->solverfield($solverinfo);

	if (!defined $solverfield)
	{
	    die "The output " . $output->{component_name} . "->" . $output->{field} . " cannot be found";
	}

	# find the output for the output class

	my $outputclass_name = $output->{outputclass};

	my $outputclass = $self->{outputclasses}->{$outputclass_name};

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
	    die "Cannot load service module ($service_module.pm) for service $service_name

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this service.
3. The service module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $service_module', and see if perl can find and compile the service module
4. Contact your system administrator.

$@";
	}

	my $backend = $service_module->new($service);

	# construct the SSP service for this backend

	my $ssp_service = SSP::Service->new( { backend => $backend, }, );

	# initialize the service backend with the user settings

	my $initializers = $service->{initializers};

	foreach my $initializer (@$initializers)
	{
	    my $method = $initializer->{method};

	    my $arguments = $initializer->{arguments};

	    my $success = $backend->$method(@$arguments);

	    if (!$success)
	    {
		die "initializer $method for $service_name failed";
	    }
	}

	# bind the SSP service in the scheduler

	$service->{ssp_service} = $ssp_service;
    }

    # return success

    return 1;
}


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

    return $self;
}


sub run
{
    my $self = shift;

    my $verbose = shift;

    # get initializers and simulation specifications, using defaults
    # where needed

    my $initializers
	= $self->{apply}->{initializers}
	    || [
		{ method => 'compile', },
		{ method => 'initiate', },
	       ],
		   ;

    my $finishers
	= $self->{apply}->{finishers}
	    || [
		{ method => 'finish', },
	       ],
		   ;

    my $simulation = $self->{apply}->{simulation} || [];

    # construct the schedule we have to apply

    my $applications = [ @$initializers, @$simulation, @$finishers, ];

    # go through the schedule

    foreach my $application (@$applications)
    {
	# get method and arguments

	my $method = $application->{method};

	my $arguments = $application->{arguments};

	# apply the method

	if ($verbose)
	{
	    print "$0: applying method '$method' to $self->{name}\n";
	}

	my $success = $self->$method(@$arguments);

	if (!$success)
	{
	    die "while running $self->{name}: $method failed";
	}
    }
}

sub steps
{
    my $self = shift;

    my $steps = shift;

    my $verbose = shift;

    # set default result : ok

    my $result = 1;

    # initial dump

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	my $backend = $schedulee->backend();

	$backend->report( { steps => undef, verbose => $verbose, }, );
    }

    # a couple of times

    foreach my $step (0 .. $steps - 1)
    {
	# loop over all schedulees

	my $schedule = $self->{schedule};

	foreach my $schedulee (@$schedule)
	{
	    # advance the engine

	    my $error = $schedulee->step( { steps => $step, verbose => $verbose, }, );

	    if ($error)
	    {
		die "Scheduling for $steps failed";
	    }

	    # dump

	    my $backend = $schedulee->backend();

	    $backend->report( { steps => $step, verbose => $verbose, }, );
	}
    }

    # final report

    foreach my $schedulee (@$schedule)
    {
	my $backend = $schedulee->backend();

	$backend->report( { steps => -1, verbose => $verbose, }, );
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


package SSP::Engine;


BEGIN { our @ISA = qw(SSP::Glue); }


sub advance
{
    my $self = shift;

    my $time = shift;

    # set result : ok

    my $result;

    my $backend = $self->backend();

    my $success = $backend->advance($time);

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

    # set default result : ok

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
	die "Cannot load solver module ($solver_module.pm) for solverclass $solverclass

Possible solutions:
1. Set perl include variable \@INC, using the -I switch, or by modifying your program code that uses SSP.
2. Install the correct integration module for this solver.
   e.g. for Heccer, you need to configure Heccer with --with-neurospaces
3. The solverclass module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $solver_module', and see if perl can find and compile the solverclass module
4. Contact your system administrator.

$@";
    }

    my $constructor_settings = $self->{constructor_settings} || {};

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

    my $result = $backend->finish();

    return $result;
}


sub initiate
{
    my $self = shift;

    my $backend = $self->backend();

    my $result = $backend->initiate();

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

    my $self
	= {
	   %$options,
	  };

    bless $self, $package;

    return $self;
}


sub solverfield
{
    my $self = shift;

    my $fieldinfo = shift;

    my $backend = $self->backend();

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

    my $success = $backend->step($options);

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

    my $verbose = shift;

    # set result : ok

    my $result;

    # initial dump

    my $backend = $self->backend();

    $backend->report( { steps => undef, verbose => $verbose, }, );

    # a couple of times

    foreach my $i (0 .. $steps - 1)
    {
	# step

	my $success = $backend->step();

	if (!$success)
	{
	    $result = "HeccerHecc() failed";
	}

	# dump

	$backend->report( { steps => $i, verbose => $verbose, }, );
    }

    $backend->report( { steps => -1, verbose => $verbose, }, );

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

    my $result = $backend->add($options);

    return $result;
}


sub advance
{
    my $self = shift;

    my $options = shift;

    my $backend = $self->backend();

    my $result = $backend->advance($options);

    return $result;
}


sub finish
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->finish();
}


sub initiate
{
    my $self = shift;

    # lookup the method

    my $backend = $self->backend();

    return $backend->initiate();
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
	die "Cannot load output module ($output_module.pm) for output class $output_name

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

	my $options = $self->{options} || {};

	my $output_package = $self->{package};

	my $backend
	    = $output_package->new
		(
		 {
		  %$options,
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

    my $options = shift;

    # set result : ok

    my $result;

    # step

    my $backend = $self->backend();

    my $success = $backend->step($options);

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

    my $result = $service_backend->apply_conceptual_parameters($options);

    return $result;
}


sub apply_granular_parameters
{
    my $self = shift;

    my $options = shift;

    my $service_backend = $self->backend();

    my $result = $service_backend->apply_granular_parameters($options);

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

    my $result = $backend->register_engine($engine, $modelname);

    return $result;
}


1;


