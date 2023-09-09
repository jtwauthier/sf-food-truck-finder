package FTF::Controller;


=pod

=head1 DESCRIPTION

FTF::Controller is the controller base class for the Food Truck Finder application.

=head1 TO-DOS

=over 4

=item Add error handling and input validation functionality

=back

=cut


use strictures 2;
use 5.020;

use parent 'Mojolicious::Controller';


# VERSION


=method ok

Composes ok response data.  This is used when the request completed successfully.

Accepts: the data to be returned in the response
Returns: A reference to a hash which can be passed to render()

=cut

sub ok {
    my ( $self, $args ) = @_;

    my %result = ( success => 1, result => $args );
    my %data = ( status => 200, json => \%result );

    return $self->render( %data );
}


=method bad_request

Composes bad request response data.  Typically, this means that the user supplied invalid data in the request.

Accepts: A string containing a reason describing why the request was invalid
Returns: a reference to a hash that can be passed to render()

=cut

sub bad_request {
    my ( $self, $args ) = @_;

    my %result = (
        success => 0,
        error => {
            message => 'The requested operation could not be completed.',
            reason => $args
        }
    );

    my %data = ( status => 400, json => \%result );

    return \%data;
}


=method not_found

Composes not found response data.  This is used when there is no configured route matching the request.

Accepts: a string indicating the path component of the request URI
Returns: A reference to a hash which can be passed to render()

=cut

sub not_found {
    my ( $self, $args ) = @_;

    my %result = (
        success => 0,
        error => {
            message => 'The requested operation could not be completed.',
            reason => sprintf( 'The specified resource, %s, is currently unavailable.', $args )
        }
    );

    my %data = ( status => 404, json => \%result );

    return \%data;
}


=method error

Composes error response data.  This is used when the request cannot be completed due to an error.

Accepts: A string indicating the error message
Returns: A reference to a hash which can be passed to render()

=cut

sub error {
    my ( $self, $args ) = @_;

    my %result = (
        success => 0,
        error => {
            message => 'The requested operation could not be completed.',
            reason => $args
        }
    );

    my %data = ( status => 500, json => \%result );

    return \%data;
}


1;

# ABSTRACT: Controller base class for the FTF project
