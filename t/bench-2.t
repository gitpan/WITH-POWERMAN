use warnings;
use strict;
use Test::More tests => 7;
use Time::HiRes qw( time );
use lib 't';

use X::Fast WITH => { DEBUG => 1 };
use X::Slow;
$X::Slow::DEBUG = 1;

can_ok('X::Slow', 'worker');
can_ok('X::Fast', 'worker');

my $n = 1_000;
my $t;
do {
    $t = time();
    $n *= 2;
    for (1 .. $n) { $_ *= 2 }
} while time()-$t < 1;

my $t0 = time();
my ($sum1, $debug1) = X::Slow::worker($n);
my $t1 = time() - $t0;
ok($sum1 > 0);
ok($debug1 == $sum1);

$t0 = time();
my ($sum2, $debug2) = X::Fast::worker($n);
my $t2 = time() - $t0;
ok($sum2 == $sum1);
ok($debug2 == $debug1);

cmp_ok($t2, '<', $t1, 'we are faster with DEBUG');
diag sprintf "we are faster with DEBUG for %.2f%%", 100-$t2/($t1/100);

