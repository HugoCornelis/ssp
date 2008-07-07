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
			       {
				arguments => [
					      "$::config->{core_directory}/yaml/purk_test_soma.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the purkinje cell soma solved correctly, no aggregators ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purk_test_soma.txt`),
						   timeout => 100,
						   write => undef,
						  },
						 ],
				description => "purkinje cell soma, no aggregators",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/yaml/purk_test_soma_aggregators.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the purkinje cell soma solved correctly, with aggregators ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purk_test_soma_aggregators.txt`),
						   timeout => 100,
						   write => undef,
						  },
						 ],
				description => "purkinje cell soma, with aggregators",
			       },
			      ],
       description => "heccer aggregator options",
       name => 'aggregators.t',
      };


return $test;


