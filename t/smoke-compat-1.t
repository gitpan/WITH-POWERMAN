use warnings;
use strict;
use Test::More tests => 1;
use lib 't';

use X::Smoke WITH => { DEBUG => 0 };
use X::Smoke qw(get_debug);
use X::Smoke WITH => { DEBUG => 0 };
use X::Smoke WITH => { };

is(get_debug(), 0);

