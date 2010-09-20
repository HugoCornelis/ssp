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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cap.txt | perl -pe 's(unnamed test)(/table_cap)g'`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cat.txt | perl -pe 's(unnamed test)(/table_cat)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-k2.txt | perl -pe 's(unnamed test)(/table_k2)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-ka.txt | perl -pe 's(unnamed test)(/table_ka)g`),
						   timeout => 9,
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
						   description => "Are gates tabulated correctly, calcium dependent potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kc.txt | perl -pe 's(unnamed test)(/table_kc)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kdr.txt | perl -pe 's(unnamed test)(/table_kdr)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kh.txt | perl -pe 's(unnamed test)(/table_kh)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-km.txt | perl -pe 's(unnamed test)(/table_km)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-naf.txt | perl -pe 's(unnamed test)(/table_naf)g`),
						   timeout => 9,
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
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-nap.txt | perl -pe 's(unnamed test)(/table_nap)g`),
						   timeout => 9,
						  },
						 ],
				description => "Persistent sodium gate tabulation",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/hardcoded-tables1',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, hardcoded tables (1) ?",
						   disabled => "This test has been replaced with tests/perl/hardcoded-tables2",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/hardcoded-tables1.txt | perl -pe 's(unnamed test)(/hardcoded_tables1)g`),
						   timeout => 9,
						  },
						 ],
				description => "tables hardcoded in the model container",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/hardcoded-tables2',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, hardcoded tables (2) ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/hardcoded-tables2.txt | perl -pe 's(unnamed test)(/hardcoded_tables2)g`),
						   timeout => 9,
						  },
						 ],
				description => "tables hardcoded in the model container",
			       },
			      ],
       description => "Raw gate tabulation calculations",
       name => 'integration/tables.t',
      };


return $test;


