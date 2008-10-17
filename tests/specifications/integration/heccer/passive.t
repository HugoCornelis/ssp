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
				command => 'tests/perl/heccer/singlep',
				command_tests => [
						  {
						   description => "Is a single passive compartment solved correctly, heccer stand alone driven from ssp ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlep.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "single passive compartment, heccer stand alone.",
				disabled => 0, # 'the heccer model container for simple models is not glued to SSP yet',
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/doublep',
				command_tests => [
						  {
						   description => "Are two passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/doublep.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "doublet passive compartment.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/triplep',
				command_tests => [
						  {
						   description => "Are three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/triplep.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "triplet passive compartment.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/fork3p',
				command_tests => [
						  {
						   description => "Is a fork of three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork3p.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "fork of three passive compartments.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/fork4p1',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, first alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p1.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, first alternative.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/fork4p2',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, second alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p2.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, second alternative.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/fork4p3',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, third alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p3.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, third alternative.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/c1c2p1',
				command_tests => [
						  {
						   description => "Are two passive compartments with injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p1.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with injected current",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/c1c2p2',
				command_tests => [
						  {
						   description => "Are two passive compartments with asymetric properties and injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p2.txt`),
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with asymetric properties and injected current",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/heccer/tensizesp',
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
       name => 'integration/heccer/passive.t',
      };


return $test;


