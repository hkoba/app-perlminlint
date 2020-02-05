package App::perlminlint::Plugin::LintPL;
# -*- coding: utf-8 -*-
use strict;
use warnings FATAL => qw/all/;

use App::perlminlint::Plugin -as_base
  , [priority => 0], -is_generic
  , qw/APP/
  ;

sub handle_match {
  (my MY $plugin, my $fn) = @_;
  $fn =~ m{\.(pl|t)\z}
    and $plugin;
}

sub handle_test {
  (my MY $plugin, my $fn) = @_;

  my APP $app = $plugin->app;

  my @opts = $plugin->gather_opts($fn);

  push @opts, '-w' unless $app->{no_force_warnings};

  $app->run_perl(@opts, -c => $fn)
    and ""; # Empty message.
}

sub gather_opts {
  (my MY $plugin, my $fn) = @_;

  $plugin->app->read_shbang_opts($fn);
}

1;
