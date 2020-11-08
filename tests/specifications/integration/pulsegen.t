#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::global_config->{core_directory}/yaml/heccer/pulsegen_freerun.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we perform a pulsegen on a basic compartment in free run mode ?",
						   wait => 5,
						   read => {
							    application_output_file => "/tmp/output",
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/pulse0.txt",
							   },
						  },
						 ],
				description => "pulsegen on a basic compartment, free run mode",
				harnessing => {
					       preparation => {
							       description => "Delete the output file",
							       preparer =>
							       sub
							       {
								   `rm -f /tmp/output`;
							       },
							      },
					       reparation => {
							      description => "Remove the generated output files in the results directory",
							      reparer =>
							      sub
							      {
								  `rm -f /tmp/output`;
							      },
							     },
					      },
			       },
			       {
				arguments => [
					      "$::global_config->{core_directory}/yaml/heccer/pulsegen_exttrig.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we perform a pulsegen on a basic compartment in ext trigger mode ?",
						   wait => 5,
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/pulse1.txt",
							   },
						  },
						 ],
				description => "pulsegen on a basic compartment, ext trigger mode",
				harnessing => {
					       preparation => {
							       description => "Delete the output file",
							       preparer =>
							       sub
							       {
								   `rm -f /tmp/output`;
							       },
							      },
					       reparation => {
							      description => "Remove the generated output files in the results directory",
							      reparer =>
							      sub
							      {
								  `rm -f /tmp/output`;
							      },
							     },
					      },
			       },
			       {
				arguments => [
					      "$::global_config->{core_directory}/yaml/heccer/pulsegen_extgate.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we perform a pulsegen on a basic compartment in ext gate mode ?",
						   wait => 5,
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::global_config->{core_directory}/tests/specifications/strings/pulse2.txt",
							   },
						  },
						 ],
				description => "pulsegen on a basic compartment, ext gate mode",
				harnessing => {
					       preparation => {
							       description => "Delete the output file",
							       preparer =>
							       sub
							       {
								   `rm -f /tmp/output`;
							       },
							      },
					       reparation => {
							      description => "Remove the generated output files in the results directory",
							      reparer =>
							      sub
							      {
								  `rm -f /tmp/output`;
							      },
							     },
					      },
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--pulsegen-triggermode',
					      '0',
					      '--emit-schedule',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Are pulsegen command line options processed correctly? ",
						   read => [
							    '-re',
							    '
apply:
  simulation:
    - arguments:
        - 0.05
        - verbose: 0
      method: advance
inputclasses:
  pulsegen:
    module_name: Experiment
    options:
      baselevel: 10
      delay1: 5
      delay2: 8
      level1: 50
      level2: -20
      triggermode: 0
      width1: 3
      width2: 5
    package: Experiment::PulseGen
inputs:
  - component_name: /Purkinje/segments/soma
    field: Vm
    inputclass: pulsegen
models:
  - modelname: /Purkinje
    runtime_parameters: \[\]
    solverclass: heccer
name: \'builtin cell configuration, applied to: /Purkinje\'
optimize: \'by default turned on, ignored when running in verbose mode\'
outputclasses:
  double_2_ascii:
    module_name: Experiment
    options:
      filename: ./output/Purkinje.out
    package: Experiment::Output
outputs:
  - component_name: /Purkinje/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - .*bin/ssp
            - -P
            - cells/purkinje/edsjb1994.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
',
							   ],
						  },
						 ],
				description => "pulsegen command line option processing",
			       },
			      ],
       description => "pulsegen testing",
       name => 'integration/pulsegen.t',
      };


return $test;


