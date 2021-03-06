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
				command => 'tests/perl/hh_tabulator_internal',
				command_tests => [
						  {
						   description => "Are HH gates tabulated correctly, can we access the tables ?",
						   figures => [
							       {
								axes => {
									 x => {
									       label => "Gate activation between 0 and 1",
									      },
									 Ay => {
										label => "A value (arbitrary units)",
									       },
									 By => {
										label => "B value (arbitrary units)",
									       },
									},
								caption => {
									    full => "Gate Activation Table Values.  Left: A-table, Right: B-table",
									    short => "Gate Activation Table Values",
									   },
								# caption_A => {
								# 	      full => "Table A of the activation of Hodgkin-Huxley gates (Heccer's internal format).",
								# 	      short => "Gate activation table A",
								# 	     },
								# caption_B => {
								# 	      full => "Table B of the activation of Hodgkin-Huxley gates (Heccer's internal format).",
								# 	      short => "Gate activation table B",
								# 	     },
								class => "hh_gates_internal",
								name => "hh-vm",
								title => "Hodgkin-Huxley gate activation (internal format)",
							       },
							      ],
						   read => '!!perl/hash:Heccer::Tabulator::Result
A:
  - 22.5694792145875
  - 74.6294414550961
  - 223.56372458463
  - 581.976706869326
  - 1270.7470412684
  - 2313.03528549933
  - 3608.9818074023
  - 5033.91827453152
  - 6509.7870690175
  - 8002.68460160673
B:
  - 21200.5296810947
  - 9278.5330050264
  - 4223.56372458463
  - 2320.36954089764
  - 2026.24945261865
  - 2641.37527999493
  - 3751.67778079131
  - 5095.93368892756
  - 6536.73885701384
  - 8014.397800386
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
--- !!perl/hash:Heccer::Tabulator::Result
A:
  - 313.718234923665
  - 148.190001162887
  - 70
  - 33.065658691871
  - 15.6191112103901
  - 7.3779457193305
  - 3.48509478575048
  - 1.64624220992064
  - 0.777629757676962
  - 0.367326287942697
B:
  - 316.190858080299
  - 159.17694379348
  - 117.425873177567
  - 215.491182498227
  - 515.61911121039
  - 824.952421912974
  - 956.059221608184
  - 990.659299579327
  - 998.305006601042
  - 999.814547651019
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
',
						  },
						 ],
				description => "high level querying of gate tables, heccer internal format",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/hh_tabulator_A_B',
				command_tests => [
						  {
						   description => "Are HH gates tabulated correctly, can we access the tables ?",
						   figures1 => [
							       {
								axes => {
									 x => {
									       label => "Compartmental membrane potential",
									      },
									 y => {
									       label => "Activation",
									      },
									},
								caption => {
									    full => "The activation of Hodgkin-Huxley gates.",
									    short => "Gate activation",
									   },
								class => "hh_gates",
								name => "hh-vm",
								title => "Hodgkin-Huxley gate activation against compartmental membrane potential (A-B format)",
							       },
							      ],
						   read => '!!perl/hash:Heccer::Tabulator::Result
A:
  - 22.5694792145875
  - 74.6294414550961
  - 223.56372458463
  - 581.976706869326
  - 1270.7470412684
  - 2313.03528549933
  - 3608.9818074023
  - 5033.91827453152
  - 6509.7870690175
  - 8002.68460160673
B:
  - 21200.5296810947
  - 9278.5330050264
  - 4223.56372458463
  - 2320.36954089764
  - 2026.24945261865
  - 2641.37527999493
  - 3751.67778079131
  - 5095.93368892756
  - 6536.73885701384
  - 8014.397800386
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
--- !!perl/hash:Heccer::Tabulator::Result
A:
  - 313.718234923665
  - 148.190001162887
  - 70
  - 33.065658691871
  - 15.6191112103901
  - 7.3779457193305
  - 3.48509478575048
  - 1.64624220992064
  - 0.777629757676962
  - 0.367326287942697
B:
  - 316.190858080299
  - 159.17694379348
  - 117.425873177567
  - 215.491182498227
  - 515.61911121039
  - 824.952421912974
  - 956.059221608184
  - 990.659299579327
  - 998.305006601042
  - 999.814547651019
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
',
						  },
						 ],
				description => "high level querying of gate tables, A-B format",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/hh_tabulator_steadystate_tau',
				command_tests => [
						  {
						   description => "Are HH gates tabulated correctly, can we access the tables ?",
						   figures1 => [
							       {
								axes => {
									 x => {
									       label => "Compartmental membrane potential",
									      },
									 y => {
									       label => "Activation",
									      },
									},
								caption => {
									    full => "The activation of Hodgkin-Huxley gates.",
									    short => "Gate activation",
									   },
								class => "hh_gates",
								name => "hh-vm",
								title => "Hodgkin-Huxley gate activation against compartmental membrane potential (steady state, time constant format)",
							       },
							      ],
						   read => '!!perl/hash:Heccer::Tabulator::Result
A:
  - 22.5694792145875
  - 74.6294414550961
  - 223.56372458463
  - 581.976706869326
  - 1270.7470412684
  - 2313.03528549933
  - 3608.9818074023
  - 5033.91827453152
  - 6509.7870690175
  - 8002.68460160673
B:
  - 21200.5296810947
  - 9278.5330050264
  - 4223.56372458463
  - 2320.36954089764
  - 2026.24945261865
  - 2641.37527999493
  - 3751.67778079131
  - 5095.93368892756
  - 6536.73885701384
  - 8014.397800386
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
steady:
  - 0.00106457147788687
  - 0.00804323715986866
  - 0.0529324852572495
  - 0.250812078253789
  - 0.62714244765181
  - 0.875693546092312
  - 0.961964757709306
  - 0.987830411818195
  - 0.99587687552067
  - 0.998538480485869
tau:
  - 4.71686328144781e-05
  - 0.0001077756580117
  - 0.000236766878685688
  - 0.000430965836421533
  - 0.000493522650287524
  - 0.000378590656001718
  - 0.000266547411166286
  - 0.000196234892571856
  - 0.000152981482337636
  - 0.000124775438517893
--- !!perl/hash:Heccer::Tabulator::Result
A:
  - 313.718234923665
  - 148.190001162887
  - 70
  - 33.065658691871
  - 15.6191112103901
  - 7.3779457193305
  - 3.48509478575048
  - 1.64624220992064
  - 0.777629757676962
  - 0.367326287942697
B:
  - 316.190858080299
  - 159.17694379348
  - 117.425873177567
  - 215.491182498227
  - 515.61911121039
  - 824.952421912974
  - 956.059221608184
  - 990.659299579327
  - 998.305006601042
  - 999.814547651019
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
steady:
  - 0.992179966329049
  - 0.930976544914395
  - 0.59612075350846
  - 0.15344320964104
  - 0.0302919555749689
  - 0.00894348028244084
  - 0.00364527082316952
  - 0.00166176425196805
  - 0.000778950072908659
  - 0.000367394422101278
tau:
  - 0.00316264678261521
  - 0.00628231687434219
  - 0.00851601076440658
  - 0.00464056110513119
  - 0.00193941608885006
  - 0.00121219111967828
  - 0.001045960310197
  - 0.00100942877175295
  - 0.00100169787127957
  - 0.00100018548674793
',
						  },
						 ],
				description => "high level querying of gate tables, steadystate-tau format",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/perl/hh_tabulator_alpha_beta',
				command_tests => [
						  {
						   description => "Are HH gates tabulated correctly, can we access the tables ?",
						   figures => [
							       {
								axes => {
									 x => {
									       label => "Gate rate of change",
									      },
									 y => {
									       label => "Activation",
									      },
									},
								caption => {
									    full => "The rate of activation change of the Hodgkin-Huxley gates (alpha / beta format).",
									    short => "Gate rate of change",
									   },
								class => "hh_gates_alpha_beta",
								name => "hh-vm",
								title => "Hodgkin-Huxley gate activation against compartmental membrane potential (alpha / beta format)",
							       },
							      ],
						   read => '!!perl/hash:Heccer::Tabulator::Result
A:
  - 22.5694792145875
  - 74.6294414550961
  - 223.56372458463
  - 581.976706869326
  - 1270.7470412684
  - 2313.03528549933
  - 3608.9818074023
  - 5033.91827453152
  - 6509.7870690175
  - 8002.68460160673
B:
  - 21200.5296810947
  - 9278.5330050264
  - 4223.56372458463
  - 2320.36954089764
  - 2026.24945261865
  - 2641.37527999493
  - 3751.67778079131
  - 5095.93368892756
  - 6536.73885701384
  - 8014.397800386
alpha:
  - 22.5694792145875
  - 74.6294414550961
  - 223.56372458463
  - 581.976706869326
  - 1270.7470412684
  - 2313.03528549933
  - 3608.9818074023
  - 5033.91827453152
  - 6509.7870690175
  - 8002.68460160673
beta:
  - 21177.9602018801
  - 9203.9035635713
  - 4000
  - 1738.39283402831
  - 755.502411350247
  - 328.339994495595
  - 142.695973389009
  - 62.0154143960372
  - 26.9517879963414
  - 11.7131987792727
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
--- !!perl/hash:Heccer::Tabulator::Result
A:
  - 313.718234923665
  - 148.190001162887
  - 70
  - 33.065658691871
  - 15.6191112103901
  - 7.3779457193305
  - 3.48509478575048
  - 1.64624220992064
  - 0.777629757676962
  - 0.367326287942697
B:
  - 316.190858080299
  - 159.17694379348
  - 117.425873177567
  - 215.491182498227
  - 515.61911121039
  - 824.952421912974
  - 956.059221608184
  - 990.659299579327
  - 998.305006601042
  - 999.814547651019
alpha:
  - 313.718234923665
  - 148.190001162887
  - 70
  - 33.065658691871
  - 15.6191112103901
  - 7.3779457193305
  - 3.48509478575048
  - 1.64624220992064
  - 0.777629757676962
  - 0.367326287942697
beta:
  - 2.47262315663477
  - 10.9869426305932
  - 47.4258731775668
  - 182.425523806356
  - 500
  - 817.574476193644
  - 952.574126822433
  - 989.013057369407
  - 997.527376843365
  - 999.447221363076
entries: 10
hi:
  end: 0.05
  start: -0.1
  step: 0.015
',
						  },
						 ],
				description => "high level querying of gate tables, alpha-beta format",
			       },
			      ],
       description => "Gate tabulation high-level interfacing",
       name => 'integration/tabulator.t',
       tags => [
		'manual',
	       ],
      };


return $test;


