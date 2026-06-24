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

=head1 NAME

WebService::OPNsense::IPsec::Settings - IPsec settings controller

=head1 SYNOPSIS

    my $settings = $opn->ipsec_settings;

    my $config = $settings->get;
    $settings->set_settings({ ipsec => { ... } });

=head1 DESCRIPTION

Reads and writes IPsec settings

=head1 METHODS

=head2 get

    my $config = $settings->get;

Returns the current IPsec settings.

=head2 set_settings

    my $result = $settings->set_settings($settings_data);

Updates the IPsec settings.

=for Pod::Coverage client

=cut
