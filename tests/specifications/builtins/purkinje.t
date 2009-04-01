#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--emit-output',
					      'output/Purkinje.out',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma Vm going to resting state ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-rest.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, soma Vm going to resting state",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--inject-magnitude',
					      '1e-9',
					      '--emit-output',
					      'output/Purkinje.out',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Is the full purkinje cell model behaviour ok, soma current injection ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/builtin-edsjb1994-soma-current.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, soma current injection",
			       },
			       {
				arguments => [
					      '--cell',
					      'cells/purkinje/edsjb1994.ndf',
					      '--model-name',
					      '/Purkinje',
					      '--perfectclamp',
					      '-0.06',
					      '--emit-output',
					      'output/Purkinje.out',
					     ],
				command => 'bin/ssp',
				command_tests => [
						  {
						   description => "Can we do a perfect clamp on the full purkinje cell model using a constant command voltage ?",
						   read => '2e-05 -0.06
4e-05 -0.06
6e-05 -0.06
8e-05 -0.06
0.0001 -0.06
0.00012 -0.06
0.00014 -0.06
0.00016 -0.06
0.00018 -0.06
0.0002 -0.06
0.00022 -0.06
0.00024 -0.06
0.00026 -0.06
0.00028 -0.06
0.0003 -0.06
0.00032 -0.06
0.00034 -0.06
0.00036 -0.06
0.00038 -0.06
0.0004 -0.06
0.00042 -0.06
0.00044 -0.06
0.00046 -0.06
0.00048 -0.06
0.0005 -0.06
0.00052 -0.06
0.00054 -0.06
0.00056 -0.06
0.00058 -0.06
0.0006 -0.06
0.00062 -0.06
0.00064 -0.06
0.00066 -0.06
0.00068 -0.06
0.0007 -0.06
0.00072 -0.06
0.00074 -0.06
0.00076 -0.06
0.00078 -0.06
0.0008 -0.06
0.00082 -0.06
0.00084 -0.06
0.00086 -0.06
0.00088 -0.06
0.0009 -0.06
0.00092 -0.06
0.00094 -0.06
0.00096 -0.06
0.00098 -0.06
0.001 -0.06
0.00102 -0.06
0.00104 -0.06
0.00106 -0.06
0.00108 -0.06
0.0011 -0.06
0.00112 -0.06
0.00114 -0.06
0.00116 -0.06
0.00118 -0.06
0.0012 -0.06
0.00122 -0.06
0.00124 -0.06
0.00126 -0.06
0.00128 -0.06
0.0013 -0.06
0.00132 -0.06
0.00134 -0.06
0.00136 -0.06
0.00138 -0.06
0.0014 -0.06
0.00142 -0.06
0.00144 -0.06
0.00146 -0.06
0.00148 -0.06
0.0015 -0.06
0.00152 -0.06
0.00154 -0.06
0.00156 -0.06
0.00158 -0.06
0.0016 -0.06
0.00162 -0.06
0.00164 -0.06
0.00166 -0.06
0.00168 -0.06
0.0017 -0.06
0.00172 -0.06
0.00174 -0.06
0.00176 -0.06
0.00178 -0.06
0.0018 -0.06
0.00182 -0.06
0.00184 -0.06
0.00186 -0.06
0.00188 -0.06
0.0019 -0.06
0.00192 -0.06
0.00194 -0.06
0.00196 -0.06
0.00198 -0.06
0.002 -0.06
0.00202 -0.06
0.00204 -0.06
0.00206 -0.06
0.00208 -0.06
0.0021 -0.06
0.00212 -0.06
0.00214 -0.06
0.00216 -0.06
0.00218 -0.06
0.0022 -0.06
0.00222 -0.06
0.00224 -0.06
0.00226 -0.06
0.00228 -0.06
0.0023 -0.06
0.00232 -0.06
0.00234 -0.06
0.00236 -0.06
0.00238 -0.06
0.0024 -0.06
0.00242 -0.06
0.00244 -0.06
0.00246 -0.06
0.00248 -0.06
0.0025 -0.06
0.00252 -0.06
0.00254 -0.06
0.00256 -0.06
0.00258 -0.06
0.0026 -0.06
0.00262 -0.06
0.00264 -0.06
0.00266 -0.06
0.00268 -0.06
0.0027 -0.06
0.00272 -0.06
0.00274 -0.06
0.00276 -0.06
0.00278 -0.06
0.0028 -0.06
0.00282 -0.06
0.00284 -0.06
0.00286 -0.06
0.00288 -0.06
0.0029 -0.06
0.00292 -0.06
0.00294 -0.06
0.00296 -0.06
0.00298 -0.06
0.003 -0.06
0.00302 -0.06
0.00304 -0.06
0.00306 -0.06
0.00308 -0.06
0.0031 -0.06
0.00312 -0.06
0.00314 -0.06
0.00316 -0.06
0.00318 -0.06
0.0032 -0.06
0.00322 -0.06
0.00324 -0.06
0.00326 -0.06
0.00328 -0.06
0.0033 -0.06
0.00332 -0.06
0.00334 -0.06
0.00336 -0.06
0.00338 -0.06
0.0034 -0.06
0.00342 -0.06
0.00344 -0.06
0.00346 -0.06
0.00348 -0.06
0.0035 -0.06
0.00352 -0.06
0.00354 -0.06
0.00356 -0.06
0.00358 -0.06
0.0036 -0.06
0.00362 -0.06
0.00364 -0.06
0.00366 -0.06
0.00368 -0.06
0.0037 -0.06
0.00372 -0.06
0.00374 -0.06
0.00376 -0.06
0.00378 -0.06
0.0038 -0.06
0.00382 -0.06
0.00384 -0.06
0.00386 -0.06
0.00388 -0.06
0.0039 -0.06
0.00392 -0.06
0.00394 -0.06
0.00396 -0.06
0.00398 -0.06
0.004 -0.06
0.00402 -0.06
0.00404 -0.06
0.00406 -0.06
0.00408 -0.06
0.0041 -0.06
0.00412 -0.06
0.00414 -0.06
0.00416 -0.06
0.00418 -0.06
0.0042 -0.06
0.00422 -0.06
0.00424 -0.06
0.00426 -0.06
0.00428 -0.06
0.0043 -0.06
0.00432 -0.06
0.00434 -0.06
0.00436 -0.06
0.00438 -0.06
0.0044 -0.06
0.00442 -0.06
0.00444 -0.06
0.00446 -0.06
0.00448 -0.06
0.0045 -0.06
0.00452 -0.06
0.00454 -0.06
0.00456 -0.06
0.00458 -0.06
0.0046 -0.06
0.00462 -0.06
0.00464 -0.06
0.00466 -0.06
0.00468 -0.06
0.0047 -0.06
0.00472 -0.06
0.00474 -0.06
0.00476 -0.06
0.00478 -0.06
0.0048 -0.06
0.00482 -0.06
0.00484 -0.06
0.00486 -0.06
0.00488 -0.06
0.0049 -0.06
0.00492 -0.06
0.00494 -0.06
0.00496 -0.06
0.00498 -0.06
0.005 -0.06
0.00502 -0.06
0.00504 -0.06
0.00506 -0.06
0.00508 -0.06
0.0051 -0.06
0.00512 -0.06
0.00514 -0.06
0.00516 -0.06
0.00518 -0.06
0.0052 -0.06
0.00522 -0.06
0.00524 -0.06
0.00526 -0.06
0.00528 -0.06
0.0053 -0.06
0.00532 -0.06
0.00534 -0.06
0.00536 -0.06
0.00538 -0.06
0.0054 -0.06
0.00542 -0.06
0.00544 -0.06
0.00546 -0.06
0.00548 -0.06
0.0055 -0.06
0.00552 -0.06
0.00554 -0.06
0.00556 -0.06
0.00558 -0.06
0.0056 -0.06
0.00562 -0.06
0.00564 -0.06
0.00566 -0.06
0.00568 -0.06
0.0057 -0.06
0.00572 -0.06
0.00574 -0.06
0.00576 -0.06
0.00578 -0.06
0.0058 -0.06
0.00582 -0.06
0.00584 -0.06
0.00586 -0.06
0.00588 -0.06
0.0059 -0.06
0.00592 -0.06
0.00594 -0.06
0.00596 -0.06
0.00598 -0.06
0.006 -0.06
0.00602 -0.06
0.00604 -0.06
0.00606 -0.06
0.00608 -0.06
0.0061 -0.06
0.00612 -0.06
0.00614 -0.06
0.00616 -0.06
0.00618 -0.06
0.0062 -0.06
0.00622 -0.06
0.00624 -0.06
0.00626 -0.06
0.00628 -0.06
0.0063 -0.06
0.00632 -0.06
0.00634 -0.06
0.00636 -0.06
0.00638 -0.06
0.0064 -0.06
0.00642 -0.06
0.00644 -0.06
0.00646 -0.06
0.00648 -0.06
0.0065 -0.06
0.00652 -0.06
0.00654 -0.06
0.00656 -0.06
0.00658 -0.06
0.0066 -0.06
0.00662 -0.06
0.00664 -0.06
0.00666 -0.06
0.00668 -0.06
0.0067 -0.06
0.00672 -0.06
0.00674 -0.06
0.00676 -0.06
0.00678 -0.06
0.0068 -0.06
0.00682 -0.06
0.00684 -0.06
0.00686 -0.06
0.00688 -0.06
0.0069 -0.06
0.00692 -0.06
0.00694 -0.06
0.00696 -0.06
0.00698 -0.06
0.007 -0.06
0.00702 -0.06
0.00704 -0.06
0.00706 -0.06
0.00708 -0.06
0.0071 -0.06
0.00712 -0.06
0.00714 -0.06
0.00716 -0.06
0.00718 -0.06
0.0072 -0.06
0.00722 -0.06
0.00724 -0.06
0.00726 -0.06
0.00728 -0.06
0.0073 -0.06
0.00732 -0.06
0.00734 -0.06
0.00736 -0.06
0.00738 -0.06
0.0074 -0.06
0.00742 -0.06
0.00744 -0.06
0.00746 -0.06
0.00748 -0.06
0.0075 -0.06
0.00752 -0.06
0.00754 -0.06
0.00756 -0.06
0.00758 -0.06
0.0076 -0.06
0.00762 -0.06
0.00764 -0.06
0.00766 -0.06
0.00768 -0.06
0.0077 -0.06
0.00772 -0.06
0.00774 -0.06
0.00776 -0.06
0.00778 -0.06
0.0078 -0.06
0.00782 -0.06
0.00784 -0.06
0.00786 -0.06
0.00788 -0.06
0.0079 -0.06
0.00792 -0.06
0.00794 -0.06
0.00796 -0.06
0.00798 -0.06
0.008 -0.06
0.00802 -0.06
0.00804 -0.06
0.00806 -0.06
0.00808 -0.06
0.0081 -0.06
0.00812 -0.06
0.00814 -0.06
0.00816 -0.06
0.00818 -0.06
0.0082 -0.06
0.00822 -0.06
0.00824 -0.06
0.00826 -0.06
0.00828 -0.06
0.0083 -0.06
0.00832 -0.06
0.00834 -0.06
0.00836 -0.06
0.00838 -0.06
0.0084 -0.06
0.00842 -0.06
0.00844 -0.06
0.00846 -0.06
0.00848 -0.06
0.0085 -0.06
0.00852 -0.06
0.00854 -0.06
0.00856 -0.06
0.00858 -0.06
0.0086 -0.06
0.00862 -0.06
0.00864 -0.06
0.00866 -0.06
0.00868 -0.06
0.0087 -0.06
0.00872 -0.06
0.00874 -0.06
0.00876 -0.06
0.00878 -0.06
0.0088 -0.06
0.00882 -0.06
0.00884 -0.06
0.00886 -0.06
0.00888 -0.06
0.0089 -0.06
0.00892 -0.06
0.00894 -0.06
0.00896 -0.06
0.00898 -0.06
0.009 -0.06
0.00902 -0.06
0.00904 -0.06
0.00906 -0.06
0.00908 -0.06
0.0091 -0.06
0.00912 -0.06
0.00914 -0.06
0.00916 -0.06
0.00918 -0.06
0.0092 -0.06
0.00922 -0.06
0.00924 -0.06
0.00926 -0.06
0.00928 -0.06
0.0093 -0.06
0.00932 -0.06
0.00934 -0.06
0.00936 -0.06
0.00938 -0.06
0.0094 -0.06
0.00942 -0.06
0.00944 -0.06
0.00946 -0.06
0.00948 -0.06
0.0095 -0.06
0.00952 -0.06
0.00954 -0.06
0.00956 -0.06
0.00958 -0.06
0.0096 -0.06
0.00962 -0.06
0.00964 -0.06
0.00966 -0.06
0.00968 -0.06
0.0097 -0.06
0.00972 -0.06
0.00974 -0.06
0.00976 -0.06
0.00978 -0.06
0.0098 -0.06
0.00982 -0.06
0.00984 -0.06
0.00986 -0.06
0.00988 -0.06
0.0099 -0.06
0.00992 -0.06
0.00994 -0.06
0.00996 -0.06
0.00998 -0.06
0.01 -0.06
0.01002 -0.06
0.01004 -0.06
0.01006 -0.06
0.01008 -0.06
0.0101 -0.06
0.01012 -0.06
0.01014 -0.06
0.01016 -0.06
0.01018 -0.06
0.0102 -0.06
0.01022 -0.06
0.01024 -0.06
0.01026 -0.06
0.01028 -0.06
0.0103 -0.06
0.01032 -0.06
0.01034 -0.06
0.01036 -0.06
0.01038 -0.06
0.0104 -0.06
0.01042 -0.06
0.01044 -0.06
0.01046 -0.06
0.01048 -0.06
0.0105 -0.06
0.01052 -0.06
0.01054 -0.06
0.01056 -0.06
0.01058 -0.06
0.0106 -0.06
0.01062 -0.06
0.01064 -0.06
0.01066 -0.06
0.01068 -0.06
0.0107 -0.06
0.01072 -0.06
0.01074 -0.06
0.01076 -0.06
0.01078 -0.06
0.0108 -0.06
0.01082 -0.06
0.01084 -0.06
0.01086 -0.06
0.01088 -0.06
0.0109 -0.06
0.01092 -0.06
0.01094 -0.06
0.01096 -0.06
0.01098 -0.06
0.011 -0.06
0.01102 -0.06
0.01104 -0.06
0.01106 -0.06
0.01108 -0.06
0.0111 -0.06
0.01112 -0.06
0.01114 -0.06
0.01116 -0.06
0.01118 -0.06
0.0112 -0.06
0.01122 -0.06
0.01124 -0.06
0.01126 -0.06
0.01128 -0.06
0.0113 -0.06
0.01132 -0.06
0.01134 -0.06
0.01136 -0.06
0.01138 -0.06
0.0114 -0.06
0.01142 -0.06
0.01144 -0.06
0.01146 -0.06
0.01148 -0.06
0.0115 -0.06
0.01152 -0.06
0.01154 -0.06
0.01156 -0.06
0.01158 -0.06
0.0116 -0.06
0.01162 -0.06
0.01164 -0.06
0.01166 -0.06
0.01168 -0.06
0.0117 -0.06
0.01172 -0.06
0.01174 -0.06
0.01176 -0.06
0.01178 -0.06
0.0118 -0.06
0.01182 -0.06
0.01184 -0.06
0.01186 -0.06
0.01188 -0.06
0.0119 -0.06
0.01192 -0.06
0.01194 -0.06
0.01196 -0.06
0.01198 -0.06
0.012 -0.06
0.01202 -0.06
0.01204 -0.06
0.01206 -0.06
0.01208 -0.06
0.0121 -0.06
0.01212 -0.06
0.01214 -0.06
0.01216 -0.06
0.01218 -0.06
0.0122 -0.06
0.01222 -0.06
0.01224 -0.06
0.01226 -0.06
0.01228 -0.06
0.0123 -0.06
0.01232 -0.06
0.01234 -0.06
0.01236 -0.06
0.01238 -0.06
0.0124 -0.06
0.01242 -0.06
0.01244 -0.06
0.01246 -0.06
0.01248 -0.06
0.0125 -0.06
0.01252 -0.06
0.01254 -0.06
0.01256 -0.06
0.01258 -0.06
0.0126 -0.06
0.01262 -0.06
0.01264 -0.06
0.01266 -0.06
0.01268 -0.06
0.0127 -0.06
0.01272 -0.06
0.01274 -0.06
0.01276 -0.06
0.01278 -0.06
0.0128 -0.06
0.01282 -0.06
0.01284 -0.06
0.01286 -0.06
0.01288 -0.06
0.0129 -0.06
0.01292 -0.06
0.01294 -0.06
0.01296 -0.06
0.01298 -0.06
0.013 -0.06
0.01302 -0.06
0.01304 -0.06
0.01306 -0.06
0.01308 -0.06
0.0131 -0.06
0.01312 -0.06
0.01314 -0.06
0.01316 -0.06
0.01318 -0.06
0.0132 -0.06
0.01322 -0.06
0.01324 -0.06
0.01326 -0.06
0.01328 -0.06
0.0133 -0.06
0.01332 -0.06
0.01334 -0.06
0.01336 -0.06
0.01338 -0.06
0.0134 -0.06
0.01342 -0.06
0.01344 -0.06
0.01346 -0.06
0.01348 -0.06
0.0135 -0.06
0.01352 -0.06
0.01354 -0.06
0.01356 -0.06
0.01358 -0.06
0.0136 -0.06
0.01362 -0.06
0.01364 -0.06
0.01366 -0.06
0.01368 -0.06
0.0137 -0.06
0.01372 -0.06
0.01374 -0.06
0.01376 -0.06
0.01378 -0.06
0.0138 -0.06
0.01382 -0.06
0.01384 -0.06
0.01386 -0.06
0.01388 -0.06
0.0139 -0.06
0.01392 -0.06
0.01394 -0.06
0.01396 -0.06
0.01398 -0.06
0.014 -0.06
0.01402 -0.06
0.01404 -0.06
0.01406 -0.06
0.01408 -0.06
0.0141 -0.06
0.01412 -0.06
0.01414 -0.06
0.01416 -0.06
0.01418 -0.06
0.0142 -0.06
0.01422 -0.06
0.01424 -0.06
0.01426 -0.06
0.01428 -0.06
0.0143 -0.06
0.01432 -0.06
0.01434 -0.06
0.01436 -0.06
0.01438 -0.06
0.0144 -0.06
0.01442 -0.06
0.01444 -0.06
0.01446 -0.06
0.01448 -0.06
0.0145 -0.06
0.01452 -0.06
0.01454 -0.06
0.01456 -0.06
0.01458 -0.06
0.0146 -0.06
0.01462 -0.06
0.01464 -0.06
0.01466 -0.06
0.01468 -0.06
0.0147 -0.06
0.01472 -0.06
0.01474 -0.06
0.01476 -0.06
0.01478 -0.06
0.0148 -0.06
0.01482 -0.06
0.01484 -0.06
0.01486 -0.06
0.01488 -0.06
0.0149 -0.06
0.01492 -0.06
0.01494 -0.06
0.01496 -0.06
0.01498 -0.06
0.015 -0.06
0.01502 -0.06
0.01504 -0.06
0.01506 -0.06
0.01508 -0.06
0.0151 -0.06
0.01512 -0.06
0.01514 -0.06
0.01516 -0.06
0.01518 -0.06
0.0152 -0.06
0.01522 -0.06
0.01524 -0.06
0.01526 -0.06
0.01528 -0.06
0.0153 -0.06
0.01532 -0.06
0.01534 -0.06
0.01536 -0.06
0.01538 -0.06
0.0154 -0.06
0.01542 -0.06
0.01544 -0.06
0.01546 -0.06
0.01548 -0.06
0.0155 -0.06
0.01552 -0.06
0.01554 -0.06
0.01556 -0.06
0.01558 -0.06
0.0156 -0.06
0.01562 -0.06
0.01564 -0.06
0.01566 -0.06
0.01568 -0.06
0.0157 -0.06
0.01572 -0.06
0.01574 -0.06
0.01576 -0.06
0.01578 -0.06
0.0158 -0.06
0.01582 -0.06
0.01584 -0.06
0.01586 -0.06
0.01588 -0.06
0.0159 -0.06
0.01592 -0.06
0.01594 -0.06
0.01596 -0.06
0.01598 -0.06
0.016 -0.06
0.01602 -0.06
0.01604 -0.06
0.01606 -0.06
0.01608 -0.06
0.0161 -0.06
0.01612 -0.06
0.01614 -0.06
0.01616 -0.06
0.01618 -0.06
0.0162 -0.06
0.01622 -0.06
0.01624 -0.06
0.01626 -0.06
0.01628 -0.06
0.0163 -0.06
0.01632 -0.06
0.01634 -0.06
0.01636 -0.06
0.01638 -0.06
0.0164 -0.06
0.01642 -0.06
0.01644 -0.06
0.01646 -0.06
0.01648 -0.06
0.0165 -0.06
0.01652 -0.06
0.01654 -0.06
0.01656 -0.06
0.01658 -0.06
0.0166 -0.06
0.01662 -0.06
0.01664 -0.06
0.01666 -0.06
0.01668 -0.06
0.0167 -0.06
0.01672 -0.06
0.01674 -0.06
0.01676 -0.06
0.01678 -0.06
0.0168 -0.06
0.01682 -0.06
0.01684 -0.06
0.01686 -0.06
0.01688 -0.06
0.0169 -0.06
0.01692 -0.06
0.01694 -0.06
0.01696 -0.06
0.01698 -0.06
0.017 -0.06
0.01702 -0.06
0.01704 -0.06
0.01706 -0.06
0.01708 -0.06
0.0171 -0.06
0.01712 -0.06
0.01714 -0.06
0.01716 -0.06
0.01718 -0.06
0.0172 -0.06
0.01722 -0.06
0.01724 -0.06
0.01726 -0.06
0.01728 -0.06
0.0173 -0.06
0.01732 -0.06
0.01734 -0.06
0.01736 -0.06
0.01738 -0.06
0.0174 -0.06
0.01742 -0.06
0.01744 -0.06
0.01746 -0.06
0.01748 -0.06
0.0175 -0.06
0.01752 -0.06
0.01754 -0.06
0.01756 -0.06
0.01758 -0.06
0.0176 -0.06
0.01762 -0.06
0.01764 -0.06
0.01766 -0.06
0.01768 -0.06
0.0177 -0.06
0.01772 -0.06
0.01774 -0.06
0.01776 -0.06
0.01778 -0.06
0.0178 -0.06
0.01782 -0.06
0.01784 -0.06
0.01786 -0.06
0.01788 -0.06
0.0179 -0.06
0.01792 -0.06
0.01794 -0.06
0.01796 -0.06
0.01798 -0.06
0.018 -0.06
0.01802 -0.06
0.01804 -0.06
0.01806 -0.06
0.01808 -0.06
0.0181 -0.06
0.01812 -0.06
0.01814 -0.06
0.01816 -0.06
0.01818 -0.06
0.0182 -0.06
0.01822 -0.06
0.01824 -0.06
0.01826 -0.06
0.01828 -0.06
0.0183 -0.06
0.01832 -0.06
0.01834 -0.06
0.01836 -0.06
0.01838 -0.06
0.0184 -0.06
0.01842 -0.06
0.01844 -0.06
0.01846 -0.06
0.01848 -0.06
0.0185 -0.06
0.01852 -0.06
0.01854 -0.06
0.01856 -0.06
0.01858 -0.06
0.0186 -0.06
0.01862 -0.06
0.01864 -0.06
0.01866 -0.06
0.01868 -0.06
0.0187 -0.06
0.01872 -0.06
0.01874 -0.06
0.01876 -0.06
0.01878 -0.06
0.0188 -0.06
0.01882 -0.06
0.01884 -0.06
0.01886 -0.06
0.01888 -0.06
0.0189 -0.06
0.01892 -0.06
0.01894 -0.06
0.01896 -0.06
0.01898 -0.06
0.019 -0.06
0.01902 -0.06
0.01904 -0.06
0.01906 -0.06
0.01908 -0.06
0.0191 -0.06
0.01912 -0.06
0.01914 -0.06
0.01916 -0.06
0.01918 -0.06
0.0192 -0.06
0.01922 -0.06
0.01924 -0.06
0.01926 -0.06
0.01928 -0.06
0.0193 -0.06
0.01932 -0.06
0.01934 -0.06
0.01936 -0.06
0.01938 -0.06
0.0194 -0.06
0.01942 -0.06
0.01944 -0.06
0.01946 -0.06
0.01948 -0.06
0.0195 -0.06
0.01952 -0.06
0.01954 -0.06
0.01956 -0.06
0.01958 -0.06
0.0196 -0.06
0.01962 -0.06
0.01964 -0.06
0.01966 -0.06
0.01968 -0.06
0.0197 -0.06
0.01972 -0.06
0.01974 -0.06
0.01976 -0.06
0.01978 -0.06
0.0198 -0.06
0.01982 -0.06
0.01984 -0.06
0.01986 -0.06
0.01988 -0.06
0.0199 -0.06
0.01992 -0.06
0.01994 -0.06
0.01996 -0.06
0.01998 -0.06
0.02 -0.06
0.02002 -0.06
0.02004 -0.06
0.02006 -0.06
0.02008 -0.06
0.0201 -0.06
0.02012 -0.06
0.02014 -0.06
0.02016 -0.06
0.02018 -0.06
0.0202 -0.06
0.02022 -0.06
0.02024 -0.06
0.02026 -0.06
0.02028 -0.06
0.0203 -0.06
0.02032 -0.06
0.02034 -0.06
0.02036 -0.06
0.02038 -0.06
0.0204 -0.06
0.02042 -0.06
0.02044 -0.06
0.02046 -0.06
0.02048 -0.06
0.0205 -0.06
0.02052 -0.06
0.02054 -0.06
0.02056 -0.06
0.02058 -0.06
0.0206 -0.06
0.02062 -0.06
0.02064 -0.06
0.02066 -0.06
0.02068 -0.06
0.0207 -0.06
0.02072 -0.06
0.02074 -0.06
0.02076 -0.06
0.02078 -0.06
0.0208 -0.06
0.02082 -0.06
0.02084 -0.06
0.02086 -0.06
0.02088 -0.06
0.0209 -0.06
0.02092 -0.06
0.02094 -0.06
0.02096 -0.06
0.02098 -0.06
0.021 -0.06
0.02102 -0.06
0.02104 -0.06
0.02106 -0.06
0.02108 -0.06
0.0211 -0.06
0.02112 -0.06
0.02114 -0.06
0.02116 -0.06
0.02118 -0.06
0.0212 -0.06
0.02122 -0.06
0.02124 -0.06
0.02126 -0.06
0.02128 -0.06
0.0213 -0.06
0.02132 -0.06
0.02134 -0.06
0.02136 -0.06
0.02138 -0.06
0.0214 -0.06
0.02142 -0.06
0.02144 -0.06
0.02146 -0.06
0.02148 -0.06
0.0215 -0.06
0.02152 -0.06
0.02154 -0.06
0.02156 -0.06
0.02158 -0.06
0.0216 -0.06
0.02162 -0.06
0.02164 -0.06
0.02166 -0.06
0.02168 -0.06
0.0217 -0.06
0.02172 -0.06
0.02174 -0.06
0.02176 -0.06
0.02178 -0.06
0.0218 -0.06
0.02182 -0.06
0.02184 -0.06
0.02186 -0.06
0.02188 -0.06
0.0219 -0.06
0.02192 -0.06
0.02194 -0.06
0.02196 -0.06
0.02198 -0.06
0.022 -0.06
0.02202 -0.06
0.02204 -0.06
0.02206 -0.06
0.02208 -0.06
0.0221 -0.06
0.02212 -0.06
0.02214 -0.06
0.02216 -0.06
0.02218 -0.06
0.0222 -0.06
0.02222 -0.06
0.02224 -0.06
0.02226 -0.06
0.02228 -0.06
0.0223 -0.06
0.02232 -0.06
0.02234 -0.06
0.02236 -0.06
0.02238 -0.06
0.0224 -0.06
0.02242 -0.06
0.02244 -0.06
0.02246 -0.06
0.02248 -0.06
0.0225 -0.06
0.02252 -0.06
0.02254 -0.06
0.02256 -0.06
0.02258 -0.06
0.0226 -0.06
0.02262 -0.06
0.02264 -0.06
0.02266 -0.06
0.02268 -0.06
0.0227 -0.06
0.02272 -0.06
0.02274 -0.06
0.02276 -0.06
0.02278 -0.06
0.0228 -0.06
0.02282 -0.06
0.02284 -0.06
0.02286 -0.06
0.02288 -0.06
0.0229 -0.06
0.02292 -0.06
0.02294 -0.06
0.02296 -0.06
0.02298 -0.06
0.023 -0.06
0.02302 -0.06
0.02304 -0.06
0.02306 -0.06
0.02308 -0.06
0.0231 -0.06
0.02312 -0.06
0.02314 -0.06
0.02316 -0.06
0.02318 -0.06
0.0232 -0.06
0.02322 -0.06
0.02324 -0.06
0.02326 -0.06
0.02328 -0.06
0.0233 -0.06
0.02332 -0.06
0.02334 -0.06
0.02336 -0.06
0.02338 -0.06
0.0234 -0.06
0.02342 -0.06
0.02344 -0.06
0.02346 -0.06
0.02348 -0.06
0.0235 -0.06
0.02352 -0.06
0.02354 -0.06
0.02356 -0.06
0.02358 -0.06
0.0236 -0.06
0.02362 -0.06
0.02364 -0.06
0.02366 -0.06
0.02368 -0.06
0.0237 -0.06
0.02372 -0.06
0.02374 -0.06
0.02376 -0.06
0.02378 -0.06
0.0238 -0.06
0.02382 -0.06
0.02384 -0.06
0.02386 -0.06
0.02388 -0.06
0.0239 -0.06
0.02392 -0.06
0.02394 -0.06
0.02396 -0.06
0.02398 -0.06
0.024 -0.06
0.02402 -0.06
0.02404 -0.06
0.02406 -0.06
0.02408 -0.06
0.0241 -0.06
0.02412 -0.06
0.02414 -0.06
0.02416 -0.06
0.02418 -0.06
0.0242 -0.06
0.02422 -0.06
0.02424 -0.06
0.02426 -0.06
0.02428 -0.06
0.0243 -0.06
0.02432 -0.06
0.02434 -0.06
0.02436 -0.06
0.02438 -0.06
0.0244 -0.06
0.02442 -0.06
0.02444 -0.06
0.02446 -0.06
0.02448 -0.06
0.0245 -0.06
0.02452 -0.06
0.02454 -0.06
0.02456 -0.06
0.02458 -0.06
0.0246 -0.06
0.02462 -0.06
0.02464 -0.06
0.02466 -0.06
0.02468 -0.06
0.0247 -0.06
0.02472 -0.06
0.02474 -0.06
0.02476 -0.06
0.02478 -0.06
0.0248 -0.06
0.02482 -0.06
0.02484 -0.06
0.02486 -0.06
0.02488 -0.06
0.0249 -0.06
0.02492 -0.06
0.02494 -0.06
0.02496 -0.06
0.02498 -0.06
0.025 -0.06
0.02502 -0.06
0.02504 -0.06
0.02506 -0.06
0.02508 -0.06
0.0251 -0.06
0.02512 -0.06
0.02514 -0.06
0.02516 -0.06
0.02518 -0.06
0.0252 -0.06
0.02522 -0.06
0.02524 -0.06
0.02526 -0.06
0.02528 -0.06
0.0253 -0.06
0.02532 -0.06
0.02534 -0.06
0.02536 -0.06
0.02538 -0.06
0.0254 -0.06
0.02542 -0.06
0.02544 -0.06
0.02546 -0.06
0.02548 -0.06
0.0255 -0.06
0.02552 -0.06
0.02554 -0.06
0.02556 -0.06
0.02558 -0.06
0.0256 -0.06
0.02562 -0.06
0.02564 -0.06
0.02566 -0.06
0.02568 -0.06
0.0257 -0.06
0.02572 -0.06
0.02574 -0.06
0.02576 -0.06
0.02578 -0.06
0.0258 -0.06
0.02582 -0.06
0.02584 -0.06
0.02586 -0.06
0.02588 -0.06
0.0259 -0.06
0.02592 -0.06
0.02594 -0.06
0.02596 -0.06
0.02598 -0.06
0.026 -0.06
0.02602 -0.06
0.02604 -0.06
0.02606 -0.06
0.02608 -0.06
0.0261 -0.06
0.02612 -0.06
0.02614 -0.06
0.02616 -0.06
0.02618 -0.06
0.0262 -0.06
0.02622 -0.06
0.02624 -0.06
0.02626 -0.06
0.02628 -0.06
0.0263 -0.06
0.02632 -0.06
0.02634 -0.06
0.02636 -0.06
0.02638 -0.06
0.0264 -0.06
0.02642 -0.06
0.02644 -0.06
0.02646 -0.06
0.02648 -0.06
0.0265 -0.06
0.02652 -0.06
0.02654 -0.06
0.02656 -0.06
0.02658 -0.06
0.0266 -0.06
0.02662 -0.06
0.02664 -0.06
0.02666 -0.06
0.02668 -0.06
0.0267 -0.06
0.02672 -0.06
0.02674 -0.06
0.02676 -0.06
0.02678 -0.06
0.0268 -0.06
0.02682 -0.06
0.02684 -0.06
0.02686 -0.06
0.02688 -0.06
0.0269 -0.06
0.02692 -0.06
0.02694 -0.06
0.02696 -0.06
0.02698 -0.06
0.027 -0.06
0.02702 -0.06
0.02704 -0.06
0.02706 -0.06
0.02708 -0.06
0.0271 -0.06
0.02712 -0.06
0.02714 -0.06
0.02716 -0.06
0.02718 -0.06
0.0272 -0.06
0.02722 -0.06
0.02724 -0.06
0.02726 -0.06
0.02728 -0.06
0.0273 -0.06
0.02732 -0.06
0.02734 -0.06
0.02736 -0.06
0.02738 -0.06
0.0274 -0.06
0.02742 -0.06
0.02744 -0.06
0.02746 -0.06
0.02748 -0.06
0.0275 -0.06
0.02752 -0.06
0.02754 -0.06
0.02756 -0.06
0.02758 -0.06
0.0276 -0.06
0.02762 -0.06
0.02764 -0.06
0.02766 -0.06
0.02768 -0.06
0.0277 -0.06
0.02772 -0.06
0.02774 -0.06
0.02776 -0.06
0.02778 -0.06
0.0278 -0.06
0.02782 -0.06
0.02784 -0.06
0.02786 -0.06
0.02788 -0.06
0.0279 -0.06
0.02792 -0.06
0.02794 -0.06
0.02796 -0.06
0.02798 -0.06
0.028 -0.06
0.02802 -0.06
0.02804 -0.06
0.02806 -0.06
0.02808 -0.06
0.0281 -0.06
0.02812 -0.06
0.02814 -0.06
0.02816 -0.06
0.02818 -0.06
0.0282 -0.06
0.02822 -0.06
0.02824 -0.06
0.02826 -0.06
0.02828 -0.06
0.0283 -0.06
0.02832 -0.06
0.02834 -0.06
0.02836 -0.06
0.02838 -0.06
0.0284 -0.06
0.02842 -0.06
0.02844 -0.06
0.02846 -0.06
0.02848 -0.06
0.0285 -0.06
0.02852 -0.06
0.02854 -0.06
0.02856 -0.06
0.02858 -0.06
0.0286 -0.06
0.02862 -0.06
0.02864 -0.06
0.02866 -0.06
0.02868 -0.06
0.0287 -0.06
0.02872 -0.06
0.02874 -0.06
0.02876 -0.06
0.02878 -0.06
0.0288 -0.06
0.02882 -0.06
0.02884 -0.06
0.02886 -0.06
0.02888 -0.06
0.0289 -0.06
0.02892 -0.06
0.02894 -0.06
0.02896 -0.06
0.02898 -0.06
0.029 -0.06
0.02902 -0.06
0.02904 -0.06
0.02906 -0.06
0.02908 -0.06
0.0291 -0.06
0.02912 -0.06
0.02914 -0.06
0.02916 -0.06
0.02918 -0.06
0.0292 -0.06
0.02922 -0.06
0.02924 -0.06
0.02926 -0.06
0.02928 -0.06
0.0293 -0.06
0.02932 -0.06
0.02934 -0.06
0.02936 -0.06
0.02938 -0.06
0.0294 -0.06
0.02942 -0.06
0.02944 -0.06
0.02946 -0.06
0.02948 -0.06
0.0295 -0.06
0.02952 -0.06
0.02954 -0.06
0.02956 -0.06
0.02958 -0.06
0.0296 -0.06
0.02962 -0.06
0.02964 -0.06
0.02966 -0.06
0.02968 -0.06
0.0297 -0.06
0.02972 -0.06
0.02974 -0.06
0.02976 -0.06
0.02978 -0.06
0.0298 -0.06
0.02982 -0.06
0.02984 -0.06
0.02986 -0.06
0.02988 -0.06
0.0299 -0.06
0.02992 -0.06
0.02994 -0.06
0.02996 -0.06
0.02998 -0.06
0.03 -0.06
0.03002 -0.06
0.03004 -0.06
0.03006 -0.06
0.03008 -0.06
0.0301 -0.06
0.03012 -0.06
0.03014 -0.06
0.03016 -0.06
0.03018 -0.06
0.0302 -0.06
0.03022 -0.06
0.03024 -0.06
0.03026 -0.06
0.03028 -0.06
0.0303 -0.06
0.03032 -0.06
0.03034 -0.06
0.03036 -0.06
0.03038 -0.06
0.0304 -0.06
0.03042 -0.06
0.03044 -0.06
0.03046 -0.06
0.03048 -0.06
0.0305 -0.06
0.03052 -0.06
0.03054 -0.06
0.03056 -0.06
0.03058 -0.06
0.0306 -0.06
0.03062 -0.06
0.03064 -0.06
0.03066 -0.06
0.03068 -0.06
0.0307 -0.06
0.03072 -0.06
0.03074 -0.06
0.03076 -0.06
0.03078 -0.06
0.0308 -0.06
0.03082 -0.06
0.03084 -0.06
0.03086 -0.06
0.03088 -0.06
0.0309 -0.06
0.03092 -0.06
0.03094 -0.06
0.03096 -0.06
0.03098 -0.06
0.031 -0.06
0.03102 -0.06
0.03104 -0.06
0.03106 -0.06
0.03108 -0.06
0.0311 -0.06
0.03112 -0.06
0.03114 -0.06
0.03116 -0.06
0.03118 -0.06
0.0312 -0.06
0.03122 -0.06
0.03124 -0.06
0.03126 -0.06
0.03128 -0.06
0.0313 -0.06
0.03132 -0.06
0.03134 -0.06
0.03136 -0.06
0.03138 -0.06
0.0314 -0.06
0.03142 -0.06
0.03144 -0.06
0.03146 -0.06
0.03148 -0.06
0.0315 -0.06
0.03152 -0.06
0.03154 -0.06
0.03156 -0.06
0.03158 -0.06
0.0316 -0.06
0.03162 -0.06
0.03164 -0.06
0.03166 -0.06
0.03168 -0.06
0.0317 -0.06
0.03172 -0.06
0.03174 -0.06
0.03176 -0.06
0.03178 -0.06
0.0318 -0.06
0.03182 -0.06
0.03184 -0.06
0.03186 -0.06
0.03188 -0.06
0.0319 -0.06
0.03192 -0.06
0.03194 -0.06
0.03196 -0.06
0.03198 -0.06
0.032 -0.06
0.03202 -0.06
0.03204 -0.06
0.03206 -0.06
0.03208 -0.06
0.0321 -0.06
0.03212 -0.06
0.03214 -0.06
0.03216 -0.06
0.03218 -0.06
0.0322 -0.06
0.03222 -0.06
0.03224 -0.06
0.03226 -0.06
0.03228 -0.06
0.0323 -0.06
0.03232 -0.06
0.03234 -0.06
0.03236 -0.06
0.03238 -0.06
0.0324 -0.06
0.03242 -0.06
0.03244 -0.06
0.03246 -0.06
0.03248 -0.06
0.0325 -0.06
0.03252 -0.06
0.03254 -0.06
0.03256 -0.06
0.03258 -0.06
0.0326 -0.06
0.03262 -0.06
0.03264 -0.06
0.03266 -0.06
0.03268 -0.06
0.0327 -0.06
0.03272 -0.06
0.03274 -0.06
0.03276 -0.06
0.03278 -0.06
0.0328 -0.06
0.03282 -0.06
0.03284 -0.06
0.03286 -0.06
0.03288 -0.06
0.0329 -0.06
0.03292 -0.06
0.03294 -0.06
0.03296 -0.06
0.03298 -0.06
0.033 -0.06
0.03302 -0.06
0.03304 -0.06
0.03306 -0.06
0.03308 -0.06
0.0331 -0.06
0.03312 -0.06
0.03314 -0.06
0.03316 -0.06
0.03318 -0.06
0.0332 -0.06
0.03322 -0.06
0.03324 -0.06
0.03326 -0.06
0.03328 -0.06
0.0333 -0.06
0.03332 -0.06
0.03334 -0.06
0.03336 -0.06
0.03338 -0.06
0.0334 -0.06
0.03342 -0.06
0.03344 -0.06
0.03346 -0.06
0.03348 -0.06
0.0335 -0.06
0.03352 -0.06
0.03354 -0.06
0.03356 -0.06
0.03358 -0.06
0.0336 -0.06
0.03362 -0.06
0.03364 -0.06
0.03366 -0.06
0.03368 -0.06
0.0337 -0.06
0.03372 -0.06
0.03374 -0.06
0.03376 -0.06
0.03378 -0.06
0.0338 -0.06
0.03382 -0.06
0.03384 -0.06
0.03386 -0.06
0.03388 -0.06
0.0339 -0.06
0.03392 -0.06
0.03394 -0.06
0.03396 -0.06
0.03398 -0.06
0.034 -0.06
0.03402 -0.06
0.03404 -0.06
0.03406 -0.06
0.03408 -0.06
0.0341 -0.06
0.03412 -0.06
0.03414 -0.06
0.03416 -0.06
0.03418 -0.06
0.0342 -0.06
0.03422 -0.06
0.03424 -0.06
0.03426 -0.06
0.03428 -0.06
0.0343 -0.06
0.03432 -0.06
0.03434 -0.06
0.03436 -0.06
0.03438 -0.06
0.0344 -0.06
0.03442 -0.06
0.03444 -0.06
0.03446 -0.06
0.03448 -0.06
0.0345 -0.06
0.03452 -0.06
0.03454 -0.06
0.03456 -0.06
0.03458 -0.06
0.0346 -0.06
0.03462 -0.06
0.03464 -0.06
0.03466 -0.06
0.03468 -0.06
0.0347 -0.06
0.03472 -0.06
0.03474 -0.06
0.03476 -0.06
0.03478 -0.06
0.0348 -0.06
0.03482 -0.06
0.03484 -0.06
0.03486 -0.06
0.03488 -0.06
0.0349 -0.06
0.03492 -0.06
0.03494 -0.06
0.03496 -0.06
0.03498 -0.06
0.035 -0.06
0.03502 -0.06
0.03504 -0.06
0.03506 -0.06
0.03508 -0.06
0.0351 -0.06
0.03512 -0.06
0.03514 -0.06
0.03516 -0.06
0.03518 -0.06
0.0352 -0.06
0.03522 -0.06
0.03524 -0.06
0.03526 -0.06
0.03528 -0.06
0.0353 -0.06
0.03532 -0.06
0.03534 -0.06
0.03536 -0.06
0.03538 -0.06
0.0354 -0.06
0.03542 -0.06
0.03544 -0.06
0.03546 -0.06
0.03548 -0.06
0.0355 -0.06
0.03552 -0.06
0.03554 -0.06
0.03556 -0.06
0.03558 -0.06
0.0356 -0.06
0.03562 -0.06
0.03564 -0.06
0.03566 -0.06
0.03568 -0.06
0.0357 -0.06
0.03572 -0.06
0.03574 -0.06
0.03576 -0.06
0.03578 -0.06
0.0358 -0.06
0.03582 -0.06
0.03584 -0.06
0.03586 -0.06
0.03588 -0.06
0.0359 -0.06
0.03592 -0.06
0.03594 -0.06
0.03596 -0.06
0.03598 -0.06
0.036 -0.06
0.03602 -0.06
0.03604 -0.06
0.03606 -0.06
0.03608 -0.06
0.0361 -0.06
0.03612 -0.06
0.03614 -0.06
0.03616 -0.06
0.03618 -0.06
0.0362 -0.06
0.03622 -0.06
0.03624 -0.06
0.03626 -0.06
0.03628 -0.06
0.0363 -0.06
0.03632 -0.06
0.03634 -0.06
0.03636 -0.06
0.03638 -0.06
0.0364 -0.06
0.03642 -0.06
0.03644 -0.06
0.03646 -0.06
0.03648 -0.06
0.0365 -0.06
0.03652 -0.06
0.03654 -0.06
0.03656 -0.06
0.03658 -0.06
0.0366 -0.06
0.03662 -0.06
0.03664 -0.06
0.03666 -0.06
0.03668 -0.06
0.0367 -0.06
0.03672 -0.06
0.03674 -0.06
0.03676 -0.06
0.03678 -0.06
0.0368 -0.06
0.03682 -0.06
0.03684 -0.06
0.03686 -0.06
0.03688 -0.06
0.0369 -0.06
0.03692 -0.06
0.03694 -0.06
0.03696 -0.06
0.03698 -0.06
0.037 -0.06
0.03702 -0.06
0.03704 -0.06
0.03706 -0.06
0.03708 -0.06
0.0371 -0.06
0.03712 -0.06
0.03714 -0.06
0.03716 -0.06
0.03718 -0.06
0.0372 -0.06
0.03722 -0.06
0.03724 -0.06
0.03726 -0.06
0.03728 -0.06
0.0373 -0.06
0.03732 -0.06
0.03734 -0.06
0.03736 -0.06
0.03738 -0.06
0.0374 -0.06
0.03742 -0.06
0.03744 -0.06
0.03746 -0.06
0.03748 -0.06
0.0375 -0.06
0.03752 -0.06
0.03754 -0.06
0.03756 -0.06
0.03758 -0.06
0.0376 -0.06
0.03762 -0.06
0.03764 -0.06
0.03766 -0.06
0.03768 -0.06
0.0377 -0.06
0.03772 -0.06
0.03774 -0.06
0.03776 -0.06
0.03778 -0.06
0.0378 -0.06
0.03782 -0.06
0.03784 -0.06
0.03786 -0.06
0.03788 -0.06
0.0379 -0.06
0.03792 -0.06
0.03794 -0.06
0.03796 -0.06
0.03798 -0.06
0.038 -0.06
0.03802 -0.06
0.03804 -0.06
0.03806 -0.06
0.03808 -0.06
0.0381 -0.06
0.03812 -0.06
0.03814 -0.06
0.03816 -0.06
0.03818 -0.06
0.0382 -0.06
0.03822 -0.06
0.03824 -0.06
0.03826 -0.06
0.03828 -0.06
0.0383 -0.06
0.03832 -0.06
0.03834 -0.06
0.03836 -0.06
0.03838 -0.06
0.0384 -0.06
0.03842 -0.06
0.03844 -0.06
0.03846 -0.06
0.03848 -0.06
0.0385 -0.06
0.03852 -0.06
0.03854 -0.06
0.03856 -0.06
0.03858 -0.06
0.0386 -0.06
0.03862 -0.06
0.03864 -0.06
0.03866 -0.06
0.03868 -0.06
0.0387 -0.06
0.03872 -0.06
0.03874 -0.06
0.03876 -0.06
0.03878 -0.06
0.0388 -0.06
0.03882 -0.06
0.03884 -0.06
0.03886 -0.06
0.03888 -0.06
0.0389 -0.06
0.03892 -0.06
0.03894 -0.06
0.03896 -0.06
0.03898 -0.06
0.039 -0.06
0.03902 -0.06
0.03904 -0.06
0.03906 -0.06
0.03908 -0.06
0.0391 -0.06
0.03912 -0.06
0.03914 -0.06
0.03916 -0.06
0.03918 -0.06
0.0392 -0.06
0.03922 -0.06
0.03924 -0.06
0.03926 -0.06
0.03928 -0.06
0.0393 -0.06
0.03932 -0.06
0.03934 -0.06
0.03936 -0.06
0.03938 -0.06
0.0394 -0.06
0.03942 -0.06
0.03944 -0.06
0.03946 -0.06
0.03948 -0.06
0.0395 -0.06
0.03952 -0.06
0.03954 -0.06
0.03956 -0.06
0.03958 -0.06
0.0396 -0.06
0.03962 -0.06
0.03964 -0.06
0.03966 -0.06
0.03968 -0.06
0.0397 -0.06
0.03972 -0.06
0.03974 -0.06
0.03976 -0.06
0.03978 -0.06
0.0398 -0.06
0.03982 -0.06
0.03984 -0.06
0.03986 -0.06
0.03988 -0.06
0.0399 -0.06
0.03992 -0.06
0.03994 -0.06
0.03996 -0.06
0.03998 -0.06
0.04 -0.06
0.04002 -0.06
0.04004 -0.06
0.04006 -0.06
0.04008 -0.06
0.0401 -0.06
0.04012 -0.06
0.04014 -0.06
0.04016 -0.06
0.04018 -0.06
0.0402 -0.06
0.04022 -0.06
0.04024 -0.06
0.04026 -0.06
0.04028 -0.06
0.0403 -0.06
0.04032 -0.06
0.04034 -0.06
0.04036 -0.06
0.04038 -0.06
0.0404 -0.06
0.04042 -0.06
0.04044 -0.06
0.04046 -0.06
0.04048 -0.06
0.0405 -0.06
0.04052 -0.06
0.04054 -0.06
0.04056 -0.06
0.04058 -0.06
0.0406 -0.06
0.04062 -0.06
0.04064 -0.06
0.04066 -0.06
0.04068 -0.06
0.0407 -0.06
0.04072 -0.06
0.04074 -0.06
0.04076 -0.06
0.04078 -0.06
0.0408 -0.06
0.04082 -0.06
0.04084 -0.06
0.04086 -0.06
0.04088 -0.06
0.0409 -0.06
0.04092 -0.06
0.04094 -0.06
0.04096 -0.06
0.04098 -0.06
0.041 -0.06
0.04102 -0.06
0.04104 -0.06
0.04106 -0.06
0.04108 -0.06
0.0411 -0.06
0.04112 -0.06
0.04114 -0.06
0.04116 -0.06
0.04118 -0.06
0.0412 -0.06
0.04122 -0.06
0.04124 -0.06
0.04126 -0.06
0.04128 -0.06
0.0413 -0.06
0.04132 -0.06
0.04134 -0.06
0.04136 -0.06
0.04138 -0.06
0.0414 -0.06
0.04142 -0.06
0.04144 -0.06
0.04146 -0.06
0.04148 -0.06
0.0415 -0.06
0.04152 -0.06
0.04154 -0.06
0.04156 -0.06
0.04158 -0.06
0.0416 -0.06
0.04162 -0.06
0.04164 -0.06
0.04166 -0.06
0.04168 -0.06
0.0417 -0.06
0.04172 -0.06
0.04174 -0.06
0.04176 -0.06
0.04178 -0.06
0.0418 -0.06
0.04182 -0.06
0.04184 -0.06
0.04186 -0.06
0.04188 -0.06
0.0419 -0.06
0.04192 -0.06
0.04194 -0.06
0.04196 -0.06
0.04198 -0.06
0.042 -0.06
0.04202 -0.06
0.04204 -0.06
0.04206 -0.06
0.04208 -0.06
0.0421 -0.06
0.04212 -0.06
0.04214 -0.06
0.04216 -0.06
0.04218 -0.06
0.0422 -0.06
0.04222 -0.06
0.04224 -0.06
0.04226 -0.06
0.04228 -0.06
0.0423 -0.06
0.04232 -0.06
0.04234 -0.06
0.04236 -0.06
0.04238 -0.06
0.0424 -0.06
0.04242 -0.06
0.04244 -0.06
0.04246 -0.06
0.04248 -0.06
0.0425 -0.06
0.04252 -0.06
0.04254 -0.06
0.04256 -0.06
0.04258 -0.06
0.0426 -0.06
0.04262 -0.06
0.04264 -0.06
0.04266 -0.06
0.04268 -0.06
0.0427 -0.06
0.04272 -0.06
0.04274 -0.06
0.04276 -0.06
0.04278 -0.06
0.0428 -0.06
0.04282 -0.06
0.04284 -0.06
0.04286 -0.06
0.04288 -0.06
0.0429 -0.06
0.04292 -0.06
0.04294 -0.06
0.04296 -0.06
0.04298 -0.06
0.043 -0.06
0.04302 -0.06
0.04304 -0.06
0.04306 -0.06
0.04308 -0.06
0.0431 -0.06
0.04312 -0.06
0.04314 -0.06
0.04316 -0.06
0.04318 -0.06
0.0432 -0.06
0.04322 -0.06
0.04324 -0.06
0.04326 -0.06
0.04328 -0.06
0.0433 -0.06
0.04332 -0.06
0.04334 -0.06
0.04336 -0.06
0.04338 -0.06
0.0434 -0.06
0.04342 -0.06
0.04344 -0.06
0.04346 -0.06
0.04348 -0.06
0.0435 -0.06
0.04352 -0.06
0.04354 -0.06
0.04356 -0.06
0.04358 -0.06
0.0436 -0.06
0.04362 -0.06
0.04364 -0.06
0.04366 -0.06
0.04368 -0.06
0.0437 -0.06
0.04372 -0.06
0.04374 -0.06
0.04376 -0.06
0.04378 -0.06
0.0438 -0.06
0.04382 -0.06
0.04384 -0.06
0.04386 -0.06
0.04388 -0.06
0.0439 -0.06
0.04392 -0.06
0.04394 -0.06
0.04396 -0.06
0.04398 -0.06
0.044 -0.06
0.04402 -0.06
0.04404 -0.06
0.04406 -0.06
0.04408 -0.06
0.0441 -0.06
0.04412 -0.06
0.04414 -0.06
0.04416 -0.06
0.04418 -0.06
0.0442 -0.06
0.04422 -0.06
0.04424 -0.06
0.04426 -0.06
0.04428 -0.06
0.0443 -0.06
0.04432 -0.06
0.04434 -0.06
0.04436 -0.06
0.04438 -0.06
0.0444 -0.06
0.04442 -0.06
0.04444 -0.06
0.04446 -0.06
0.04448 -0.06
0.0445 -0.06
0.04452 -0.06
0.04454 -0.06
0.04456 -0.06
0.04458 -0.06
0.0446 -0.06
0.04462 -0.06
0.04464 -0.06
0.04466 -0.06
0.04468 -0.06
0.0447 -0.06
0.04472 -0.06
0.04474 -0.06
0.04476 -0.06
0.04478 -0.06
0.0448 -0.06
0.04482 -0.06
0.04484 -0.06
0.04486 -0.06
0.04488 -0.06
0.0449 -0.06
0.04492 -0.06
0.04494 -0.06
0.04496 -0.06
0.04498 -0.06
0.045 -0.06
0.04502 -0.06
0.04504 -0.06
0.04506 -0.06
0.04508 -0.06
0.0451 -0.06
0.04512 -0.06
0.04514 -0.06
0.04516 -0.06
0.04518 -0.06
0.0452 -0.06
0.04522 -0.06
0.04524 -0.06
0.04526 -0.06
0.04528 -0.06
0.0453 -0.06
0.04532 -0.06
0.04534 -0.06
0.04536 -0.06
0.04538 -0.06
0.0454 -0.06
0.04542 -0.06
0.04544 -0.06
0.04546 -0.06
0.04548 -0.06
0.0455 -0.06
0.04552 -0.06
0.04554 -0.06
0.04556 -0.06
0.04558 -0.06
0.0456 -0.06
0.04562 -0.06
0.04564 -0.06
0.04566 -0.06
0.04568 -0.06
0.0457 -0.06
0.04572 -0.06
0.04574 -0.06
0.04576 -0.06
0.04578 -0.06
0.0458 -0.06
0.04582 -0.06
0.04584 -0.06
0.04586 -0.06
0.04588 -0.06
0.0459 -0.06
0.04592 -0.06
0.04594 -0.06
0.04596 -0.06
0.04598 -0.06
0.046 -0.06
0.04602 -0.06
0.04604 -0.06
0.04606 -0.06
0.04608 -0.06
0.0461 -0.06
0.04612 -0.06
0.04614 -0.06
0.04616 -0.06
0.04618 -0.06
0.0462 -0.06
0.04622 -0.06
0.04624 -0.06
0.04626 -0.06
0.04628 -0.06
0.0463 -0.06
0.04632 -0.06
0.04634 -0.06
0.04636 -0.06
0.04638 -0.06
0.0464 -0.06
0.04642 -0.06
0.04644 -0.06
0.04646 -0.06
0.04648 -0.06
0.0465 -0.06
0.04652 -0.06
0.04654 -0.06
0.04656 -0.06
0.04658 -0.06
0.0466 -0.06
0.04662 -0.06
0.04664 -0.06
0.04666 -0.06
0.04668 -0.06
0.0467 -0.06
0.04672 -0.06
0.04674 -0.06
0.04676 -0.06
0.04678 -0.06
0.0468 -0.06
0.04682 -0.06
0.04684 -0.06
0.04686 -0.06
0.04688 -0.06
0.0469 -0.06
0.04692 -0.06
0.04694 -0.06
0.04696 -0.06
0.04698 -0.06
0.047 -0.06
0.04702 -0.06
0.04704 -0.06
0.04706 -0.06
0.04708 -0.06
0.0471 -0.06
0.04712 -0.06
0.04714 -0.06
0.04716 -0.06
0.04718 -0.06
0.0472 -0.06
0.04722 -0.06
0.04724 -0.06
0.04726 -0.06
0.04728 -0.06
0.0473 -0.06
0.04732 -0.06
0.04734 -0.06
0.04736 -0.06
0.04738 -0.06
0.0474 -0.06
0.04742 -0.06
0.04744 -0.06
0.04746 -0.06
0.04748 -0.06
0.0475 -0.06
0.04752 -0.06
0.04754 -0.06
0.04756 -0.06
0.04758 -0.06
0.0476 -0.06
0.04762 -0.06
0.04764 -0.06
0.04766 -0.06
0.04768 -0.06
0.0477 -0.06
0.04772 -0.06
0.04774 -0.06
0.04776 -0.06
0.04778 -0.06
0.0478 -0.06
0.04782 -0.06
0.04784 -0.06
0.04786 -0.06
0.04788 -0.06
0.0479 -0.06
0.04792 -0.06
0.04794 -0.06
0.04796 -0.06
0.04798 -0.06
0.048 -0.06
0.04802 -0.06
0.04804 -0.06
0.04806 -0.06
0.04808 -0.06
0.0481 -0.06
0.04812 -0.06
0.04814 -0.06
0.04816 -0.06
0.04818 -0.06
0.0482 -0.06
0.04822 -0.06
0.04824 -0.06
0.04826 -0.06
0.04828 -0.06
0.0483 -0.06
0.04832 -0.06
0.04834 -0.06
0.04836 -0.06
0.04838 -0.06
0.0484 -0.06
0.04842 -0.06
0.04844 -0.06
0.04846 -0.06
0.04848 -0.06
0.0485 -0.06
0.04852 -0.06
0.04854 -0.06
0.04856 -0.06
0.04858 -0.06
0.0486 -0.06
0.04862 -0.06
0.04864 -0.06
0.04866 -0.06
0.04868 -0.06
0.0487 -0.06
0.04872 -0.06
0.04874 -0.06
0.04876 -0.06
0.04878 -0.06
0.0488 -0.06
0.04882 -0.06
0.04884 -0.06
0.04886 -0.06
0.04888 -0.06
0.0489 -0.06
0.04892 -0.06
0.04894 -0.06
0.04896 -0.06
0.04898 -0.06
0.049 -0.06
0.04902 -0.06
0.04904 -0.06
0.04906 -0.06
0.04908 -0.06
0.0491 -0.06
0.04912 -0.06
0.04914 -0.06
0.04916 -0.06
0.04918 -0.06
0.0492 -0.06
0.04922 -0.06
0.04924 -0.06
0.04926 -0.06
0.04928 -0.06
0.0493 -0.06
0.04932 -0.06
0.04934 -0.06
0.04936 -0.06
0.04938 -0.06
0.0494 -0.06
0.04942 -0.06
0.04944 -0.06
0.04946 -0.06
0.04948 -0.06
0.0495 -0.06
0.04952 -0.06
0.04954 -0.06
0.04956 -0.06
0.04958 -0.06
0.0496 -0.06
0.04962 -0.06
0.04964 -0.06
0.04966 -0.06
0.04968 -0.06
0.0497 -0.06
0.04972 -0.06
0.04974 -0.06
0.04976 -0.06
0.04978 -0.06
0.0498 -0.06
0.04982 -0.06
0.04984 -0.06
0.04986 -0.06
0.04988 -0.06
0.0499 -0.06
0.04992 -0.06
0.04994 -0.06
0.04996 -0.06
0.04998 -0.06
0.05 -0.06
', # (join '', `cat $::config->{core_directory}/tests/specifications/strings/purkinje/edsjb1994-perfectclamp.txt`),
						   timeout => 300,
						   write => undef,
						  },
						 ],
				description => "cell builtin schedule applied to the Purkinje cell model, constant command voltage",
			       },
			      ],
       description => "cell builtin schedule applied to the Purkinje cell model",
       name => 'builtins/purkinje.t',
      };


return $test;


