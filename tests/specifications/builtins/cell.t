#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--emit',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we run a single neuron model from the cell builtin schedule ?",
						   read => '
analyzers: {}
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
      - method: initiate
    priority: 80
  modifiers:
    default: []
    priority: 50
  results:
    default: []
    priority: 170
  services:
    default:
      - method: instantiate_services
    priority: 20
  simulation:
    default: []
    priority: 110
apply:
  simulation:
    - arguments:
        - 2500
        - verbose: 0
      method: steps
models:
  - granular_parameters: []
    modelname: /stand_alone
    solverclass: heccer
name: \'builtin cell configuration, applied to: stand_alone\'
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: ./output/stand_alone
    package: Heccer::Output
outputs:
  - component_name: /stand_alone/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  neurospaces:
    initializers:
      - arguments:
          -
            - ./bin/ssp
            - -P
            - cells/stand_alone.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: neurospaces
',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "single neuron model from the cell builtin schedule",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--inject',
					      '2e-8',
					      '--emit',
					      '--output',
					      "/stand_alone/segments/soma->Vm",
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we run a single neuron model from the cell builtin schedule, soma Vm output, soma current injection ?",
						   read => '
analyzers: {}
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
      - method: initiate
    priority: 80
  modifiers:
    default: []
    priority: 50
  results:
    default: []
    priority: 170
  services:
    default:
      - method: instantiate_services
    priority: 20
  simulation:
    default: []
    priority: 110
apply:
  simulation:
    - arguments:
        - 2500
        - verbose: 0
      method: steps
models:
  - granular_parameters:
      - component_name: /stand_alone/segments/soma
        field: INJECT
        value: 2e-8
    modelname: /stand_alone
    solverclass: heccer
name: \'builtin cell configuration, applied to: stand_alone\'
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: ./output/stand_alone
    package: Heccer::Output
outputs:
  - component_name: /stand_alone/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  neurospaces:
    initializers:
      - arguments:
          -
            - ./bin/ssp
            - -P
            - cells/stand_alone.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: neurospaces
',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "single neuron model from the cell builtin schedule, soma Vm output, soma current injection",
			       },
			      ],
       description => "cell builtin schedule",
       name => 'cell.t',
      };


return $test;


