use warnings;
use strict;
use Test::More tests => 4;
use lib 't';

use X::Empty;

ok( ! __PACKAGE__       ->can('empty') );
ok( ! X::Empty          ->can('empty') );
ok(   X::Empty::impl    ->can('empty') );
is(X::Empty::impl::empty(), 'empty loaded');

