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
					      "$::config->{core_directory}/yaml/purkinje/edsjb1994-endogenous.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, synchans endogenous firing (works only with the ran1() rng) ?",
						   disabled => (`cat $::config->{core_directory}/heccer/config.h` =~ m/define RANDOM.*ran1/ ? 1 : 0),
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt`, ],
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "full purkinje model, synchans endogenous firing",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/yaml/purkinje/edsjb1994-current.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma current injection (works only with the ran1() rng) ?",
						   disabled => (`cat $::config->{core_directory}/heccer/config.h` =~ m/define RANDOM.*ran1/ ? 1 : 0),
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-current.txt`, ],
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "full purkinje model, soma current injection",
			       },
			      ],
       description => "purkinje model testing",
       name => 'purkinje.t',
      };


return $test;


