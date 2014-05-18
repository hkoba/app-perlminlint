use strict;
use warnings;
use Module::Build;
use Module::CPANfile;
use FindBin;

my $cpanfile = Module::CPANfile->load("$FindBin::Bin/cpanfile");

my $builder = Module::Build->new
  (module_name       => 'App::perlminlint'
   , dist_version_from   => 'lib/App/perlminlint.pm'
   , dist_author           => q{KOBAYASHI, Hiroaki <hkoba@cpan.org>},
   , license => 'perl'
   , requires => $cpanfile->prereqs->{runtime}->{requires}
   , build_requires => $cpanfile->prereqs->{build}->{requires}
 );

$builder->create_build_script();
