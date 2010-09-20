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
				command => 'tests/perl/pool1',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, single pool case ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/pool1.txt | perl -pe 's(unnamed test)(/pool1)g'`),
						   timeout => 18,
						  },
						 ],
				description => "pool integration, one compartment, single pool",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool2',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, two compartments, two pools case ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/pool2.txt | perl -pe 's(unnamed test)(/pool2)g'`),
						   timeout => 18,
						  },
						 ],
				description => "pool integration, two compartments, two pools",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool1-feedback1',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, one pool with a feedback loop ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/pool1-feedback1.txt | perl -pe 's(unnamed test)(/pool1_feedback1)g'`),
						   timeout => 18,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool1-feedback2',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, one pool with a feedback loop, reversed order ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/pool1-feedback2.txt | perl -pe 's(unnamed test)(/pool1_feedback2)g'`),
						   timeout => 18,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop, reversed order",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/pool1-contributors2',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one pool, two feeding channels ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/pool1-contributors2.txt | perl -pe 's(unnamed test)(/pool1_contributors2)g'`),
						   timeout => 18,
						  },
						 ],
				description => "pool integration, one pool, two feeding channels",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/channel1-nernst1',
				command_tests => [
						  {
						   description => "Is the solved nernst potential applied for channel reversal potentials ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/channel1-nernst1.txt | perl -pe 's(unnamed test)(/channel1_nernst1)g'`),
						   timeout => 160,
						  },
						 ],
				description => "solved nernst potential application for channel reversal potentials",
			       },
			      ],
       description => "pool integration & related",
       name => 'integration/pools.t',
      };


return $test;


