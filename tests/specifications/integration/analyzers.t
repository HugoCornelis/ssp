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
					      '--cell',
					      'tests/cells/singlep.ndf',
					      '--dump',
					      '--emit-schedules',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "What does a schedule look like when we use the Heccer dumper for an analyzer ?",
						   read => [
							    '-re',
							    '
--- !!perl/hash:SSP
analyzers:
  dumper:
    initializers:
      - arguments:
          - source: model_container::/singlep
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
    modelname: /singlep
    solverclass: heccer
name: \'builtin cell configuration, applied to: singlep\'
outputclasses:
  double_2_ascii:
    module_name: Experiment
    options:
      filename: ./output/singlep.out
    package: Experiment::Output
outputs:
  - component_name: /singlep/segments/soma
    field: Vm
    outputclass: double_2_ascii
services:
  model_container:
    initializers:
      - arguments:
          -
            - .*?/ssp
            - -P
            - tests/cells/singlep.ndf
        method: read
    model_library: /usr/local/neurospaces/models/library
    module_name: Neurospaces
solverclasses:
  heccer:
    module_name: Heccer
    service_name: model_container
usage: |2
  
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
				description => "using the Heccer dumper for an analyzer, schedule output",
			       },
			       {
				arguments => [
					      '--cell',
					      'tests/cells/singlep.ndf',
					      '--dump',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "What does the output look like when we use the Heccer dumper for an analyzer ?",
						   read => 'Heccer (pcName) : (unnamed test)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (2e-05)
Intermediary (iCompartments) : (1)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (4.57537e-11)
Compartment (dEm) : (-0.08)
Compartment (dInitVm) : (-0.068)
Compartment (dInject) : (0)
Compartment (dRa) : (360502)
Compartment (dRm) : (3.58441e+08)
MinimumDegree (iEntries) : (1)
MinimumDegree (piChildren[0]) : (0)
MinimumDegree (piForward[0]) : (0)
MinimumDegree (piBackward[0]) : (0)
Tables (iTabulatedGateCount) : (0)
Compartment operations
-----
00000 :: FINISH
00001 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -2.23189e-10 0 218562 1.00061
00001 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.00061)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.068)
',
						  },
						 ],
				description => "using the Heccer dumper for an analyzer, dumper output",
			       },
			      ],
       description => "Gate tabulation high-level interfacing",
       name => 'integration/analyzers.t',
      };


return $test;


