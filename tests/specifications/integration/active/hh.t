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
				command => 'tests/perl/hh1',
				command_tests => [
						  {
						   description => "Is a single compartment with regular HH channels solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/active/hh1.txt | perl -pe 's(unnamed test)(/hh1)g'`),
						   timeout => 15,
						  },
						 ],
				description => "single compartment with regular HH channels",
			       },
			      ],
       description => "interaction between regular HH channels testing",
       name => 'integration/active/hh.t',
      };


return $test;


