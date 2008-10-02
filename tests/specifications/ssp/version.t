#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--version',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   # $Format: "description => \"Does the version information match with ${package}-${label} ?\","$
description => "Does the version information match with ssp-python-2 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ssp-python-2",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


