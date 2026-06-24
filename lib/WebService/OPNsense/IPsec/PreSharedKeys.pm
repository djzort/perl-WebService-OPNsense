#!/bin/false
# ABSTRACT: IPsec pre-shared key controller
# PODNAME: WebService::OPNsense::IPsec::PreSharedKeys
use strictures 2;

package WebService::OPNsense::IPsec::PreSharedKeys;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/ipsec/pre_shared_keys';
}

with 'WebService::OPNsense::Role::ItemCrud';

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

=head1 NAME

WebService::OPNsense::IPsec::PreSharedKeys - IPsec pre-shared key controller

=head1 SYNOPSIS

    my $psk = $opn->ipsec_pre_shared_keys;

    my $items = $psk->search_item;
    $psk->add_item({ ... });

=head1 DESCRIPTION

Manages IPsec pre-shared keys.

=head1 METHODS

=head2 get

    my $config = $psk->get;

Returns the pre-shared key configuration.

=head2 set_settings

    my $result = $psk->set_settings($settings_data);

Sets the pre-shared key configuration.

=for Pod::Coverage _api_path _path client search_item get_item add_item set_item del_item

=cut
