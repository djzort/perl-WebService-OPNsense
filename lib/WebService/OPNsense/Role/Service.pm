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
    my $uri = $self->_path('reconfigure');

    return $self->client->post($uri);
}

sub restart {
    my ($self) = @_;
    my $uri = $self->_path('restart');

    return $self->client->post($uri);
}

sub start {
    my ($self) = @_;
    my $uri = $self->_path('start');

    return $self->client->post($uri);
}

sub status {
    my ($self) = @_;
    my $uri = $self->_path('status');

    return $self->client->get($uri);
}

sub stop {
    my ($self) = @_;
    my $uri = $self->_path('stop');

    return $self->client->post($uri);
}

1;

__END__

=pod

=head1 DESCRIPTION

Provides shared service lifecycle methods (status, start, stop, restart,
reconfigure).  All methods in this section are called on the consuming
object, not on the role directly.

This role is consumed by L<WebService::OPNsense::IPsec::Service>,
L<WebService::OPNsense::CaptivePortal::Service>,
L<WebService::OPNsense::Dnsmasq::Service>,
L<WebService::OPNsense::IDS::Service>,
L<WebService::OPNsense::Kea::Service>, and
L<WebService::OPNsense::Unbound::Service>.

=head1 PROVIDED METHODS

=head2 status

    my $status = $ctrl->status;

Returns service status.

=head2 start

    my $result = $ctrl->start;

Starts the service.

=head2 stop

    my $result = $ctrl->stop;

Stops the service.

=head2 restart

    my $result = $ctrl->restart;

Restarts the service.

=head2 reconfigure

    my $result = $ctrl->reconfigure;

Reconfigures the service.

=head2 client

    my $http_client = $ctrl->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::IPsec::Service>,
L<WebService::OPNsense::CaptivePortal::Service>,
L<WebService::OPNsense::Dnsmasq::Service>,
L<WebService::OPNsense::IDS::Service>,
L<WebService::OPNsense::Kea::Service>,
L<WebService::OPNsense::Unbound::Service>

=cut
