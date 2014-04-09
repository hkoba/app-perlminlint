package App::perlminlint::Plugin::LintCPANfile;
# -*- coding: utf-8 -*-
use strict;
use warnings FATAL => qw/all/;

use App::perlminlint::Plugin -as_base;

use Module::CPANfile;

sub handle_test {
  my ($plugin, $fn) = @_;
  $fn =~ m{\bcpanfile\z}i
    or return;

  Module::CPANfile->load($fn);
}

1;
