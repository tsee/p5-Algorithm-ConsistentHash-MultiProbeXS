package Algorithm::ConsistentHash::MultiProbeXS;
use strict;
use warnings;
use XSLoader;

our $VERSION = '0.01';

XSLoader::load('Algorithm::ConsistentHash::MultiProbeXS', $VERSION);

1;
__END__

=head1 NAME

Algorithm::ConsistentHash::MultiProbeXS - Multi-probe consistent hashing

=head1 SYNOPSIS

  use Algorithm::ConsistentHash::MultiProbeXS;
  
  my $buckets = [ map { "shard-$_" } 1..6000 ];
  my $mp = Algorithm::ConsistentHash::MultiProbeXS->new($buckets, 21, 1, 2);
  my $shard = $mpc->lookup($key);

=head1 DESCRIPTION

This module implements the multi-probe consistent hash algorithm as described in

L<http://arxiv.org/pdf/1505.00062.pdf>

The paper's abstract states:

I<We describe a consistent hashing algorithm which performs multiple lookups per key in a hash table of nodes. It requires no additional storage beyond the hash table, and achieves a peak-to-average load ratio of 1 + epsilon with just 1 + 1/epsilon lookups per key.>

The current implementation draws from L<https://github.com/dgryski/libmpchash>.
At this moment, it uses a non-optimal data structure, but the performance impact
of that is negligible at any scale but the extremes (like Google's).

This implementation uses the SipHash hash function, see below for a link.

=head1 METHODS

=head2 new

Class method that constructs a new MultiProbeXS consistent hasher object.

Takes four parameters:

=over 2

=item *

An anonymous array containing the bucket (shard) names.

=item *

The number of probes to perform. Higher number means better distribution of data among
the buckets. But also slightly more expensive lookups. See paper for better explanation.

=item *

Two (different) integers as seeds for the two siphash iterations.

=back

=head2 lookup

Instance method that, given a key as parameter, will compute and return the bucket (shard) that
the key falls into.

=head1 CAVEATS

Uses 64bit integers. Likely not to work on strictly 32bit architectures.

=head1 SEE ALSO

SipHash string hash function: L<http://en.wikipedia.org/wiki/SipHash>

For alternative consistent hash algorithms/implementations, search CPAN, but here's some:

L<Algorithm::ConsistentHash::JumpHash>

L<Algorithm::ConsistentHash::CHash>

L<Algorithm::ConsistentHash::Ketama>

=head1 AUTHOR

Steffen Mueller, E<lt>smueller@cpan.orgE<gt>

Damian Gryski, E<lt>damian@gryski.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Steffen Mueller
Copyright (C) 2015 by Damian Gryski

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

