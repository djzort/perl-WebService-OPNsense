#!/bin/false
# ABSTRACT: Role for service control methods (status/start/stop/restart/reconfigure)
# PODNAME: WebService::OPNsense::Role::Service
use strictures 2;

package WebService::OPNsense::Role::Service;

use Moo::Role;
use namespace::clean;

with 'WebService::OPNsense::Role::APIPath';

sub reconfigure {
    my ($self) = @_;
    return $self->client->post( $self->_path('reconfigure') );
}

sub restart {
    my ($self) = @_;
    return $self->client->post( $self->_path('restart') );
}

sub start {
    my ($self) = @_;
    return $self->client->post( $self->_path('start') );
}

sub status {
    my ($self) = @_;
    return $self->client->get( $self->_path('status') );
}

sub stop {
    my ($self) = @_;
    return $self->client->post( $self->_path('stop') );
}

1;

__END__

=pod

=for Pod::Coverage _api_path _path client reconfigure restart start status stop

=cut
