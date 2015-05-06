
=head1 Name

qbit::Array - Functions to manipulate arrays.

=cut

package qbit::Host;

use strict;
use warnings;
use utf8;

use qbit::File qw(readfile);

use base qw(Exporter);

BEGIN {
    our (@EXPORT, @EXPORT_OK);

    @EXPORT = qw(
      memory_consumption
      hostname
      );
    @EXPORT_OK = @EXPORT;
}

=head1 Functions

=head2 memory_consumption

B<Arguments:>

=over

=item

B<$pid> - scalar, optional. The pid of the process you want to get memory consumption. The current process pid is used if not given;

=back

B<Return value:> hash ref, memory consumption of the $pid or $$. I. e. ref {vsz => ..., rss => ...}.

=cut

sub memory_consumption {
    my ($pid) = @_;

    $pid = $$ unless defined($pid);

    my ($vsz, $rss) = split(/\s+/, readfile("/proc/$pid/statm"));

    my %memory;
    my $page_size_in_kb = 4;
    @memory{qw(vsz rss)} = map {$_ * $page_size_in_kb} ($vsz, $rss);

    return \%memory;
}

=head2 hostname

B<Arguments:> No.

B<Return value:> scalar, full hostname of the server (`hostname -f`).

=cut

sub hostname {
    my $server = `hostname -f`;
    chomp($server);

    return $server;
}

1;
