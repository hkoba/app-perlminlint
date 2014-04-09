package App::perlminlint::Plugin::LintPL;
# -*- coding: utf-8 -*-
use strict;
use warnings FATAL => qw/all/;

use App::perlminlint::Plugin -as_base;

sub priority {0}

sub handle_test {
  (my MY $plugin, my $fn) = @_;

  $plugin->match($fn)
    or return;

  my @opts = $plugin->gather_opts($fn);

  $plugin->app->system_perl(@opts, -wc => $fn);
}

sub match {
  (my MY $plugin, my $fn) = @_;
  $fn =~ m{\.(pl|t)\z}i
    or return;
}

sub gather_opts {
  (my MY $plugin, my $fn) = @_;

  $plugin->app->read_shbang_opts($fn);
}

1;
