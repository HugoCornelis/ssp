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
				command => 'tests/perl/purk_test_axon',
				command_tests => [
						  {
						   description => "Is the undocumented purkinje axon solved correctly ?",
						   read => [ `cat $::config->{core_directory}/tests/specifications/strings/segments/purk_test_axon.txt`, ],
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "purkinje undocumented axon segment",
				disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			      ],
       description => "purkinje segments",
       name => 'purkinje.t',
      };


return $test;


