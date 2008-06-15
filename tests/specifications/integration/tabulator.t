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
						   read => [ '-re', 'table index is 0(.|
)*?--- !!perl/hash:Heccer::Tabulator::Result
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
(.|
)*table index is 1(.|
)*?--- !!perl/hash:Heccer::Tabulator::Result
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
', ],
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


