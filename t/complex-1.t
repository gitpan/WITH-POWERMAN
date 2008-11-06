use warnings;
use strict;
use Test::More tests => 12;
use lib 't';

use X::Complex;

ok(   __PACKAGE__       ->can('get_debug')      );
ok( ! __PACKAGE__       ->can('get_test')       );
ok( ! __PACKAGE__       ->can('get_verbose')    );
ok( ! X::Complex        ->can('get_debug')      );
ok( ! X::Complex        ->can('get_test')       );
ok( ! X::Complex        ->can('get_verbose')    );
ok(   X::Complex::impl  ->can('get_debug')      );
ok(   X::Complex::impl  ->can('get_test')       );
ok(   X::Complex::impl  ->can('get_verbose')    );
is(get_debug(), 0);
is(X::Complex::impl::get_test(), 1);
is(X::Complex::impl::get_verbose(), 2);

