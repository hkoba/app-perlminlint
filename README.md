App-perlminlint
====================

`perlminlint` is a simple wrapper of `perl -wc`.

SYNOPSIS
--------------------

```sh
% perlminlint  myscript.pl

% perlminlint  MyModule.pm

% perlminlint  t/00-load.t

% perlminlint  cpanfile
```

Editor Integration
--------------------

### Emacs

Load `elisp/perl-minlint.el` and run `M-x perl-minlint-mode`.
This will add `perl-minlint-run` to `after-save-hook`.
Also, you can run minlint by hitting `<F5>` too.

Plugin API
--------------------

You can add plugins like followings:

```perl
package App::perlminlint::Plugin::LintCPANfile;
use strict;
use warnings FATAL => qw/all/;

use App::perlminlint::Plugin -as_base;

use Module::CPANfile;

sub handle_match {
  my ($plugin, $fn) = @_;
  $fn =~ m{\bcpanfile\z}i
    and $plugin;
}

sub handle_test {
  my ($plugin, $fn) = @_;

  Module::CPANfile->load($fn)
    and "CPANfile $fn is OK";
}

1;
```


INSTALLATION
--------------------

(Not yet released to CPAN, please wait)

LICENSE
--------------------
This software is licensed under the same terms as Perl.

AUTHOR
--------------------
CPAN ID: HKOBA
