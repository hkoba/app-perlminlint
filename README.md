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

[perl-minlint-mode](./elisp/README.md) is provided.
In this mode, perlminlint is called automatically whenever you save your script.
You can run perlminlint manually by hitting `<F5>`.
If your script has an error, cursor will jump to the position.

### Vim

Not yet completed, but proof of concept code exists.


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

Not yet released to CPAN. 
If you have `~/bin` in your PATH, you can use this like following:

```sh
cd ~/bin
git clone https://github.com/hkoba/app-perlminlint.git
ln -s app-perlminlint/script/perlminlint .
```

* For Emacs, please read [this instruction](./elisp/README.md).

LICENSE
--------------------
This software is licensed under the same terms as Perl.

AUTHOR
--------------------
CPAN ID: HKOBA
