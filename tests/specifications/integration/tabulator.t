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
				command => 'tests/perl/hh_tabulator',
				command_tests => [
						  {
						   description => "Are HH gates tabulated correctly, can we access the tables ?",
						   read => 'tgt is SwiggableHeccer::TabulatedGateTable=HASH',
						   write => undef,
						  },
						 ],
				description => "high level querying of gate tables",
			       },
			      ],
       description => "Gate tabulation high-level interfacing",
       name => 'tabulator.t',
      };


return $test;


