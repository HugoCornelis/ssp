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
					      '--passive-only',
					     ],
				command => 'tests/perl/singlea-naf',
				command_tests => [
						  {
						   description => "Is a single compartment with active channels solved correctly in passive mode ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/passive-only1.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "single active compartment in passive mode",
			       },
			      ],
       description => "active models in passive mode testing",
       name => 'integration/passive-only.t',
      };


return $test;


