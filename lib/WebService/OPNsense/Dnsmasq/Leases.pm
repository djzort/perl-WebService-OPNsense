#!/bin/false
# ABSTRACT: Dnsmasq leases controller
# PODNAME: WebService::OPNsense::Dnsmasq::Leases
use strictures 2;

package WebService::OPNsense::Dnsmasq::Leases;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/dnsmasq/leases';
}

with 'WebService::OPNsense::Role::APIPath';

sub search {
    my ( $self, %params ) = @_;
    my $uri = $self->_path('search');
    return $self->client->get( $uri, \%params );
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $leases = $opn->dnsmasq_leases;

    my $results = $leases->search(current => 1, rowCount => 50);

=head1 DESCRIPTION

Queries Dnsmasq DHCP leases.

=head1 METHODS

=head2 search

    my $results = $leases->search(%params);

Searches for DHCP leases.  Parameters: C<current>, C<rowCount>, C<searchPhrase>.

=head2 client

    my $http_client = $leases->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::APIPath>

=cut
