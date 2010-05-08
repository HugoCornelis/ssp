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
description => "Does the version information match with ssp-6b4eb26b633a00d90247d65b13d984cb8232f51f.0 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ssp-6b4eb26b633a00d90247d65b13d984cb8232f51f.0",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'ssp/version.t',
      };


return $test;


