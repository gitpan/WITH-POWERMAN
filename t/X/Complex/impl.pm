package X::Complex::impl;
use warnings;
use strict;

require Exporter;
our @ISA = qw(Exporter);
#use Exporter qw(import);

our @EXPORT     = qw( get_debug );
our @EXPORT_OK  = qw( get_test get_verbose );

sub DEBUG ();

sub get_debug {
    return DEBUG;
}

sub get_test {
    return TEST();
}

sub get_verbose {
    return &VERBOSE;
}

1;
