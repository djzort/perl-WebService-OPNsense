#!/bin/false
# ABSTRACT: Role for settings get/set methods
# PODNAME: WebService::OPNsense::Role::Settings
use strictures 2;

package WebService::OPNsense::Role::Settings;

use Moo::Role;
use namespace::clean;

with 'WebService::OPNsense::Role::APIPath';

sub get {
    my ($self) = @_;
    return $self->client->get( $self->_path('get') );
}

sub set_settings {
    my ( $self, $settings_data ) = @_;
    return $self->client->post( $self->_path('set'), $settings_data );
}

1;

__END__

=pod

=for Pod::Coverage _api_path _path client get set_settings

=cut
