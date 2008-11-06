package X::Custom::impl;
use warnings;
use strict;

sub import {
    no strict;
    *{"${\scalar caller}::$_"} = \&{$_} for qw(custom);
}

sub custom {
    return 'custom import works';
}

1;
