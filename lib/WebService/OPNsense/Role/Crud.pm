#!/bin/false
# ABSTRACT: Role for plain-name CRUD methods
# PODNAME: WebService::OPNsense::Role::Crud
use strictures 2;

package WebService::OPNsense::Role::Crud;

use Moo::Role;
use WebService::OPNsense::Normalize qw( validate_uuid );
use namespace::clean;

with 'WebService::OPNsense::Role::APIPath';

sub add {
    my ( $self, $record_data ) = @_;
    return $self->client->post( $self->_path('add'), $record_data );
}

sub del {
    my ( $self, $uuid ) = @_;
    validate_uuid($uuid);
    return $self->client->post( $self->_path( 'del/{uuid}', uuid => $uuid ) );
}

sub get {
    my ( $self, $uuid ) = @_;
    validate_uuid($uuid);
    return $self->client->get( $self->_path( 'get/{uuid}', uuid => $uuid ) );
}

sub search {
    my ( $self, %params ) = @_;
    return $self->client->get( $self->_path('search'), \%params );
}

sub toggle {
    my ( $self, $uuid, $enabled ) = @_;
    validate_uuid($uuid);
    return $self->client->post(
        $self->_path( 'toggle/{uuid}{/enabled}', uuid => $uuid, enabled => $enabled ),
    );
}

1;

__END__

=pod

=for Pod::Coverage _api_path _path client add del get search toggle

=cut
