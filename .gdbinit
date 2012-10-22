file /usr/bin/perl
# set args -d:ptkdb ./tests/perl/spiker4
set args ./tests/perl/spiker4
set args ./../bin/ssp '--optimize' '--cell' 'cells/purkinje/edsjb1994.ndf' '--model-name' '/Purkinje' '--inject-magnitude' '1e-9' '--emit-output' 'output/Purkinje.out'
set args ./tests/perl/hardcoded-tables2
set args -d:ptkdb ./tests/perl/cal1
set args ./tests/perl/cal2
# b swig_pq_set
# b HeccerConstruct
# b HeccerConnect
b EventQueuerDataNew

# set args bin/ssp '--cell' '/tmp/traub91.ndf' '--model-name' 'cell' '--output-fields' '/cell/soma->Vm' --time 0.15 --time-step 5e-5 --optimize --dump
set args bin/ssp '--cell' '/home/hugo/conversion1.ndf' '--model-name' '/n' '--output-fields' '/cell/soma->Vm' --time 0.15 --time-step 5e-5 --optimize --dump
set args bin/ssp '--cell' 'cells/stand_alone.ndf' '--inject-magnitude' '2e-8' '--inject-delay' '0.01' '--inject-duration' '0.03' '--time' '0.06' '--output' '/stand_alone/segments/soma->Vm' '--emit-output' 'output/stand_alone.out'
