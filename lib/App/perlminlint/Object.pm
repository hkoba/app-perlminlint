package App::perlminlint::Object; sub MY () {__PACKAGE__}
use strict;
use warnings FATAL => qw/all/;
use Carp;

use parent qw/File::Spec/;

our %FIELDS;

sub new {
  my MY $self = fields::new(shift);
  $self->configure(@_);
  $self->after_new;
  $self;
}

sub after_new {}

sub configure {
  (my MY $self) = shift;

  my @args = @_ == 1 && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

  my $fields = _fields_hash($self);

  my @task;
  while (my ($key, $value) = splice @args, 0, 2) {
    unless (defined $key) {
      croak "Undefined option name for class ".ref($self);
    }
    next unless $key =~ m{^[A-Za-z]\w+\z};
    unless (exists $fields->{$key}) {
      croak "Unknown option for class ".ref($self).": ".$key;
    }

    if (my $sub = $self->can("onconfigure_$key")) {
      push @task, [$sub, $value];
    } else {
      $self->{$key} = $value;
    }
  }

  $_->[0]->($self, $_->[-1]) for @task;

  $self;
}

sub extend {
  (my MY $self, my ($pack, @fields)) = @_;

  push @{*{_globref($pack, 'ISA')}}, ref($self) || $self;

  my $super = _fields_hash($self);
  my $extended = _fields_hash($pack);

  foreach my $name (keys %$super) {
    $extended->{$name} = $super->{$name}; # XXX: clone?
  }

  foreach my $spec (@fields) {
    my ($name, @rest) = ref $spec ? @$spec : $spec;
    my $has_getter = $name =~ s/^\^//;
    $extended->{$name} = \@rest; # XXX: should have better object.
    if ($has_getter) {
      *{_globref($pack, $name)} = sub { $_[0]->{$name} };
    }
  }

  $pack;
}

sub import {
  my ($pack, @args) = @_;
  if (@args and $args[0] =~ /^-(\w+)$/) {
    my $method = "_import_$1";
    $pack->$method(scalar caller, @args[1..$#args]);
  } else {
    require Exporter;
    goto &Exporter::import;
  }
}

sub _import_as_base {
  my ($myPack, $callpack, @fields) = @_;

  $myPack->extend($callpack, @fields);

  my $my_sym = _globref($callpack, 'MY');
  *$my_sym = sub () {$callpack} unless *{$my_sym}{CODE};

}


sub _fields_hash {
  my $sym = _fields_symbol(@_);
  unless (*{$sym}{HASH}) {
    *$sym = {};
  }
  *{$sym}{HASH};
}

sub _fields_symbol {
  _globref($_[0], 'FIELDS');
}

sub _globref {
  my ($thing, $name) = @_;
  my $class = ref $thing || $thing;
  no strict 'refs';
  \*{join("::", $class, defined $name ? $name : ())};
}

1;
