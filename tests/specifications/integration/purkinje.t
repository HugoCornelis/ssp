#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $figures
    = [
       {
	axes => {
		 x => {
		       label => "Compartmental membrane potential",
		       steps => 40000,
		       step_size => 5e-07,
		      },
		 y => {
		       label => "Time",
		      },
		},
	caption => {
		    full => "The membrane potential of the Purkinje cell.",
		    short => "Compartmental membrane potential",
		   },
	name => "hh",
	title => "Compartmental membrane potential over time",
	variables => [
		      {
		       name => "Soma",
		       regex_parser => '[0-9]+\.[0-9]+ (-?[0-9]+\.[-0-9]+) -?[0-9]+\.[-e0-9]+ -?[0-9]+\.[-0-9]+',
		      },
		      {
		       name => "Main dendrite",
		       regex_parser => '[0-9]+\.[0-9]+ -?[0-9]+\.[-0-9]+ -?[0-9]+\.[-e0-9]+ (-?[0-9]+\.[-0-9]+)',
		      },
		     ],
       },
      ];


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::global_config->{core_directory}/yaml/purkinje/edsjb1994-endogenous.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, synchans endogenous firing (works only with the ran1() rng) ?",
						   disabled => (((join '', `cat /usr/local/include/heccer/config.h`) =~ m/define RANDOM.*ran1/
								 ? (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf"
								    ? "purkinje cell potassium channels not found"
								    : "")
								 : "ran1 not defined as rng in heccer config")),
						   figures => $figures,
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-endogenous.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "full purkinje model, synchans endogenous firing",
			       },
			       {
				arguments => [
					      "$::global_config->{core_directory}/yaml/purkinje/edsjb1994-current.yml",
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma current injection ?",
						   disabled => (!-e "/usr/local/neurospaces/models/library/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
						   figures => $figures,
						   read => (join '', `cat $::global_config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-current-2.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "full purkinje model, soma current injection",
			       },
			      ],
       comment => "The output time step is too coarse for visualization of spikes.",
       description => "purkinje model testing",
       documentation => {
			 explanation => "

These tests load the Purkinje cell model.  They then either activate
randomly chosen synaptic channels or apply current injection into the
soma.

Models are instantiated with the Neurospaces model container and they
are simulated with the Heccer compartmental solver.  SSP uses the APIs
of these software components to give the user a fluent experience.

",
			 purpose => "
These tests integrate SSP, the Neurospaces model container and Heccer.

",
			},
       name => 'integration/purkinje.t',
       tags => [
		'manual',
	       ],
      };


return $test;


