#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $test
    = {
       command_definitions => [
			       {
				disabled => "fixing numerical error",
				arguments => [
					      "$::config->{core_directory}/yaml/heccer/pulsegen_freerun.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we perform a pulsegen on a basic compartment in free run mode ?",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/pulse0.txt",
							   },
						   timeout => 300,
						  },
						 ],
				description => "pulsegen on a basic compartment, free run mode",
				preparation => {
						description => "Delete the output file",
						preparer =>
						sub
						{
						    `rm -f /tmp/output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the results directory",
					       reparer =>
					       sub
					       {
 						   `rm -f /tmp/out`;
					       },
					      },
			       },


			       {

				disabled => "fixing numerical error",
				arguments => [
					      "$::config->{core_directory}/yaml/heccer/pulsegen_exttrig.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we perform a pulsegen on a basic compartment in ext trigger mode ?",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/pulse1.txt",
							   },
						   timeout => 300,
						  },
						 ],
				description => "pulsegen on a basic compartment, ext trigger mode",
				preparation => {
						description => "Delete the output file",
						preparer =>
						sub
						{
						    `rm -f /tmp/output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the results directory",
					       reparer =>
					       sub
					       {
 						   `rm -f /tmp/out`;
					       },
					      },
			       },


			       {

				disabled => "fixing numerical error",
				arguments => [
					      "$::config->{core_directory}/yaml/heccer/pulsegen_extgate.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we perform a pulsegen on a basic compartment in ext gate mode ?",
						   read => {
							    application_output_file => '/tmp/output',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/pulse2.txt",
							   },
						   timeout => 300,
						  },
						 ],
				description => "pulsegen on a basic compartment, ext gate mode",
				preparation => {
						description => "Delete the output file",
						preparer =>
						sub
						{
						    `rm -f /tmp/output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the results directory",
					       reparer =>
					       sub
					       {
 						   `rm -f /tmp/out`;
					       },
					      },
			       },

			      ],
       description => "pulsegen testing",
       name => 'integration/pulsegen.t',
      };





return $test;


