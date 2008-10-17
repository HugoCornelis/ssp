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
				command => 'tests/perl/springmass3',
				command_tests => [
						  {
						   description => "Is a synaptic (springmass) channel integrated correctly, endogenous firing (works only for the Linux rng) ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/springmass3-2.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				disabled => (`cat /usr/local/include/heccer/config.h` =~ m/define RANDOM.*ran1/ ? "ran1 defined as rng in heccer config" : 0),
				description => "synaptic (springmass) channel integration, endogenous firing (works only for the Linux rng)",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/springmass4',
				command_tests => [
						  {
						   description => "Is a synaptic (springmass) channel with an event table integrated correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/springmass4.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "synaptic (springmass) channel integration, with an event table",
			       },
			       {
				arguments => [
					      '--passive-only',
					     ],
				command => 'tests/perl/springmass3',
				command_tests => [
						  {
						   description => "Is a synaptic (springmass) channel integrated correctly, endogenous firing, passive-only mode (works only for the Linux rng) ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/springmass3-2p.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				disabled => (`cat /usr/local/include/heccer/config.h` =~ m/define RANDOM.*ran1/ ? "ran1 defined as rng in heccer config" : 0),
				description => "synaptic (springmass) channel integration, endogenous firing, passive-only mode (works only for the Linux rng)",
			       },
			       {
				arguments => [
					      '--passive-only',
					     ],
				command => 'tests/perl/springmass4',
				command_tests => [
						  {
						   description => "Is a synaptic (springmass) channel with an event table integrated correctly, passive-only mode ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/springmass4p.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "synaptic (springmass) channel integration, with an event table, passive-only mode",
			       },
			      ],
       description => "synaptic channels",
       name => 'integration/synaptic.t',
      };


return $test;


