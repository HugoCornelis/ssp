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
						   description => "Is a chemesis3 model solved correctly, cal1, three pools one reaction ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/chemesis3/cal1.txt`),
# 						   read => (join '', `cat /usr/local/chemesis3/tests/specifications/strings/cal1.txt`),
# 						   timeout => 18,
						  },
						 ],
				description => "chemesis3, cal1, three pools one reaction",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/cal2',
				command_tests => [
						  {
						   description => "Is a chemesis3 model solved correctly, cal2, three pools one reaction ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/chemesis3/cal2.txt`),
# 						   read => (join '', `cat /usr/local/chemesis3/tests/specifications/strings/cal2.txt`),
# 						   timeout => 18,
						  },
						 ],
				description => "chemesis3, cal2, twice three pools one reaction, with diffusion between them",
			       },
			      ],
       description => "chemesis3",
       name => 'integration/chemesis3.t',
      };


return $test;


