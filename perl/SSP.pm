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
	    die "Scheduling for $time failed";
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
	# instantiate a schedulee

	my $modelname = $model->{modelname};

	my $solverclass = $model->{solverclass};

	my $service = $self->{services}->{$solverclasses->{$solverclass}->{service_name}};

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

    # loop over all outputs

    my $outputs = $self->{outputs};

    my $schedule = $self->{schedule};

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

	# lookup the solver

	my $solver_engine = $self->lookup_solver_engine($solverinfo->{solver});

	# get the output field from the solver (is a double *)

	my $solverfield = $solver_engine->solverfield($solverinfo);

	# create the engine for the output

	my $output_name = $output->{component_name} . "->" . $output->{field};

	my $output_engine
	    = SSP::Output->new
		(
		 {
		  class => $output,
		  field => $solverfield,
		  name => $output_name,
		 },
		);

	# schedule the output_engine

	push @$schedule, $output_engine;
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
3. The service module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $service_module', and see if perl can find the solverclass module
4. Contact your system administrator.

$@";
	}

	my $backend = $service_module->new();

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

    # get initializers and simulation specifications, using defaults
    # where needed

    my $initializers
	= $self->{apply}->{initializers}
	    || [
		{ method => 'compile', },
		{ method => 'initiate', },
	       ],
		   ;

    my $simulation = $self->{apply}->{simulation} || [];

    # construct the schedule we have to apply

    my $applications = [ @$initializers, @$simulation, ];

    # go through the schedule

    foreach my $application (@$applications)
    {
	# get method and arguments

	my $method = $application->{method};

	my $arguments = $application->{arguments};

	# apply the method

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

	    my $error = $schedulee->step($verbose);

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

    my $schedule = $self->{schedule};

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
3. The solverclass module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $solver_module', and see if perl can find the solverclass module
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

    $result = $engine->compile();

    # return result

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

    my $verbose = shift;

    # set result : ok

    my $result;

    # step

    my $backend = $self->backend();

    my $success = $backend->step();

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


sub new
{
    my $package = shift;

    my $options = shift;

    my $self = { %$options, };

    bless $self, $package;

    return $self;
}


package SSP::Service;


BEGIN { our @ISA = qw(SSP::Glue); }


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


