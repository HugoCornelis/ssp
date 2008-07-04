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
				command => 'tests/perl/singlea-naf2-aggregator',
				command_tests => [
						  {
						   description => "Are single channel currents summed correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlea-naf2-aggregator.txt`),
						   timeout => 10,
						   write => undef,
						  },
						 ],
				description => "single channel currents summation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/doublea-aggregator',
				command_tests => [
						  {
						   description => "Are single channel currents summed correctly, double compartment case ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/doublea-aggregator.txt`),
						   timeout => 10,
						   write => undef,
						  },
						 ],
				description => "single channel currents summation, double compartment case",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/addressing-aggregator1',
				command_tests => [
						  {
						   description => "Are single channel currents summed correctly, single compartment, three aggregators ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/addressing-aggregator1.txt`),
						   timeout => 10,
						   write => undef,
						  },
						 ],
				description => "single channel currents summation, single compartment, three aggregators",
			       },
			      ],
       description => "heccer aggregator options",
       name => 'aggregators.t',
      };


return $test;


