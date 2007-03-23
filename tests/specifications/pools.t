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
				command => 'tests/perl/pool1',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, single pool case ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/pool1.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, single pool",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool2',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, two compartments, two pools case ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/pool2.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "pool integration, two compartments, two pools",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool1-feedback1',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, one pool with a feedback loop ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/pool1-feedback1.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool1-feedback2',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, one pool with a feedback loop, reversed order ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/pool1-feedback2.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop, reversed order",
			       },
			      ],
       description => "pool integration & related",
       name => 'pools.t',
      };


return $test;


