#!/bin/false
# ABSTRACT: Dnsmasq service controller
# PODNAME: WebService::OPNsense::Dnsmasq::Service
use strictures 2;

package WebService::OPNsense::Dnsmasq::Service;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/dnsmasq/service';
}

with 'WebService::OPNsense::Role::Service';

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::Dnsmasq::Service - Dnsmasq service controller

=head1 SYNOPSIS

    my $service = $opn->dnsmasq_service;

    $service->status;
    $service->restart;
    $service->reconfigure;

=head1 DESCRIPTION

Controls the Dnsmasq service.

=head1 METHODS

=head2 status

    my $status = $service->status;

Returns the current service status.

=head2 start

    my $result = $service->start;

Starts the Dnsmasq service.

=head2 stop

    my $result = $service->stop;

Stops the Dnsmasq service.

=head2 restart

    my $result = $service->restart;

Restarts the Dnsmasq service.

=head2 reconfigure

    my $result = $service->reconfigure;

Reconfigures the Dnsmasq service.

=for Pod::Coverage _api_path _path client status start stop restart reconfigure

=cut
