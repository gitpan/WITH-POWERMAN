package X::Fast;
use warnings;
use strict;
use WITH DEBUG => 0;
sub _import { import 'X::Fast::impl', ':ALL' }
1;
