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
				command => 'tests/perl/spiker1',
				command_tests => [
						  {
						   description => "Is a single spike reported properly, single spike ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/spiker1.txt | perl -pe 's/spiker1/unnamed test/g'`),
						   timeout => 18,
						  },
						 ],
				comment => 'See also in heccer: tests/code/spiker1',
				description => "sodium and potassium channel, single spike",
				disabled => 'working on it',
				numerical_compare => 'arithmetic rounding differences due to the model container arithmetic',
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/spiker2',
				command_tests => [
						  {
						   description => "Is a single spike reported properly, single source, single spike, multiple targets, hardcoded connection matrix ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/spiker2.txt`),
						   timeout => 18,
						  },
						 ],
				comment => 'See also in heccer: tests/code/spiker2 and the next test',
				description => "single source, single spike, multiple targets, hardcoded connection matrix",
				disabled => 'not possible to do this one with ssp, this test is only available for heccer/des',
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/spiker3',
				command_tests => [
						  {
						   description => "Is a single spike reported properly, single source, single spike, multiple targets ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/spiker2.txt | perl -pe 's(source)(/spiker3/source)g' | perl -pe 's(target1)(/spiker3/target1)g' | perl -pe 's(target2)(/spiker3/target2)g'`),
						   timeout => 18,
						  },
						 ],
				comment => 'See also in heccer: tests/code/spiker2 and the previous test',
				description => "single source, single spike, multiple targets",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/spiker4',
				command_tests => [
						  {
						   description => "Is a single spike reported properly, single source, single spike, multiple targets ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/spiker2.txt | perl -pe 's(source)(/spiker4/source1)g' | perl -pe 's(target1)(/spiker4/target1)g' | perl -pe 's(target2)(/spiker4/target2)g'`),
						   timeout => 18,
						  },
						 ],
				comment => 'See also in heccer: tests/code/spiker2 and the previous test',
				description => "double source of which one activated, single spike, multiple targets",
			       },
			      ],
       description => "spiking behaviour",
       disabled => 'the tests have been replaced with equivalent tests in the gshell',
       name => 'integration/spikes.t',
      };


return $test;


