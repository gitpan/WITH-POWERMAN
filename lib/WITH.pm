package WITH;

use warnings;
use strict;
use Carp;

# update DEPENDENCIES in POD & Makefile.PL & README
use version; our $VERSION = qv('0.0.2');    # update POD & Changes & README

use Sub::Uplevel;


sub import {
    my (undef, %with)   = @_;
    my $pkg             = caller;
    my $impl_pkg        = $pkg.'::impl';
    no strict 'refs';
    *{$pkg.'::import'} = sub { _with(\%with, $impl_pkg, @_) };
    return;
}

sub _with {
    my ($WITH, $impl_pkg, undef, @p) = @_;
    my %with;
    if (@p >= 2 && $p[0] eq 'WITH' && ref $p[1] eq 'HASH') {
        shift @p;
        %with = %{ shift @p };
    }

    for my $k (keys %with) {
        if (!exists $WITH->{$k}) {
            delete $with{$k};
            carp "constant unknown: '$k'";
        }
    }
    if (_is_loaded($impl_pkg)) {
        while (my ($n, $v) = each %with) {
            if ($WITH->{$n} ne $v) {
                croak "constant conflict: can't change '$n' from '$WITH->{$n}' to '$v'";
            }
        }
    }
    else {
        for my $k (keys %with) {
            $WITH->{$k} = $with{$k};
        }
        while (my ($n, $v) = each %{ $WITH }) {
            no strict 'refs';
            *{"${impl_pkg}::$n"} = sub () { $v };
        }
        my $impl_file = _pkg2file($impl_pkg);
        require $impl_file;
    }
    no strict 'refs';
    my $import = $impl_pkg->can('import');
    if ($import) {
        local $Exporter::ExportLevel = 1 + 2;   # Exporter fucked Sub::Uplevel
        uplevel 2, $import, ($impl_pkg, @p);
    }
    return;
}

sub _pkg2file {
    my ($s) = @_;
    $s =~ s{::}{/}xmsg;
    $s .= '.pm';
    return $s;
}

sub _is_loaded {
    my ($pkg) = @_;
    my $file = _pkg2file($pkg);
    return exists $INC{$file};
}


1; # Magic true value required at end of module
__END__

=head1 NAME

WITH - Configure inlined constants when loading module


=head1 VERSION

This document describes WITH version 0.0.2


=head1 SYNOPSIS

    package main;
    use Some::Module WITH => { DEBUG => 1, VERBOSE => 0 }, qw(sub1 sub2);

    package Some::Module;
    use WITH DEBUG => 0, VERBOSE => 2;

    package Some::Module::impl;
    sub sub1 {
        DEBUG() && print Data::Dumper($x);
    }
    sub sub2 {
        if (VERBOSE() > 1) {
            print "some info\n";
        }
    }

=head1 DESCRIPTION

Quote from L<constant> module documentation:

=over 4

When a constant is used in an expression, Perl replaces it with its
value at compile time, and may then optimize the expression further.
In particular, any code in an "if (CONSTANT)" block will be optimized
away if the constant is false.

=back

The problem with such optimizations is requirement to define constants at
compile-time - if you wish to switch on/off constant DEBUG() then you should
either:

=over 4

=item -

edit module source

=item -

use environment variable for defining constants in module:

 use constant DEBUG => $ENV{PERL_SOME_MODULE_DEBUG};

and if you'll want to set value for it from perl code:

 BEGIN {
    $ENV{PERL_SOME_MODULE_DEBUG} = 1;
 }
 use Some::Module;

=back

No ease, eh? WITH will make it ease!

WITH solve this issue by delaying module loading until user will configure
module constants.


=head1 INTERFACE 

When some module want to use WITH it should:

1. Move module implementation from main module package to ::impl subpackage,
stored in separate (IMPORTANT!) file.

2. Replace contents of main module package with C<use WITH ...> stub
defining all constants which should be controlled by user at compile time.

Example. Imagine you've this module:

 # file: Some/Module.pm
 package Some::Module;
 use warnings;
 use strict;
 use Perl6::Export::Attrs;
 use constant DEBUG => 0;
 sub doit :Export {
    DEBUG && print "In doit()\n";
    print "Doing it now!\n";
 }
 1;

To give ability to user of your module to control DEBUG constant you should
change your module in this way:

 # file: Some/Module/impl.pm            # file name changed
 package Some::Module::impl;            # package changed
 use warnings;
 use strict;
 use Perl6::Export::Attrs;
 sub DEBUG ();                          # make strict happy
 sub doit :Export {
    DEBUG && print "In doit()\n";
    print "Doing it now!\n";
 }
 1;

 # file: Some/Module.pm
 package Some::Module;
 use warnings;
 use strict;
 use WITH DEBUG => 0;
 1;

Now user can load your module using in C<use> statement special C<WITH>
parameter, which must be first parameter if it exists:

 # file: some user's script
 use Some::Module WITH => { DEBUG => 1 };
 # -*- or -*-
 use Some::Module WITH => { DEBUG => 1 }, qw( doit );
 # -*- or -*-
 use Some::Module WITH => { DEBUG => 1 };
 use Some::Module qw( doit );
 # -*- or just -*-
 use Some::Module qw( doit );

The first C<use> statement will load this module and
B<remember values for constants used while loading it>.
Any attempt to C<use> module again with C<WITH =E<gt>> will check constant
values and if they're different from ones used while loading module it will
croak.


=head1 DIAGNOSTICS

=over

=item (WARNING) C<< constant unknown: '%s' >>

User tried to load module using constants in C<WITH =E<gt>> which wasn't
listed in module's C<use WITH ...> line.

=item C<< constant conflict: can't change '%s' from '%s' to '%s' >>

Module already was loaded using different value for this constant.

=back


=head1 CONFIGURATION AND ENVIRONMENT

WITH requires no configuration files or environment variables.

=head1 DEPENDENCIES

Sub::Uplevel

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-with@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Alex Efros  C<< <powerman-asdf@ya.ru> >>


=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008, Alex Efros C<< <powerman-asdf@ya.ru> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
