#!/bin/false
# ABSTRACT: IPsec Security Association Database (SAD) controller
# PODNAME: WebService::OPNsense::IPsec::Sad
use strictures 2;

package WebService::OPNsense::IPsec::Sad;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub search {
    my ( $self, %params ) = @_;
    return $self->client->get( '/api/ipsec/sad/search', \%params );
}

sub delete_entry {
    my ( $self, $id ) = @_;
    return $self->client->post("/api/ipsec/sad/delete/$id");
}

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::IPsec::Sad - IPsec Security Association Database (SAD) controller

=head1 SYNOPSIS

    my $sad = $opn->ipsec_sad;

    my $entries = $sad->search;
    $sad->delete($id);

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

=for Pod::Coverage client

=cut
