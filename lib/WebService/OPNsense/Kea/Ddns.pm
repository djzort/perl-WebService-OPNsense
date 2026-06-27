#!/bin/false
# ABSTRACT: Kea DDNS controller
# PODNAME: WebService::OPNsense::Kea::Ddns
use strictures 2;

package WebService::OPNsense::Kea::Ddns;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/kea/ddns';
}

with 'WebService::OPNsense::Role::Settings';

1;

__END__

=pod

=head1 SYNOPSIS

    my $ddns = $opn->kea_ddns;

    my $config = $ddns->get;

    $ddns->set_settings({ ... });

=head1 DESCRIPTION

Manages Kea DDNS configuration.

=head1 METHODS

=head2 get_settings

    my $config = $ddns->get_settings;

Returns the full Kea DDNS configuration.

=head2 set_settings

    my $result = $ddns->set_settings($config_data);

Updates the Kea DDNS configuration.

=head2 client

    my $http_client = $ddns->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::Settings>

=cut
