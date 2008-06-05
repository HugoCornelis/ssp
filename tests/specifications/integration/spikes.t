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
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "sodium and potassium channel, single spike",
				numerical_compare => 'small arithmetic rounding differences',
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/spiker2',
				command_tests => [
						  {
						   description => "Is a single spike reported properly, single source, single spike, multiple targets, hardcoded connection matrix ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/spiker2.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "single source, single spike, multiple targets, hardcoded connection matrix",
				disabled => 'working on it',
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/spiker3',
				command_tests => [
						  {
						   description => "Is a single spike reported properly, single source, single spike, multiple targets ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/spiker2.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "single source, single spike, multiple targets",
				disabled => 'working on it',
			       },
			      ],
       description => "spiking behaviour",
       name => 'spikes.t',
      };


return $test;


