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
				command => 'tests/perl/singlea-naf',
				command_tests => [
						  {
						   description => "Is a single compartment with a naf conductance solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/active/singlea-naf.txt | perl -pe 's(unnamed test)(/singlea_naf)g'`),
						   timeout => 10,
						  },
						 ],
				description => "single compartment with a naf conductance.",
			       },
			      ],
       description => "active single compartment testing",
       name => 'integration/active/singles.t',
      };


return $test;


