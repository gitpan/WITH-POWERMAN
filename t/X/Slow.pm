package X::Slow;
use warnings;
use strict;
use Perl6::Export::Attrs;

our $DEBUG = 0;

sub worker :Export {
    my ($n) = @_;
    my ($sum, $debug) = (0, 0);
    for (1 .. $n) {
        $debug += $_ if $DEBUG;
        $sum += $_;
    }
    return ($sum, $debug);
}

1;
