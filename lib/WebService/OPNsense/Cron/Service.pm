#!/bin/false
# ABSTRACT: Cron service controller
# PODNAME: WebService::OPNsense::Cron::Service
use strictures 2;

package WebService::OPNsense::Cron::Service;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/cron/service';
}

with 'WebService::OPNsense::Role::APIPath';

sub reconfigure {
    my ($self) = @_;
    my $uri = $self->_path('reconfigure');
    return $self->client->post($uri);
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $cron_service = $opn->cron_service;

    $cron_service->reconfigure;

=head1 DESCRIPTION

Controls the cron service.

=head1 METHODS

=head2 reconfigure

    my $result = $cron_service->reconfigure;

Reconfigures the cron service.

=head2 client

    my $http_client = $cron_service->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::APIPath>

=cut
