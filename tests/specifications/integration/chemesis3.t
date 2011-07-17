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
				command => 'tests/perl/cal1',
				command_tests => [
						  {
						   description => "Is a chemesis3 model solved correctly, cal1 ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/chemesis3/cal1.txt`),
# 						   read => (join '', `cat /usr/local/chemesis3/tests/specifications/strings/cal1.txt`),
# 						   timeout => 18,
						  },
						 ],
				description => "pool integration, one compartment, single pool",
			       },
			      ],
       description => "pool integration & related",
       name => 'integration/pools.t',
      };


return $test;


