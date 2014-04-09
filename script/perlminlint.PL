#!/usr/bin/env perl
use strict;
use warnings FATAL => qw/all/;

use FindBin qw($Bin);
BEGIN {push @INC, "$Bin/../lib"}; # To allow using plugins from PERL5LIB.

use App::perlminlint;

App::perlminlint->run(\@ARGV);
