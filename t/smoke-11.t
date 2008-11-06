use warnings;
use strict;
use Test::More tests => 4;
use lib 't';

use X::Smoke WITH => { DEBUG => 0 };

ok( ! __PACKAGE__       ->can('get_debug') );
ok( ! X::Smoke          ->can('get_debug') );
ok(   X::Smoke::impl    ->can('get_debug') );
is(X::Smoke::impl::get_debug(), 0);

