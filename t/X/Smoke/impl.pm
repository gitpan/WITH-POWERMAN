package X::Smoke::impl;
use warnings;
use strict;
use Perl6::Export::Attrs;

sub DEBUG ();

sub get_debug :Export {
    return DEBUG;
}

1;
