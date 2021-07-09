package Foo;
use strict;
use warnings;

use Bar;

sub foo {
  print Bar::bar, "\n";
}

1;
