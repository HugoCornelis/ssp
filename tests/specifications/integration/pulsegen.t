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
					      "$::config->{core_directory}/heccer/pulsegen_freerun.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   disabled => "Still working on this",
						   description => "Can we perform a pulsegen on a basic compartment in free run mode ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "pulsegen on a basic compartment, free run mode",
			       },


			       {
				arguments => [
					      "$::config->{core_directory}/heccer/pulsegen_exttrig.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   disabled => "Still working on this",
						   description => "Can we perform a pulsegen on a basic compartment in ext trigger mode ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "pulsegen on a basic compartment, ext trigger mode",
			       },


			       {
				arguments => [
					      "$::config->{core_directory}/heccer/pulsegen_extgate.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   disabled => "Still working on this",
						   description => "Can we perform a pulsegen on a basic compartment in ext gate mode ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "pulsegen on a basic compartment, ext gate mode",
			       },

			      ],
       description => "pulsegen testing",
       name => 'integration/pulsegen.t',
      };





return $test;


