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
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/output1.txt`),
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
						   description => "Can we produce simple output with the steps format?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/output2.txt`),
						  },
						 ],
				description => "simple output with the steps format",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/output3',
				command_tests => [
						  {
						   description => "Can we produce output with the steps format at a coarser resolution?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/output3.txt`),
						  },
						 ],
				description => "output with the steps format at a coarser resolution",
			       },
			      ],
       description => "output functions",
       name => 'integration/output.t',
      };


return $test;


