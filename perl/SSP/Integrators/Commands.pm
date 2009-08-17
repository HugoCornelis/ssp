#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package SSP::Integrators::Commands;


use strict;


use SSP;


our $g3_commands
    = [
       'ssp_load',
       'ssp_load_help',
       'ssp_save',
       'ssp_save_help',
      ];


sub ssp_load
{
    my $modelname = shift;

    my $filename = shift;

    my $scheduler = SSP->load($filename);

    if (!ref $scheduler)
    {
	return "*** Error: loading schedule failed ($scheduler)";
    }

    # extract the schedule name

    my $schedulename = $scheduler->{name};

    if (!$schedulename)
    {
	return "*** Error: loading schedule failed: unable to determine a schedulename";
    }

    if ($scheduler->{models}->[0]->{modelname} ne $modelname)
    {
	return "*** Error: loading schedule failed: does not match with $modelname";
    }

    # go through the history and reconstruct the simulation

    my $error = $scheduler->reconstruct();

    if ($error)
    {
	return $error;
    }

    # register the scheduler

    $GENESIS3::schedulers->{$modelname} = $scheduler;

    return "*** Ok: ssp_load $filename";
}


sub ssp_load_help
{
    print "description: load an ssp file and reconstruct the model it describes.\n";

    print "synopsis: ssp_load <modelname> <filename.ssp>\n";

    return "*** Ok";
}


sub ssp_save
{
    my $modelname = shift;

    my $filename = shift;

    GENESIS3::Commands::run($modelname, 0);

    # get scheduler for this model

    my $scheduler = $GENESIS3::schedulers->{$modelname};

    if (!$scheduler)
    {
	return "*** Error: no simulation was previously run for $modelname, no scheduler found";
    }

    # reset the schedule

    if ($scheduler->save($filename))
    {
	return "*** Error: saving schedule failed ($@)";
    }
    else
    {
	print "Schedule saved ok\n";
	
	return "*** Ok";
    }

    return "*** Ok: ssp_save $filename";
}


sub ssp_save_help
{
    print "description: save a model to an ssp file.\n";

    print "synopsis: ssp_save <element_name> <filename>\n";

    return "*** Ok";
}


