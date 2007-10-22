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
					      "$::config->{core_directory}/yaml/purkinje/edsjb1994-perfectclamp.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we do a perfect clamp on the full purkinje cell model ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf"
								? "purkinje cell potassium channels not found"
								: ""),
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "perfect clamp on the full purkinje model",
			       },
			      ],
       description => "perfect clamp testing",
       name => 'perfectclamp.t',
      };


return $test;


