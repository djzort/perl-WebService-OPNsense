#!/bin/false
# ABSTRACT: OpenVPN client overwrites controller
# PODNAME: WebService::OPNsense::OpenVPN::ClientOverwrites
use strictures 2;

package WebService::OPNsense::OpenVPN::ClientOverwrites;

use Moo;
use WebService::OPNsense::Normalize qw( validate_uuid );
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/openvpn/client_overwrites';
}

with 'WebService::OPNsense::Role::Crud';

sub set_overwrite {
    my ( $self, $uuid, $overwrite_data ) = @_;
    validate_uuid($uuid);
    return $self->client->post( $self->_path( 'set/{uuid}', uuid => $uuid ), $overwrite_data );
}

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::OpenVPN::ClientOverwrites - OpenVPN client overwrites controller

=head1 SYNOPSIS

    my $overwrites = $opn->openvpn_client_overwrites;

    my $list = $overwrites->search(current => 1, rowCount => 50);

    $overwrites->add({
        overwrite => {
            description => 'Custom client config',
        },
    });

=head1 DESCRIPTION

Manages OpenVPN client-specific configuration overwrites.

=head1 METHODS

=head2 set_overwrite

    my $result = $overwrites->set_overwrite($uuid, $overwrite_data);

Updates an existing client overwrite.

=for Pod::Coverage _api_path _path client search get add del toggle

=cut
