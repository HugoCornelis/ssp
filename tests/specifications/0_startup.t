#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--help',
					     ],
				command => './bin/ssp',
				command_tests => [
						  {
						   comment => "This is supposed to be the first test, and is supposed to compile the inline module of the optimized scheduler.  This can take a couple of seconds.",
						   description => "Can we start the ssp Unix shell command ?",
						   read => "options:",
						   timeout => 20,
						  },
						 ],
				description => "simple startup",
			       },
			      ],
       description => "starting ssp from a unix command shell",
       name => '0_startup.t',
      };


return $test;


