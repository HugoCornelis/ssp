#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


BEGIN
{
    push @INC, './perl';

    push @INC, '/usr/local/glue/swig/perl';
}


use SSP;


$SIG{__DIE__}
    = sub {
	use Carp;

	confess @_;
    };


#t instantiate fake packages for engine and service backends ?
#t
#t seems over the edge right now ...
#t

sub main
{
}


main();


