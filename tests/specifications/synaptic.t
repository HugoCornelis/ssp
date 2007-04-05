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
						   description => "Is a synaptic (springmass) channel integrated correctly, endogenous firing ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/springmass3.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "synaptic (springmass) channel integration, endogenous firing",
			       },
			      ],
       description => "synaptic channels",
       name => 'synaptic.t',
      };


return $test;


