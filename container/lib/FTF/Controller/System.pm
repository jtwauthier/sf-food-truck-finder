package FTF::Controller::System;

=pod

=head1 DESCRIPTION

FTF::Controller::System is the system controller for the Food Truck Finder application.  It implements route handler methods for the system level routes.

=head1 TO-DOS

=over 4

=item Add input validation and more comprehensive error handling

=item Add additional filter options

=item explore the data source API to see if distance is an option (This would require live requests to the API)

=item Move database queries into a separate module.  It would be ideal to switch to using either SQL::Abstract or DBIC.  Although, DBIC may be overkill for such a light weight application.

=item integrate the app with yelp or some other type of system so that customer reviews can be included in the output.

=back

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

    my $foods = $self->req->param( 'foods' ) // '';
    my $size = $self->req->param( 'size' ) // '';

    my $query = 'select * from vendors where facility_type = ? and status != ?';
    my @params = ( 'Truck', 'EXPIRED' );

    if ( $foods ne '' ) {
        foreach my $food ( split /,/, $foods ) {
            $query .= ' and food_items like ?';

            push @params, "\%$food%";
        }
    }

    if ( $size ne '' ) {
        $query .= ' limit ?';

        push @params, $size;
    }

    $self->log->info( sprintf( "Searching for vendors using filters: foods=%s size=%s", $foods, $size ) );

    my $results = $self->db->selectall_hashref( $query, 'object_id', undef, @params );

    if ( ! defined $results ) {
        $results = {};
    }

    my $total = scalar( keys %{ $results } );

    $self->log->info( sprintf( 'Found %d vendors', $total ) );

    my %data = (
        vendors => $results,
        total => $total
    );

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
