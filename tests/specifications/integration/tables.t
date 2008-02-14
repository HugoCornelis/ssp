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
				command => 'tests/perl/table-cap',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, p type calcium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cap.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "p type calcium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-cat',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, calcium t-type gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cat.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Calcium t-type gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-k2',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, K2 potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-k2.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "K2 potassium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-ka',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-ka.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Simple potassium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-kc',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kc.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Calcium dependent potassium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-kdr',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, delayed rectifier potassium gates ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kdr.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Delayed rectifier potassium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-kh',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, anomalous rectifier potassium gates ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kh.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Anomalous rectifier potassium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-km',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, muscarinic potassium gates ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-km.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Muscarinic potassium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-naf',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple sodium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-naf.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Simple sodium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/table-nap',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, persistent sodium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-nap.txt`),
						   timeout => 9,
						   write => undef,
						  },
						 ],
				description => "Persistent sodium gate tabulation",
			       },
			      ],
       description => "Raw gate tabulation calculations",
       name => 'tables.t',
      };


return $test;


