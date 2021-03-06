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

options:
    --builtins           give help about supported builtin simulation configurations.
    --daemonize          detach from terminal, close shared resources and run in the background,
                         note that this option currently inhibits any feedback of the process,
                         so be cautious with it.
    --debug              set to a string of the debugging package, 1 for a default of SSP::Debug.
    --dump               install dumpers for analyzers.
    --dump-extended      dump more, also dumps discretized tables ao.
    --emit-output        files to write to stdout after the simulation finishes.
    --emit-schedules     print schedules to stdout instead of running them.
    --help               print usage information.
    --history            emit a record of the history of the simulation after it finishes.
    --history-timestamps emit timestamps with schedule history records.
    --inject-delay       delay of the current injection protocol.
    --inject-duration    duration of the current injection protocol.
    --inject-magnitude   amount of current injected into the soma.
    --inject-site        site of current injection.
    --model-directory    name of the directory where to look for non-std models.
    --model-filename     filename of the model description file \(when using a builtin configuration\).
    --model-name         name of the model \(when using a builtin configuration\).
    --neurospaces-models directory where to find the neurospaces library.
    --neurospaces-studio replace the simulation routine with calls to the neurospaces studio,
                         this allows to explore the model after all modifiers have completed.
    --optimize           turn on the schedule optimizer.
    --output-fields      define an output, can be given multiple times.
    --parameters         set a specific parameter value, can be given multiple times.
    --perfectclamp       set the command voltage for the perfect clamp protocol.
    --pulsegen-width1    set the pulse width for the pulsegen protocol.
    --pulsegen-level1    set the pulse level for the pulsegen protocol.
    --pulsegen-delay1    set the pulse delay for the pulsegen protocol.
    --pulsegen-width2    set the pulse width for the pulsegen protocol.
    --pulsegen-level2    set the pulse level for the pulsegen protocol.
    --pulsegen-delay2    set the pulse delay for the pulsegen protocol.
    --pulsegen-baselevel set the pulse base level for the pulsegen protocol.
    --pulsegen-triggermode  set the triggermode for the pulsegen protocol.
    --s-cell             simulate a single cell, requires the cell model filename as argument.
    --s-network          simulate a network, requires the network model filename as argument.
    --set-name           overwrite the schedule name with the name of the file that contains the schedule.
    --set-outputclass-filename
                         overwrite the outputclass filename with something derived from the name of the
                         file that contains the schedule.
    --solverclass        set the solver class to use \(when using a builtin configuration\).
    --spine-prototype    add spines with this prototype.
    --steps              number of simulation steps, when using one of the builtin configurations.
    --time               set simulation time \(in seconds\).
    --time-step          sets the time step, when using one of the builtin configurations.
    --transformator      feed the configuration through this transformator before running.
    --verbose            set verbosity level.
    --version            give version information.
',
							   ],
						   timeout => 3,
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
',
							   ],
						   timeout => 3,
						  },
						  {
						   description => "What are the builtin simulation configuration templates ?",
						   read => '
---
cell: |+2
  
  	Simulate a single neuron model.  Default is to output the membrane potential of the soma.
  	Use the options to inject current in the soma (--inject-magnitude), or alternatively
  	to set a command voltage (--perfectclamp).
  	The model\'s soma segment can reside inside a SEGMENT_GROUP with name "segments",
  	or alternatively reside inside the cell with name the name of the model neuron.
  
          The name of the model neuron is inferred from the name of the model description file.
          (e.g. a model description file called "examples/hh_neuron.ndf" is assumed to define a model neuron
          called "hh_neuron").
  
  Additional Options Overriding Internal Default Settings:
  
  	--model-name overwrite the default model name.
  	--steps sets number of steps
  	--time-step time step
  
  Example usage: ssp --cell examples/hh_neuron.ndf
  

network: |+2
  
  	Simulate a network model.  Default is to output the membrane potential of the soma of all
          the neurons in the network.
  	Use the options to inject current in the soma (--inject-magnitude) of some of the neurons,
  	or alternatively to set a command voltages (--perfectclamp).
  	The model\'s soma segment must reside in a SEGMENT_GROUP with name "segments".
  
          The name of the model network is inferred from the name of the model description file.
          (e.g. a model description file called "examples/rsnet.ndf" is assumed to define a model network
          called "rsnet").
  
  Additional Options Overriding Internal Default Settings:
  
  	--model-name overwrite the default model name.
  	--steps sets number of steps
  	--time-step time step
  
  Example usage: ssp --network examples/rsnet.ndf
  


',
						  },
						 ],
				description => "builtin configuration message",
			       },
			      ],
       description => "command line switches",
       name => 'ssp/switches.t',
      };


return $test;


