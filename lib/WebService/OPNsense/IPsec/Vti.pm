#!/bin/false
# ABSTRACT: IPsec VTI (Virtual Tunnel Interface) controller
# PODNAME: WebService::OPNsense::IPsec::Vti
use strictures 2;

package WebService::OPNsense::IPsec::Vti;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/ipsec/vti';
}

with 'WebService::OPNsense::Role::Crud';

1;

__END__

=pod

=head1 SYNOPSIS

    my $vti = $opn->ipsec_vti;

    my $results = $vti->search;
    $vti->add({ vti => { ... } });

=head1 DESCRIPTION

IPsec Virtual Tunnel Interfaces.

=head1 PROVIDED METHODS

The following methods are inherited from consumed roles.

=head2 search

    my $results = $ctrl->search( %params );

Searches for VTI entries.

=head2 get

    my $vti = $ctrl->get( $uuid );

Returns a single VTI entry by UUID.  Throws if C<$uuid> is not a valid UUID.

=head2 set

    my $result = $ctrl->set( $uuid, $vti_data );

Updates VTI entry by UUID.  Throws if C<$uuid> is not a valid UUID.

=head2 add

    my $result = $ctrl->add( $vti_data );

Creates VTI entry.

=head2 del

    my $result = $ctrl->del( $uuid );

Deletes a VTI entry by UUID.  Throws if C<$uuid> is not a valid UUID.

=head2 toggle

    my $result = $ctrl->toggle( $uuid, $enabled );

Enables or disables a VTI entry.  Throws if C<$uuid> is not a valid UUID.

=head2 client

    my $http_client = $ctrl->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::Crud>

=cut
