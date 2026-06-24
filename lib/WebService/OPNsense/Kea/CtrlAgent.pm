#!/bin/false
# ABSTRACT: Kea control agent controller
# PODNAME: WebService::OPNsense::Kea::CtrlAgent
use strictures 2;

package WebService::OPNsense::Kea::CtrlAgent;

use Moo;
use namespace::clean;

has client => ( is => 'ro', required => 1 );

sub _api_path {
    return '/api/kea/ctrl_agent';
}

with 'WebService::OPNsense::Role::Settings';

1;

__END__

=pod

=head1 NAME

WebService::OPNsense::Kea::CtrlAgent - Kea control agent controller

=head1 SYNOPSIS

    my $ctrl_agent = $opn->kea_ctrl_agent;

    my $config = $ctrl_agent->get;

    $ctrl_agent->set({ ... });

=head1 DESCRIPTION

Kea control agent configuration.

=head1 METHODS

=head2 get

    my $config = $ctrl_agent->get;

Returns the full Kea control agent configuration.

=head2 set_settings

    my $result = $ctrl_agent->set_settings($config_data);

Updates the Kea control agent configuration.

=for Pod::Coverage client

=cut
