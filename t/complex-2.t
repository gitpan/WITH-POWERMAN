use warnings;
use strict;
use Test::More tests => 14;
use Test::Exception;
use lib 't';

use X::Complex WITH => { DEBUG => 10, VERBOSE => 12 }, qw(get_test);
use X::Complex WITH => { DEBUG => 10 }, qw(get_verbose);
use X::Complex;

ok(   __PACKAGE__       ->can('get_debug')      );
ok(   __PACKAGE__       ->can('get_test')       );
ok(   __PACKAGE__       ->can('get_verbose')    );
ok( ! X::Complex        ->can('get_debug')      );
ok( ! X::Complex        ->can('get_test')       );
ok( ! X::Complex        ->can('get_verbose')    );
ok(   X::Complex::impl  ->can('get_debug')      );
ok(   X::Complex::impl  ->can('get_test')       );
ok(   X::Complex::impl  ->can('get_verbose')    );
is(get_debug(), 10);
is(get_test(), 1);
is(get_verbose(), 12);

throws_ok { eval 'use X::Complex WITH => { TEST => 11 }; 1' or die $@ }
    qr/conflict:.* 'TEST' from '1' to '11'/;
lives_ok  { eval 'use X::Complex WITH => { TEST => 1  }; 1' or die $@ };

