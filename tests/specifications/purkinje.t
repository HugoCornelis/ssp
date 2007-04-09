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
					      'yaml/purkinje/edsjb1994.yml',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, endogenous firing ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/purkinje-endogenous.txt`, ],
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "full purkinje model",
			       },
			      ],
       description => "purkinje model testing",
       name => 'purkinje.t',
      };


return $test;


