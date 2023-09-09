package FTF::Controller::System;

=pod

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

    my $path = '';

    return $self->not_found( $path );
}


1;

# ABSTRACT: System controller for the Food Truck Finder project
