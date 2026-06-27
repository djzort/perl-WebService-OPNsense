#!/bin/false
# ABSTRACT: IPsec Security Association Database (SAD) controller
# PODNAME: WebService::OPNsense::IPsec::Sad
use strictures 2;

package WebService::OPNsense::IPsec::Sad;

use Carp              qw( croak );
use Moo;
use namespace::clean;      # must be last

has client => ( is => 'ro', required => 1 );

sub _require_id {
    my ( $self, $id ) = @_;
    if ( !defined($id) || !length($id) ) {
        croak 'SAD entry ID is required';
    }
    return $id;
}

sub search {
    my ( $self, %params ) = @_;
    return $self->client->get( '/api/ipsec/sad/search', \%params );
}

sub delete_entry {
    my ( $self, $id ) = @_;
    $self->_require_id($id);
    return $self->client->post("/api/ipsec/sad/delete/$id");
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $sad = $opn->ipsec_sad;

    my $entries = $sad->search;
    $sad->delete_entry($id);

=head1 DESCRIPTION

Queries and manages the IPsec Security Association
Database (SAD).

=head1 METHODS

=head2 search

    my $results = $sad->search(%params);

Searches for SAD entries.

=head2 delete_entry

    my $result = $sad->delete_entry($id);

Deletes a SAD entry by ID.

=head2 client

    my $http_client = $sad->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense>

=cut
