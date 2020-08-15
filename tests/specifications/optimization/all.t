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
					      '--optimize',
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
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/stand_alone-inject2e-8-0.01-0.03-0.06.txt`),
						   timeout => 10,
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
					      '--optimize',
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
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/debug_stand_alone.txt`),
						   timeout => 10,
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
					      '--optimize',
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--emit-output',
					      'output/Purkinje.out',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma Vm going to resting state ?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-rest.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, soma Vm going to resting state",
			       },
			       {
				arguments => [
					      '--optimize',
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--inject-magnitude',
					      '1e-9',
					      '--emit-output',
					      'output/Purkinje.out',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma current injection ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-current.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, soma current injection",
			       },
			      ],
       description => "various duplicate tests repeated with --optimize",
       name => 'optimization/all.t',
      };


return $test;


