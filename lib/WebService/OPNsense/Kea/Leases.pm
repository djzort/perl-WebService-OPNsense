#!/bin/false
# ABSTRACT: Kea leases controller
# PODNAME: WebService::OPNsense::Kea::Leases
use strictures 2;

package WebService::OPNsense::Kea::Leases;

use Moo;
use URI::Escape      qw( uri_escape_utf8 );
use namespace::clean;      # must be last

has client => ( is => 'ro', required => 1 );

sub del_lease {
    my ( $self, $ips ) = @_;
    my $path = '/api/kea/leases/delLease';
    if ( defined $ips ) {
        my $encoded = uri_escape_utf8($ips);
        $path .= "/$encoded";
    }
    return $self->client->post($path);
}

sub search {
    my ( $self, %params ) = @_;
    return $self->client->get( '/api/kea/leases/search', \%params );
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $leases = $opn->kea_leases;

    my $results = $leases->search(current => 1, rowCount => 50);

    $leases->del_lease;
    $leases->del_lease('192.0.2.10');

=head1 DESCRIPTION

Manages Kea DHCP leases.

=head1 METHODS

=head2 del_lease

    my $result = $leases->del_lease;
    my $result = $leases->del_lease($ips);

Deletes one or more leases.  C<$ips> is an optional IP address or
comma-separated list of IPs.

=head2 search

    my $results = $leases->search(%params);

Searches for DHCP leases.  Returns the raw API response hashref.

=head2 client

    my $http_client = $leases->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense>

=cut
