#!/bin/false
# ABSTRACT: Firewall category controller
# PODNAME: WebService::OPNsense::Firewall::Category
use strictures 2;

package WebService::OPNsense::Firewall::Category;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/firewall/category';
}

with 'WebService::OPNsense::Role::ItemCrud';

sub set_category {
    my ( $self, $category_data ) = @_;
    return $self->client->post( $self->_path('set'), $category_data );
}

sub download {
    my ($self) = @_;
    return $self->client->get( $self->_path('download') );
}

sub upload {
    my ( $self, $upload_data ) = @_;
    return $self->client->post( $self->_path('upload'), $upload_data );
}

sub get {
    my ($self) = @_;
    return $self->client->get( $self->_path('get') );
}

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::Firewall::Category - Firewall category controller

=head1 SYNOPSIS

    my $category = $opn->firewall->category;

    my $results = $category->search_item;
    my $item    = $category->get_item($uuid);

=head1 DESCRIPTION

Manages firewall category items. Categories group firewall rules for
organizational purposes.

=head1 METHODS

=head2 set_category

    my $result = $category->set_category($category_data);

Sets global category settings.

=head2 download

    my $data = $category->download;

Downloads all category configuration.

=head2 upload

    my $result = $category->upload($upload_data);

Uploads category configuration.

=head2 get

    my $categories = $category->get;

Returns all category configuration.

=for Pod::Coverage _api_path _path client search_item get_item add_item set_item del_item

=cut
