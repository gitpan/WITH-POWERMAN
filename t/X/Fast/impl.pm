package X::Fast::impl;
use warnings;
use strict;
use Perl6::Export::Attrs;
X::Fast::_import();

sub DEBUG ();

sub worker :Export {
    my ($n) = @_;
    my ($sum, $debug) = (0, 0);
    for (1 .. $n) {
        $debug += $_ if DEBUG;
        $sum += $_;
    }
    return ($sum, $debug);
}

1;
