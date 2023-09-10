package FTF::Controller::System;

=pod

=head1 DESCRIPTION

FTF::Controller::System is the system controller for the Food Truck Finder application.  It implements route handler methods for the system level routes.

=cut


use strictures 2;
use 5.020;

use parent 'FTF::Controller';


# VERSION


=method retrieve_index

Route handler method for the system index

Accepts: An instance of the controller
Returns: Response data

=cut

sub retrieve_index {
    my ( $self ) = @_;
    my $type = $self->req->param( 'type' );
    my $start = $self->req->param( 'start' );
    my $range = $self->req->param( 'range' );
    my $active = $self->req->param( 'active' );

    my %data = ();

    return $self->ok( \%data );
}


=method default

Default route handler method

Accepts: An instance of the controller
Returns: response data

=cut

sub default {
    my ( $self ) = @_;

    my $path = $self->req->url->path();

    return $self->not_found( $path );
}


1;

# ABSTRACT: System controller for the Food Truck Finder project
