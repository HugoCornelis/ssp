#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--cell',
					      'tests/cells/channel_response.ndf',
					      '--dump',
					      '--emit-schedules',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "What does a schedule look like when we apply a perfect clamp to obtain a channel's response ?",
						   read => [
							    '-re',
							    '
analyzers:
  dumper:
    initializers:
      - arguments:
          - source: model_container::/channel_response
          - ~
          - ~
        method: dump
    module_name: Heccer
    package: Heccer::Dumper
application_classes:
  analyzers:
    default:
      - method: analyze
    priority: 95
  finishers:
    default:
      - method: finish
    priority: 140
  initializers:
    default:
      - method: compile
      - method: instantiate_inputs
      - method: instantiate_outputs
      - method: connect
      - method: initiate
      - method: optimize
    priority: 80
  modifiers:
    default: \[\]
    priority: 50
  results:
    default: \[\]
    priority: 170
  services:
    default:
      - method: instantiate_services
    priority: 20
  simulation:
    default: \[\]
    priority: 110
apply:
  simulation:
    - arguments:
        - 0.05
        - verbose: 0
      method: advance
models:
  - granular_parameters: \[\]
    modelname: /channel_response
    solverclass: heccer
name: \'builtin cell configuration, applied to: channel_response\'
optimize: \'by default turned on, ignored when running in verbose mode\'
outputclasses:
  double_2_ascii:
    module_name: Experiment
    options:
      filename: ./output/channel_response.out
    package: Experiment::Output
outputs:
  - component_name: /channel_response/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - .*?/ssp
            - -P
            - tests/cells/channel_response.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
usage: \|2
  
  	Simulate a single neuron model, default is to output the membrane potential of the soma.
  	Use the options to inject current in the soma \(--inject-magnitude\), or alternatively
  	to set a command voltage \(--perfectclamp\).
  	The model\'s soma segment must reside in a SEGMENT_GROUP with name "segments".
  
          The name of the model neuron is inferred from the name of the model description file.
          \(e.g. a model description file called "examples/hh_neuron.ndf" is assumed to define a model neuron
          called "hh_neuron"\).
  
  Additional Options Overriding Internal Default Settings:
  
  	--model-name overwrite the default model name.
  	--steps sets number of steps
  
  Example usage: ssp --cell examples/hh_neuron.ndf
verbose: ~
',
							   ],
						  },
						 ],
				description => "using perfect clamp to obtain a channel response, schedule output",
			       },
			       {
				arguments => [
					      '--cell',
					      'tests/cells/channel_response.ndf',
					      '--output',
					      'channel_response/segments/soma/naf->G',
					      '--output',
					      'channel_response/segments/soma/naf->I',
					      '--time-step',
					      '6e-6',
					      '--time',
					      '0.006',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "What is the current and conductance output of this simulation ?",
						   read => {
							    application_output_file => 'output/channel_response.out',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/channel-response.txt",
							   },
						   wait => 4,
						  },
						 ],
				description => "current and conductance output of this simulation",
			       },
			      ],
       description => "using perfect clamp to obtain a channel response",
       name => 'integration/channel_response.t',
      };


return $test;


