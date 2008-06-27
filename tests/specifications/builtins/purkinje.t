#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma Vm going to resting state ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-rest.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, soma Vm going to resting state",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--inject-magnitude',
					      '1e-9',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma current injection ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-current.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, soma current injection",
			       },
			      ],
       description => "cell builtin schedule applied to the Purkinje cell model",
       name => 'purkinje.t',
      };


return $test;


