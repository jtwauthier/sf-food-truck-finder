package FTF::Controller::System;

=pod

=head1 DESCRIPTION

FTF::Controller::System is the system controller for the Food Truck Finder application.  It implements route handler methods for the system level routes.

=head1 TO-DOS

=over 4

=item Add input validation and more comprehensive error handling

=item Add additional filter options

=item explore the data source API to see if distance is an option (This would require live requests to the API)  Alternately, the app could make requests to the Google APIs.

=item Move database queries into a separate module.

=item integrate the app with yelp or some other type of system so that customer reviews can be included in the output.

=back

=cut


use strictures 2;
use 5.020;

use parent 'FTF::Controller';

use Try::Tiny;

use SQL::Abstract::Limit;


# VERSION


=method retrieve_index

Route handler method for the system index

Accepts: An instance of the controller
Returns: Response data

=cut

sub retrieve_index {
    my ( $self ) = @_;

    my $keywords = $self->req->param( 'keywords' ) // '';
    my $size = $self->req->param( 'size' ) // '';

    my %conditions = (
        facility_type => 'Truck',
        status => { '!=' => 'EXPIRED' },
    );

    if ( $keywords ne '' ) {
        $conditions{applicant} = [];
        $conditions{food_items} = [];

        foreach my $token ( split /,/, $keywords ) {
            push @{ $conditions{applicant} }, { like => "\%$token%" };
            push @{ $conditions{food_items} }, { like => "\%$token%" };
        }
    }

    my @args = ( 'vendors', '*', \%conditions, undef );

    if ( $size ne '' ) {
        push @args, $size;
    }

    my $engine = SQL::Abstract::Limit->new( limit_dialect => $self->db() );
    my ( $query, @params ) = $engine->select( @args );

    $self->log->info( sprintf( "Searching for vendors using filters: keywords=%s size=%s\n%s", $keywords, $size, $query ) );

    my $results = {};

    try {
        $results = $self->db->selectall_hashref( $query, 'object_id', undef, @params );

        $results //= {};
    }
    catch {
        my $error = $_;

        $self->log->error( sprintf( 'The request failed: %s', $error ) );
    };

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
