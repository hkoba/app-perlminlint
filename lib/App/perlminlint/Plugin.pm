package App::perlminlint::Plugin; sub MY () {__PACKAGE__}
# -*- coding: utf-8 -*-
use 5.009;
use strict;
use warnings FATAL => 'all';
use Carp;

use App::perlminlint::Object -as_base, qw/^app/;

sub NIMPL {
  my ($pkg, $file, $line, $subname) = caller($_[0] // 1);
  $subname =~ s/^.*?::(\w+)$/$1/;
  croak "Plugin method $subname is not implemented in $pkg";
}

sub priority { 1 }

sub handle_test { NIMPL() }

1;
