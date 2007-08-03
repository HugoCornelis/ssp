#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--help',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Is a help message been given ?",
						   read => [
							    '-re',
							    '
.*ssp <configuration>

.*ssp: run simulations, given an ssp configuration, or using a builtin configuration

try .*ssp --builtins for information of how to run a simulation easily

options :
    builtins           give help about supported builtin configurations
    cell               use the cell builtin configuration
    emit-schedules     print schedules to stdout instead of running them.
    help               print usage information.
    inject-soma        amount of current injected into the soma.
    model-directory    name of the directory where to look for non-std models
    model-filename     filename of the model description file \(when using a builtin configuration\)
    model-name         name of the model \(when using a builtin configuration\)
    neurospaces-models directory where to find the neurospaces library
    set-name           overwrite the schedule name with the name of the file that contains the schedule
    set-outputclass-filename
                       overwrite the outputclass filename with something derived from the name of the
                       file that contains the schedule
    solverclass        set the solver class to use \(when using a builtin configuration\)
    spine-prototype    add spines with this prototype
    steps              number of simulation steps
    time-step          sets the time step
    transformator      feed the configuration through this transformator before running
    verbose            set verbosity level.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "help message",
			       },
			       {
				arguments => [
					      '--builtins',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "What are the builtin simulation configuration templates ?",
						   read => [
							    '-re',
							    '
.*ssp <configuration>

.*ssp: run simulations, given an ssp configuration, or using a builtin configuration

Known builtin configurations:


cell:


	Simulate a cell, default is to output the membrane potential of the soma.
	A current injection of 2e-9 is given \(unless overwritten using the options\).
	The soma segment must reside in a SEGMENT_GROUP with name "segments".

	--model-filename set the model filename, and filename of the output file.
	--steps sets number of steps
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "builtin configuration message",
			       },
			      ],
       description => "command line switches",
       name => 'switches.t',
      };


return $test;


