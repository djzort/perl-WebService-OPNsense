#!/bin/false
# ABSTRACT: IPsec manual SPD (Security Policy Database) controller
# PODNAME: WebService::OPNsense::IPsec::ManualSpd
use strictures 2;

package WebService::OPNsense::IPsec::ManualSpd;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/ipsec/manual_spd';
}

with 'WebService::OPNsense::Role::Crud';

1;

__END__

=pod

=head1 SYNOPSIS

    my $mspd = $opn->ipsec_manual_spd;

    my $results = $mspd->search;
    $mspd->add({ spd => { ... } });

=head1 DESCRIPTION

Manages manual IPsec Security Policy Database entries.

=head1 PROVIDED METHODS

The following methods are inherited from consumed roles.

=head2 search

    my $results = $ctrl->search( %params );

Searches for manual SPD entries.

=head2 get

    my $spd = $ctrl->get( $uuid );

Returns a single manual SPD entry by UUID.  Throws if C<$uuid> is not a valid UUID.

=head2 set

    my $result = $ctrl->set( $uuid, $spd_data );

Updates manual SPD entry by UUID.  Throws if C<$uuid> is not a valid UUID.

=head2 add

    my $result = $ctrl->add( $spd_data );

Creates manual SPD entry.

=head2 del

    my $result = $ctrl->del( $uuid );

Deletes a manual SPD entry by UUID.  Throws if C<$uuid> is not a valid UUID.

=head2 toggle

    my $result = $ctrl->toggle( $uuid, $enabled );

Enables or disables a manual SPD entry.  Throws if C<$uuid> is not a valid UUID.

=head2 client

    my $http_client = $ctrl->client;

Returns the underlying HTTP client object used for API requests.

=head1 SEE ALSO

L<WebService::OPNsense::Role::Crud>

=cut
