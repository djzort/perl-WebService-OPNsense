#!/bin/false
# ABSTRACT: Captive portal session controller
# PODNAME: WebService::OPNsense::CaptivePortal::Session
use strictures 2;

package WebService::OPNsense::CaptivePortal::Session;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/captiveportal/session';
}

with 'WebService::OPNsense::Role::APIPath';

sub zones {
    my ($self) = @_;
    my $uri = $self->_path('zones');
    return $self->client->get($uri);
}

sub search {
    my ( $self, %params ) = @_;
    my $uri = $self->_path('search');
    return $self->client->get( $uri, \%params );
}

sub list {
    my ( $self, $zoneid ) = @_;
    my $uri = $self->_path( 'list{/zoneid}', zoneid => $zoneid );
    return $self->client->get($uri);
}

sub create_session {
    my ( $self, $session_data ) = @_;
    my $uri = $self->_path('connect');
    return $self->client->post( $uri, $session_data );
}

sub disconnect_session {
    my ( $self, $session_data ) = @_;
    my $uri = $self->_path('disconnect');
    return $self->client->post( $uri, $session_data );
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $cp_session = $opn->captiveportal_session;

    my $zones = $cp_session->zones;

=head1 DESCRIPTION

Manages captive portal sessions.

=head1 METHODS

=head2 zones

    my $zones = $cp_session->zones;

Returns a list of captive portal zones.

=head2 search

    my $sessions = $cp_session->search(%params);

Searches for captive portal sessions.

=head2 list

    my $sessions = $cp_session->list;
    my $sessions = $cp_session->list($zoneid);

Lists active sessions.  Optionally filtered by zone ID.

=head2 create_session

    my $result = $cp_session->create_session($session_data);

Creates captive portal session.

=head2 disconnect_session

    my $result = $cp_session->disconnect_session($session_data);

Disconnects an active session.

=head2 client

    my $http_client = $cp_session->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::APIPath>

=cut
