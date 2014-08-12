use strict;
use warnings;
use Module::Build::Pluggable 'CPANfile';
use FindBin;

my $builder = Module::Build::Pluggable->new
  (module_name       => 'App::perlminlint'
   , dist_version_from   => 'lib/App/perlminlint.pm'
   , dist_author           => q{KOBAYASHI, Hiroaki <hkoba@cpan.org>},
   , license => 'perl'
   , script_files =>
   +{map(("script/$_" => "bin/$_"), qw/perlminlint/)}
 );

$builder->create_build_script();
