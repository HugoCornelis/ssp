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
				command => 'tests/perl/output1',
				command_tests => [
						  {
						   description => "Can we produce simple output with simulation time?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/output1.txt`),
						  },
						 ],
				description => "simple output with simulation time",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/output2',
				command_tests => [
						  {
						   description => "Can we produce simple output with the steps mode?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/output2.txt`),
						  },
						 ],
				description => "simple output with the steps mode",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/output3',
				command_tests => [
						  {
						   description => "Can we produce output with the steps mode at a coarser resolution?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/output3.txt`),
						  },
						 ],
				description => "output with the steps mode at a coarser resolution",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/output4',
				command_tests => [
						  {
						   description => "Can we produce simple output with the steps mode and a format field?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/output4.txt`),
						  },
						 ],
				description => "simple output with the steps mode and a format field",
			       },
			      ],
       description => "output functions",
       name => 'integration/output.t',
      };


return $test;


