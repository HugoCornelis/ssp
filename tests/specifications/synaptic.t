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
				command => 'tests/perl/springmass3',
				command_tests => [
						  {
						   description => "Is a synaptic (springmass) channel integrated correctly, endogenous firing (works only for the Linux rng) ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/springmass3.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				disabled => (`cat /usr/local/include/heccer/config.h` =~ m/define RANDOM.*ran1/ ? "ran1 defined as rng in heccer config" : 0),
				description => "synaptic (springmass) channel integration, endogenous firing (works only for the Linux rng)",
			       },
			      ],
       description => "synaptic channels",
       name => 'synaptic.t',
      };


return $test;


