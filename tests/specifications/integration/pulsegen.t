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
			      ],
       description => "pulsegen testing",
       name => 'integration/pulsegen.t',
      };


return $test;


