file /usr/bin/perl
set args ./tests/perl/spiker3
set args bin/ssp '--cell' '/tmp/traub91.ndf' '--model-name' 'cell' '--output-fields' '/cell/soma->Vm' --time 0.15 --time-step 5e-5 --optimize --dump
