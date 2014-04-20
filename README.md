App-perlminlint
====================

SYNOPSIS
--------------------

```sh
% perlminlint  myscript.pl

% perlminlint  MyModule.pm

% perlminlint  t/00-load.t

% perlminlint  cpanfile
```

You can add plugin like followings:

```perl
package App::perlminlint::Plugin::LintCPANfile;
use strict;
use warnings FATAL => qw/all/;

use App::perlminlint::Plugin -as_base;

use Module::CPANfile;

sub match {
}

sub handle_test {
  my ($plugin, $fn) = @_;
  $fn =~ m{\bcpanfile\z}i
    or return;

  Module::CPANfile->load($fn);
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
