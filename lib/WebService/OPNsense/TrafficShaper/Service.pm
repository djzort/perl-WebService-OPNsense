#!/bin/false
# ABSTRACT: Traffic shaper service controller
# PODNAME: WebService::OPNsense::TrafficShaper::Service
use strictures 2;

package WebService::OPNsense::TrafficShaper::Service;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub reconfigure {
    my ($self) = @_;
    return $self->client->post('/api/trafficshaper/service/reconfigure');
}

sub flush_reload {
    my ($self) = @_;
    return $self->client->post('/api/trafficshaper/service/flushReload');
}

sub statistics {
    my ($self) = @_;
    return $self->client->get('/api/trafficshaper/service/statistics');
}

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::TrafficShaper::Service - Traffic shaper service controller

=head1 SYNOPSIS

    my $ts_service = $opn->trafficshaper_service;

    $ts_service->reconfigure;

=head1 DESCRIPTION

Controls the traffic shaper service

=head1 METHODS

=head2 reconfigure

    my $result = $ts_service->reconfigure;

Reconfigures the traffic shaper.

=head2 flush_reload

    my $result = $ts_service->flush_reload;

Flushes and reloads the traffic shaper configuration.

=head2 statistics

    my $stats = $ts_service->statistics;

Returns traffic shaper statistics.

=for Pod::Coverage client

=cut
