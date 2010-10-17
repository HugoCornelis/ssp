#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $test
    = {
       command_definitions => [
			       (
				# basic tests

				{
				 arguments => [
					      ],
				 command => 'tests/perl/singlea-naf2-aggregator',
				 command_tests => [
						   {
						    description => "Are single channel currents summed correctly ?",
						    read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlea-naf2-aggregator.txt | perl -pe 's(unnamed test)(/singlea_naf2_aggregator)g'`),
						    timeout => 10,
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
						    read => (join '', `cat /usr/local/heccer/tests/specifications/strings/doublea-aggregator.txt | perl -pe 's(unnamed test)(/doublea_aggregator)g'`),
						    timeout => 10,
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
						    read => (join '', `cat /usr/local/heccer/tests/specifications/strings/addressing-aggregator1.txt | perl -pe 's(unnamed test)(/addressing_aggregator1)g'`),
						    timeout => 10,
						   },
						  ],
				 description => "single channel currents summation, single compartment, three aggregators",
				},
			       ),
			       (
				# tests comparing parts of the purkinje cell without and with aggregators enabled

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
						   },
						  ],
				 description => "purkinje cell soma, with aggregators",
				},
				{
				 arguments => [
					       "$::config->{core_directory}/yaml/purkinje/edsjb1994-endogenous.yml",
					      ],
				 command => 'bin/ssp',
				 command_tests => [
						   {
						    description => "Is the purkinje cell solved correctly, without aggregators ?",
						    disabled => (((join '', `cat /usr/local/include/heccer/config.h`) =~ m/define RANDOM.*ran1/
								  ? (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf"
								     ? "purkinje cell potassium channels not found"
								     : "")
								  : "ran1 not defined as rng in heccer config")),
						    read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt`),
						    timeout => 500,
						   },
						  ],
				 description => "purkinje cell, without aggregators",
				},
				{
				 arguments => [
					       "$::config->{core_directory}/yaml/purkinje/edsjb1994-endogenous-aggregators.yml",
					      ],
				 command => 'bin/ssp',
				 command_tests => [
						   {
						    description => "Is the purkinje cell solved correctly, with aggregators ?",
						    disabled => (((join '', `cat /usr/local/include/heccer/config.h`) =~ m/define RANDOM.*ran1/
								  ? (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf"
								     ? "purkinje cell potassium channels not found"
								     : "")
								  : "ran1 not defined as rng in heccer config")),
						    read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt`),
						    timeout => 500,
						   },
						  ],
				 description => "purkinje cell, with aggregators",
				},
			       ),
			      ],
       description => "heccer aggregator options",
       name => 'integration/aggregators.t',
      };


return $test;


