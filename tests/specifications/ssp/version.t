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
description => "Does the version information match with ssp-userdocs-3 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ssp-userdocs-3",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'ssp/version.t',
      };


return $test;


