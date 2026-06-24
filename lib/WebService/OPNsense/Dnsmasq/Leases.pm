#!/bin/false
# ABSTRACT: Dnsmasq leases controller
# PODNAME: WebService::OPNsense::Dnsmasq::Leases
use strictures 2;

package WebService::OPNsense::Dnsmasq::Leases;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub search {
    my ( $self, %params ) = @_;
    return $self->client->get( '/api/dnsmasq/leases/search', \%params );
}

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::Dnsmasq::Leases - Dnsmasq leases controller

=head1 SYNOPSIS

    my $leases = $opn->dnsmasq_leases;

    my $results = $leases->search(current => 1, rowCount => 50);

=head1 DESCRIPTION

Queries Dnsmasq DHCP leases.

=head1 METHODS

=head2 search

    my $results = $leases->search(%params);

Searches for DHCP leases.  Parameters: C<current>, C<rowCount>, C<searchPhrase>.

=for Pod::Coverage client

=cut
