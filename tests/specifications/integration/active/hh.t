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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/active/hh1.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "single compartment with regular HH channels",
			       },
			      ],
       description => "interaction between regular HH channels testing",
       name => 'hh.t',
      };


return $test;


