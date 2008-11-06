use warnings;
use strict;
use Test::More tests => 5;
use lib 't';

use X::CustomLoader;

ok( ! __PACKAGE__       ->can('custom') );
ok(   X::CustomLoader   ->can('custom') );
ok( ! X::Custom         ->can('custom') );
ok(   X::Custom::impl   ->can('custom') );
is(X::CustomLoader::custom(), 'custom import works');

