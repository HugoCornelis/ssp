#!/usr/bin/perl -w
#

use strict;


my $loaded;

eval
{
    local $SIG{__DIE__};

    { $loaded = eval "require Neurospaces::Studio"; };
};

my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--emit-schedules',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we construct a schedule of a single neuron model from the cell builtin schedule ?",
						   read => [
							    '-re',
							    '
analyzers: \{\}
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
    modelname: /stand_alone
    solverclass: heccer
name: \'builtin cell configuration, applied to: stand_alone\'
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: ./output/stand_alone\.out
    package: Heccer::Output
outputs:
  - component_name: /stand_alone/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - (.*?)/bin/ssp
            - -P
            - cells/stand_alone.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "schedule construction of a single neuron model from the cell builtin schedule",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--inject-magnitude',
					      '2e-8',
					      '--emit-schedules',
					      '--output',
					      "/stand_alone/segments/soma->Vm",
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we construct a schedule of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection ?",
						   read => [
							    '-re',
							    '
analyzers: \{\}
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
      filename: ./output/stand_alone\.out
    package: Heccer::Output
outputs:
  - component_name: /stand_alone/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - (.*?)/bin/ssp
            - -P
            - cells/stand_alone.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "schedule construction of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--parameter',
					      "/stand_alone/segments/soma->INJECT=2e-8",
					      '--emit-schedules',
					      '--output',
					      "/stand_alone/segments/soma->Vm",
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we construct a schedule of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection specified as a parameter ?",
						   read => [
							    '-re',
							    '
analyzers: \{\}
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
      filename: ./output/stand_alone\.out
    package: Heccer::Output
outputs:
  - component_name: /stand_alone/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - (.*?)/bin/ssp
            - -P
            - cells/stand_alone.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "schedule construction of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection specified as a parameter",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--inject-magnitude',
					      '2e-8',
					      '--inject-delay',
					      '0.01',
					      '--inject-duration',
					      '0.03',
					      '--time',
					      '0.06',
					      '--emit-schedules',
					      '--output',
					      "/stand_alone/segments/soma->Vm",
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we construct a schedule of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection with set duration and simulation time ?",
						   read => [
							    '-re',
							    '
analyzers: \{\}
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
        - 0.01
        - verbose: 0
      method: advance
    - arguments:
        - component_name: /stand_alone/segments/soma
          field: INJECT
          modelname: /stand_alone
          value: 2e-8
      method: apply_granular_parameters
    - arguments:
        - 0.03
        - verbose: 0
      method: advance
    - arguments:
        - component_name: /stand_alone/segments/soma
          field: INJECT
          modelname: /stand_alone
          value: 0
      method: apply_granular_parameters
    - arguments:
        - 0.02
        - verbose: 0
      method: advance
models:
  - granular_parameters: \[\]
    modelname: /stand_alone
    solverclass: heccer
name: \'builtin cell configuration, applied to: stand_alone\'
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: ./output/stand_alone\.out
    package: Heccer::Output
outputs:
  - component_name: /stand_alone/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - (.*?)/bin/ssp
            - -P
            - cells/stand_alone.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "schedule construction of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection with set duration and simulation time",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--inject-magnitude',
					      '2e-8',
					      '--inject-delay',
					      '0.01',
					      '--inject-duration',
					      '0.03',
					      '--time',
					      '0.06',
					      '--output',
					      "/stand_alone/segments/soma->Vm",
					      "--emit-output",
					      "output/stand_alone.out",
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we run a schedule of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection with set duration and simulation time ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/stand_alone-inject2e-8-0.01-0.03-0.06.txt`),
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "simulation of a single neuron model from the cell builtin schedule, soma Vm output, soma current injection with set duration and simulation time",
				preparation => {
						description => "No preparation necessary",
						preparer =>
						sub
						{
						    1;
						},
					       },
				reparation => {
					       description => "Removing the output from the distribution, needed for distcheck to work properly",
					       reparer =>
					       sub
					       {
						   `rm output/stand_alone.out && rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/stand_alone.ndf',
					      '--debug',
					      '1',
					      '--verbose',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we run a schedule of a single neuron model from the cell builtin schedule, debug option turned on ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/debug_stand_alone.txt`),
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "simulation of a single neuron model from the cell builtin schedule, debug option turned on",
				disabled => 'due to the context dependent name of the ssp executable, this test needs regexes to work properly, but that seems like to much work for the moment',
				preparation => {
						description => "No preparation necessary",
						preparer =>
						sub
						{
						    1;
						},
					       },
				reparation => {
					       description => "Removing the output from the distribution, needed for distcheck to work properly",
					       reparer =>
					       sub
					       {
						   `rm output/stand_alone.out && rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      '--cell',
					      'examples/hh_neuron.ndf',
					      '--time',
					      '0.5',
					      '--inject-magnitude',
					      '2e-8',
					      '--neurospaces-studio',
					      '--emit-schedule',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   description => "Can we invoke the neurospaces studio when using the cell builtin ?",
						   read => [
							    '-re',
							    'apply:
  initializers:
    - ~
  simulation:
    - arguments:
        - (.*?)/bin/ssp
      method: Neurospaces::GUI::gui
models:
  - granular_parameters:
      - component_name: /hh_neuron/segments/soma
        field: INJECT
        value: 2e-8
    modelname: /hh_neuron
    solverclass: heccer
name: \'builtin cell configuration, applied to: hh_neuron\'
outputclasses:
  double_2_ascii:
    module_name: Heccer
    options:
      filename: \./output/hh_neuron\.out
    package: Heccer::Output
outputs:
  - component_name: /hh_neuron/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - (.*?)/bin/ssp
            - -P
            - examples/hh_neuron\.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "invocation of the neurospaces studio when using the cell builtin",
				disabled => ($loaded
					     ? 0
					     : "cannot load the neurospaces studio"),
			       },
			      ],
       description => "cell builtin schedule",
       name => 'builtins/cell.t',
      };


return $test;


