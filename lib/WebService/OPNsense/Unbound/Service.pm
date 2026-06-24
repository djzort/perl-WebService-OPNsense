#!/bin/false
# ABSTRACT: Unbound service controller
# PODNAME: WebService::OPNsense::Unbound::Service
use strictures 2;

package WebService::OPNsense::Unbound::Service;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/unbound/service';
}

with 'WebService::OPNsense::Role::Service';

sub reconfigure_general {
    my ($self) = @_;
    return $self->client->post( $self->_path('reconfigureGeneral') );
}

sub dnsbl {
    my ($self) = @_;
    return $self->client->post( $self->_path('dnsbl') );
}

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::Unbound::Service - Unbound service controller

=head1 SYNOPSIS

    my $unbound_service = $opn->unbound_service;

    my $status = $unbound_service->status;

=head1 DESCRIPTION

Unbound DNS service control.

=head1 METHODS

=head2 status

    my $status = $unbound_service->status;

Returns the current Unbound service status.

=head2 start

    my $result = $unbound_service->start;

Starts the Unbound service.

=head2 stop

    my $result = $unbound_service->stop;

Stops the Unbound service.

=head2 restart

    my $result = $unbound_service->restart;

Restarts the Unbound service.

=head2 reconfigure

    my $result = $unbound_service->reconfigure;

Reconfigures the Unbound service.

=head2 reconfigure_general

    my $result = $unbound_service->reconfigure_general;

Reconfigures general Unbound settings.

=head2 dnsbl

    my $result = $unbound_service->dnsbl;

Updates the DNSBL configuration.

=for Pod::Coverage _api_path _path client status start stop restart reconfigure

=cut
