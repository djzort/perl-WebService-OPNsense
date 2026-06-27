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
    my $uri = $self->_path('reconfigureGeneral');

    return $self->client->post($uri);
}

sub dnsbl {
    my ($self) = @_;
    my $uri = $self->_path('dnsbl');

    return $self->client->post($uri);
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $unbound_service = $opn->unbound_service;

    my $status = $unbound_service->status;

=head1 DESCRIPTION

Unbound DNS service control.

=head1 METHODS

=head2 status

    my $status = $unbound_service->status;

Returns Unbound service status.

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

=head2 client

    my $http_client = $unbound_service->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::Service>

=cut
