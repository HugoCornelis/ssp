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
				command => 'tests/perl/purk_test_segment',
				command_tests => [
						  {
						   description => "Is the simplified purkinje segment solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/segments/purk_test_segment.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "purkinje simplified segment",
			       },
			      ],
       description => "purkinje segments",
       name => 'integration/segments/purkinje.t',
      };


return $test;


