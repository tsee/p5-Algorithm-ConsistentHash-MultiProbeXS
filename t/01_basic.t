#!perl
use strict;
use warnings;

use Test::Simple tests => 6000;
use Algorithm::ConsistentHash::MultiProbeXS;
use FindBin qw($Bin);

my $buckets = [ map { "shard-$_" } 1..6000 ];

my $mpc = Algorithm::ConsistentHash::MultiProbeXS->new($buckets, [1, 2], 21);

my @compat = split /\n/, do { local(@ARGV, $/) = "$Bin/testdata/compat.out"; <> };

for (my $i=0; $i < @compat; $i++) {
  my $b = $buckets->[$i];
  my $got = $mpc->hash($b);
  my $want = $compat[$i];
  ok($got eq $want);
}
