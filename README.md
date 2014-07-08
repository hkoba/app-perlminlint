App-perlminlint
====================

`perlminlint` is a simple wrapper of `perl -wc`.

SYNOPSIS
--------------------

```sh
% perlminlint  myscript.pl
#  => This tests "perl -wc myscript.pl"

% perlminlint  MyModule.pm
#  => This tests "perl -MMyModule -we0"

% perlminlint  MyInnerModule.pm
#  => This tests "perl -I.. -MMyApp::MyInnerModule -we0"

% perlminlint  cpanfile
#  => This tests Module::CPANfile->load

% perlminlint -w -c -wc myscript.pl
# -w, -c and -wc is just ignored for 'perl -wc' compatibility.
```

Editor Integration
--------------------

### Emacs

#### Flycheck

You may use perlminlint with
[Flycheck](http://flycheck.readthedocs.org/en/latest/index.html),
but you need to modify existing handler.
See [flycheck-perlminlint/](flycheck-perlminlint/README.md)


#### (Bundled) perl-minlint-mode

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
