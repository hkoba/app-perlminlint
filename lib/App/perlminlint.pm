package App::perlminlint; sub MY () {__PACKAGE__}
# -*- coding: utf-8 -*-
use 5.009;
use strict;
use warnings FATAL => 'all';

our $VERSION = '0.1';

use Carp;
use autodie;

use App::perlminlint::Object -as_base;
use fields qw/libs
	      _plugins/;

require File::Basename;

use Module::Pluggable require => 1, sub_name => '_plugins';

sub run {
  my ($pack, $argv) = @_;

  my MY $app = $pack->new($pack->parse_argv($argv));

  print $app->lint(@$argv);
}

sub new {
  fields::new(shift);
}

sub parse_argv {}

sub lint {
  (my MY $self, my $fn) = @_;

  $self->call_plugin(handle_test => $fn, $self)
    or die "No way to test $fn\n";

  return "OK\n";
}

# XXX: plugin conformity test

sub call_plugin {
  (my MY $self, my ($method, @args)) = @_;
  foreach my $plugin ($self->plugins) {
    if (my @res = $self->apply_to($plugin, $method, @args)) {
      return @res;
    }
  }
  return;
}

sub apply_to {
  (my MY $self, my ($plugin, $method, @args)) = @_;

  $plugin->new(app => $self)->$method(@args);
}

sub plugins {
  (my MY $self) = @_;
  my $plugins = $self->{_plugins}
    //= [sort {$b->priority <=> $a->priority} $self->_plugins];
  wantarray ? @$plugins : $plugins;
}

sub system_perl {
  my MY $self = shift;
  system($^X, @_) == 0
    or exit $? >> 8;
}

sub read_file {
  (my MY $self, my $fn) = @_;
  open my $fh, '<', $fn;
  local $/;
  scalar <$fh>;
}

sub basename {
  shift; File::Basename::basename(@_);
}

sub dirname {
  shift; File::Basename::dirname(@_);
}

sub rootname {
  shift;
  my $fn = shift;
  $fn =~ s/\.\w+$//;
  join "", $fn, @_;
}

sub inc_opt {
  my ($app, $file, $modname) = @_;
  (my $no_pm = $file) =~ s/\.\w+$//;
  my @filepath = $app->splitdir($app->rel2abs($no_pm));
  my @modpath = grep {$_ ne ''} split "::", $modname;
  my @popped;
  while (@modpath and @filepath and $modpath[-1] eq $filepath[-1]) {
    unshift @popped, pop @modpath;
    pop @filepath;
  }
  if (@modpath) {
    die "Can't find library root directory of $modname in file $file\n@modpath\n";
  }
  '-I' . $app->catdir(@filepath);
}

sub read_shbang_opts {
  (my MY $app, my $fn) = @_;

  my @opts;

  my $body = $app->read_file($fn);

  my (@shbang) = $app->parse_shbang($body);

  if (grep {$_ eq "-T"} @shbang) {
    push @opts, "-T";
  }

  @opts;
}

sub parse_shbang {
  my MY $app = shift;
  my ($shbang) = $_[0] =~ m{^(\#![^\n]+)}
    or return;
  split " ", $shbang;
}

1; # End of App::perlminlint
