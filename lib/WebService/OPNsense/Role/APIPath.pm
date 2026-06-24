#!/bin/false
# ABSTRACT: Role providing _path helper for URI::Template URL construction
# PODNAME: WebService::OPNsense::Role::APIPath
use strictures 2;

package WebService::OPNsense::Role::APIPath;

use Moo::Role;
use namespace::clean;

requires 'client';
requires '_api_path';

sub _path {
    my ( $self, $endpoint, %vars ) = @_;
    require URI::Template;
    my $api_path = $self->_api_path;
    my $uri      = "$api_path/$endpoint";
    return URI::Template->new($uri)->process( \%vars );
}

1;

__END__

=pod

=for Pod::Coverage _api_path _path client

=cut
