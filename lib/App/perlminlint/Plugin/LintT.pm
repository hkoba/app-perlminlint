package App::perlminlint::Plugin::LintT;
# -*- coding: utf-8 -*-
use strict;
use warnings FATAL => qw/all/;
use App::perlminlint::Plugin::LintPL -as_base;

sub priority {1}

sub match {
  (my MY $plugin, my $fn) = @_;
  $fn =~ m{\.t\z}i
    or return;
}

sub gather_opts {
  (my MY $plugin, my $fn) = @_;

  my @opts = $plugin->SUPER::gather_opts($fn);

  #
  # Add -Ilib if $fn looks like t/.../*.t
  #
  if (my ($basedir) = $fn =~ m{^(.*/|)t/}) {
    my $libdir = $basedir . "lib";
    push @opts, "-I$libdir";
  }

  @opts;
}

1;
