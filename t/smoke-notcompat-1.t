use warnings;
use strict;
use Test::More tests => 1;
use Test::Exception;
use lib 't';

use X::Smoke;
throws_ok { eval 'use X::Smoke WITH => { DEBUG => 2 }; 1' or die $@ }
    qr/conflict: .* 'DEBUG' from '0' to '2'/;

