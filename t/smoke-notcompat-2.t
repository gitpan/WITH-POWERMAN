use warnings;
use strict;
use Test::More tests => 3;
use Test::Exception;
use lib 't';

use X::Smoke WITH => { DEBUG => 2 };
lives_ok  { eval 'use X::Smoke WITH => { DEBUG => 2 }; 1' or die $@ };
lives_ok  { eval 'use X::Smoke WITH => {            }; 1' or die $@ };
throws_ok { eval 'use X::Smoke WITH => { DEBUG => 0 }; 1' or die $@ }
    qr/conflict: .* 'DEBUG' from '2' to '0'/;

