package App::perlminlint::Plugin::LintPM;
use strict;
use warnings FATAL => qw/all/;
use autodie;

use App::perlminlint::Plugin -as_base;

sub priority {0}

sub handle_test {
  my ($app, $pack, $fn) = @_;

  $fn =~ m{\.pm\z}
    or return;

  defined (my $modname = $app->apply_to($pack, find_module => $fn))
    or die "Can't extract module name from $fn\n";

  my @inc_opt = $app->inc_opt($fn, $modname);

  $app->system_perl(@inc_opt, -we => "require $modname")
    and print "Module $modname is OK";
}

sub find_module {
  my ($app, $pack, $fn) = @_;

  local $_ = $app->read_file($fn);

  while (/(?:^|\n) [\ \t]*     (?# line beginning + space)
	  package  [\n\ \t]+   (?# newline is allowed here)
	  ([\w:]+)             (?# module name)
	  \s* [;\{]            (?# statement or block)
	 /xsg) {
    my ($modname) = $1;

    # Tail of $modname should be equal to it's rootname.
    if (((split /::/, $modname)[-1]) eq $app->rootname($app->basename($fn))) {
      return $modname;
    }
  }
  return;
}

1;
