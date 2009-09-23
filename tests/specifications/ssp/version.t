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
description => "Does the version information match with ssp-b4cee614d722fb2369e1d0c760f72621ca294804-0 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ssp-b4cee614d722fb2369e1d0c760f72621ca294804-0",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'ssp/version.t',
      };


return $test;


