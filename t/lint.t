#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Differences;

use FindBin;

my $bindir   = "$FindBin::Bin/";
my $script   = $bindir . "../script/perlminlint";
my $libdir   = $bindir . "../lib";
my $inputdir = $bindir . "in";

{
  my $test = "$inputdir/1";
  my $fn   = "$test.d/ng.pl";
  my $want = read_file("$test.err");
  my $out = qx($^X $script $fn 2>&1);
  if (defined $out and $?) {
    eq_or_diff_subst($bindir, $out, $want, $fn);
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/2";
  my $fn   = "$test.d/ng.pm";
  my $want = read_file("$test.err");
  my $out = qx($^X $script $fn 2>&1);
  if (defined $out and $?) {
    eq_or_diff_subst($bindir, $out, $want, $fn);
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/3";
  my $fn   = "$test.d/deep/deep/mod.pm";
  chdir "$test.d/deep/deep" or die "Can't chdir! $!";
  my $out  = qx($^X $script $fn 2>&1 1>&/dev/null);
  is_deeply [$out, $?], ['', 0], $fn;
}

done_testing();

sub rootname {
  my ($fn) = @_;
  $fn =~ s/\.\w+$//;
  $fn;
}

sub read_file {
  open my $fh, '<', $_[0] or die "$_[0]: $!";
  local $/;
  scalar <$fh>;
}

sub eq_or_diff_subst {
  my ($subst, $got, $expect, $title) = @_;
  foreach ($got, $expect) {
    $_ =~ s{(?<=\n| )\Q$subst\E}{}g;
  }
  eq_or_diff($got, $expect, $title);
}
