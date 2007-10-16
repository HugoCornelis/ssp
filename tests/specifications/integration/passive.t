#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


#t
#t Need a test with one passive compartment that has self as parent.
#t This is supposed to fail, but it just gives wrong results instead
#t of failing.
#t
#t This came out as an annoyance during implementation of the swig perl glue.
#t

my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/perl/singlep',
				command_tests => [
						  {
						   description => "Is a single passive compartment solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlep.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "single passive compartment.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/doublep',
				command_tests => [
						  {
						   description => "Are two passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/doublep.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "doublet passive compartment.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/triplep',
				command_tests => [
						  {
						   description => "Are three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/triplep.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "triplet passive compartment.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/fork3p',
				command_tests => [
						  {
						   description => "Is a fork of three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork3p.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of three passive compartments.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/fork4p1',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, first alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p1.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, first alternative.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/fork4p2',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, second alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p2.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, second alternative.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/fork4p3',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, third alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p3.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, third alternative.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/c1c2p1',
				command_tests => [
						  {
						   description => "Are two passive compartments with injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p1.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with injected current",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/c1c2p2',
				command_tests => [
						  {
						   description => "Are two passive compartments with asymetric properties and injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p2.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with asymetric properties and injected current",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/tensizesp',
				command_tests => [
						  {
						   description => "Are ten passive compartments with different properties and injected current solved correctly ?",
						   read => (join '', `cat $::config->{tests_directory}/strings/tensizesp.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "ten passive compartments with different properties and injected current",
			       },
			      ],
       description => "simple passive model testing",
       name => 'passive.t',
      };


return $test;


