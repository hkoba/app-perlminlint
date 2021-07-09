#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";

plan tests => 1;

BEGIN {
    use_ok( 'App::perlminlint' ) || print "Bail out!\n";
}

diag( "Testing App::perlminlint $App::perlminlint::VERSION, Perl $], $^X" );
