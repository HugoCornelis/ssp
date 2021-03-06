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
					      "$::global_config->{core_directory}/yaml/purkinje/edsjb1994-perfectclamp.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we do a perfect clamp on the full purkinje cell model using a constant command voltage ?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "perfect clamp on the full purkinje model, constant command voltage",
			       },
			       {
				arguments => [
					      "$::global_config->{core_directory}/yaml/purkinje/edsjb1994-perfectclamp-filename.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we do a perfect clamp on the full purkinje cell model using a file with command voltages ?",
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp-filename.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "perfect clamp on the full purkinje model using a file with command voltages",
			       },
			      ],
       description => "perfect clamp testing",
       name => 'integration/perfectclamp.t',
      };


return $test;


