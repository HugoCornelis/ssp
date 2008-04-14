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
					     ],
				command => 'tests/perl/purk_test',
				command_tests => [
						  {
						   description => "Is a small subset of the purkinje cell model solved correctly ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat $::config->{tests_directory}/strings/purk_test.txt`),
						   timeout => 50,
						   write => undef,
						  },
						 ],
				description => "small subset of the purkinje cell model",
			       },
			       {
				arguments => [
					      '--passive-only',
					     ],
				command => 'tests/perl/purk_test',
				command_tests => [
						  {
						   description => "Is a small subset of the purkinje cell model solved correctly, passive-only mode ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat $::config->{tests_directory}/strings/purk_test_passive.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "small subset of the purkinje cell model, passive-only mode",
			       },
			      ],
       description => "active compartment testing",
       name => 'active_multiple.t',
      };


return $test;


