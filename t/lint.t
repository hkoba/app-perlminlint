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
  my $out  = qx(cd $test.d/deep/deep; $^X $script $fn 2>&1);
  is_deeply [$out, $?], ["Module deep::deep::mod is OK\n", 0], $fn;
}

{
  my $test = "$inputdir/4";
  my $fn   = "$test.d/foo.pl";
  my $want = "$fn syntax OK\n";
  my $out  = qx($^X $script $fn 2>&1);
  if (defined $out and not $?) {
    eq_or_diff_subst($bindir, $out, $want, $fn);
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/5";
  my $fn   = "$test.d/foo.pl";
  my $want = read_file("$test.err");
  my $out = qx($^X $script $fn 2>&1);
  if (defined $out and $?) {
    eq_or_diff_subst($bindir, $out, $want, "$fn + .perlminlint.yml no_auto_libdir ");
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/5";
  my $fn   = "$test.d/foo.pl";
  my $want = "$fn syntax OK\n";
  my $out = qx($^X $script -I$test.d/lib $fn 2>&1);
  if (defined $out and not $?) {
    eq_or_diff_subst($bindir, $out, $want, "-Ilib $fn");
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/5";
  my $fn   = "$test.d/foo.pl";
  my $want = "$fn syntax OK\n";
  my $out = qx($^X $script -Mlib=$test.d/lib $fn 2>&1);
  if (defined $out and not $?) {
    eq_or_diff_subst($bindir, $out, $want, "-Mlib=lib $fn");
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/6";
  my $fn   = "$test.d/lib/Foo.pm";
  my $out  = qx(cd $test.d/; $^X $script $fn 2>&1);
  is_deeply [$out, $?], ["Module Foo is OK\n", 0], $fn;
}

{
  my $test = "$inputdir/6";
  my $fn   = "$test.d/lib/Foo.pm";
  my $out  = qx(cd $test.d/; $^X $script --no_force_warnings=0 $fn 2>&1);
  like $out, qr{^False \[\] range}, "--no_force_warnings=0 $fn";
}

{
  my $test = "$inputdir/6";
  my $fn   = "$test.d/foo.pl";
  my $want = "$fn syntax OK\n";
  my $out  = qx($^X $script $fn 2>&1);
  if (defined $out and not $?) {
    eq_or_diff_subst($bindir, $out, $want, $fn);
  } else {
    fail $fn;
  }
}

{
  my $test = "$inputdir/6";
  my $fn   = "$test.d/foo.pl";
  my $out  = qx(cd $test.d/; $^X $script --no_force_warnings=0 $fn 2>&1);
  like $out, qr{^False \[\] range}, "--no_force_warnings=0 $fn";
}

{
  my $test = "$inputdir/7";
  my $fn   = "$test.d/plugin/foo/lib/Foo.pm";
  my $want = "$fn syntax OK\n";
  my $out  = qx($^X $script $fn 2>&1);
  is_deeply [$out, $?], ["Module Foo is OK\n", 0], $fn;
}

SKIP: {
  skip "requires v5.38", 1 unless $] >= 5.038;
  my $test = "$inputdir/8";
  my $fn   = "$test.d/lib/Foo.pm";
  my $want = "$fn syntax OK\n";
  my $out  = qx($^X $script $fn 2>&1);
  is_deeply [$out, $?], ["Module Foo is OK\n", 0], $fn;
}

SKIP: {
  skip "requires v5.38", 1 unless $] >= 5.038;
  my $test = "$inputdir/8";
  my $fn   = "$test.d/lib/Foo/Bar.pm";
  my $want = "$fn syntax OK\n";
  my $out  = qx($^X $script $fn 2>&1);
  is_deeply [$out, $?], ["Module Foo::Bar is OK\n", 0], $fn;
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
  like $got, qr/^$expect/, $title;
}
