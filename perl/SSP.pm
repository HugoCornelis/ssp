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

	my $engine = SSP::Engine->new($solverclass, $service, $modelname);

	# compile the model

	if (!$engine->compile($self))
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
3. The service module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $service_module'
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

    # loop over all schedulees

    my $schedule = $self->{schedule};

    foreach my $schedulee (@$schedule)
    {
	# advance the engine

	my $error = $schedulee->steps($steps, $verbose);

	if ($error)
	{
	    die "Scheduling for $steps failed";
	}
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

    my $service_name = $scheduler->{solverclasses}->{$solverclass}->{service_name};

    my $solver_module = $scheduler->{solverclasses}->{$solverclass}->{module_name};

    #! the service points into the scheduler, but is not the service object

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
   e.g. for Heccer, you need to configure the package with --with-neurospaces
3. The solverclass module is not correct, to find out, type perl -e 'push \@INC, \"/usr/local/glue/swig/perl\" ; require $solver_module'
4. Contact your system administrator.

$@";
    }

    my $engine
	= $solver_module->new
	    (
	     {
	      service_name => $service_name,
	      service_backend => $service_backend,
	      modelname => $modelname,
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


sub new
{
    my $package = shift;

    my $solverclass = shift;

    my $service = shift;

    my $modelname = shift;

    my $self
	= {
	   modelname => $modelname,
	   service => $service,
	   solverclass => $solverclass,
	  };

    bless $self, $package;

    return $self;
}


sub steps
{
    my $self = shift;

    my $steps = shift;

    my $verbose = shift;

    # set result : ok

    my $result;

    # initial dump

    $verbose && print "Initiated\n";

    my $backend = $self->backend();

    $verbose && $backend->dump($Heccer::config->{tested_things});

    # a couple of times

    my $final_report = 0;

    foreach my $i (0 .. $steps - 1)
    {
	# step

	my $success = $backend->step();

	if (!$success)
	{
	    $result = "HeccerHecc() failed";
	}

	if (($i % ($Heccer::config->{reporting_granularity})) == 0)
	{
	    # dump

	    $verbose && print "-------\n";

	    $verbose && print "Iteration $i\n";

	    $verbose && $backend->dump(undef, $Heccer::config->{tested_things});
	}
	else
	{
	    $final_report = 1;
	}
    }

    if ($final_report)
    {
	$verbose && print "-------\n";

	$verbose && print "Iteration " . ($Heccer::config->{steps}) . "\n";

	$verbose && $backend->dump(undef, $Heccer::config->{tested_things});
    }

    # return result

    return $result;
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


1;


