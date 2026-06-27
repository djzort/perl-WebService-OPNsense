#!/bin/false
# ABSTRACT: IPsec settings controller
# PODNAME: WebService::OPNsense::IPsec::Settings
use strictures 2;

package WebService::OPNsense::IPsec::Settings;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/ipsec/settings';
}

with 'WebService::OPNsense::Role::Settings';

1;

__END__

=pod

=head1 SYNOPSIS

    my $settings = $opn->ipsec_settings;

    my $config = $settings->get_settings;
    $settings->set_settings({ ipsec => { ... } });

=head1 DESCRIPTION

Reads and writes IPsec settings

=head1 METHODS

=head2 get_settings

    my $config = $settings->get_settings;

Returns IPsec settings.

=head2 set_settings

    my $result = $settings->set_settings($settings_data);

Updates the IPsec settings.

=head2 client

    my $http_client = $settings->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::Settings>

=cut
