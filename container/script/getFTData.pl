#!/usr/bin/env perl

=pod

=head1 SYNOPSIS

    /opt/app/script/getFTData.pl

=head1 DESCRIPTION

getFTData.pl retrieves food truck data from the sfgov.org website and saves it to a file on the local filesystem for quicker access for the Food Truck Finder application.

=head1 TO-DOs

=over 4

=item Create a cron job to refresh this data periodically.

=item use the local copy of the data to load data into the database instead of pulling from the remote server each time.

=item Move the URL to the config file.

=item use SQL::Abstract to build the insert query.

=back

=cut


use strictures 2;
use 5.020;

use DBI;
use FindBin;
use JSON;

use Config::Merge;
use Data::Dump;
use File::Spec;
use HTTP::Tiny;
use Try::Tiny;


my $url = 'https://data.sfgov.org/resource/rqzj-sfat.json';
my $browser = HTTP::Tiny->new();
my $response = $browser->get( $url );
my $data = [];

try {
    # We parse the content to make sure it is valid json
    $data = decode_json( $response->{content} );

    # Convert the data back to JSON and write it to a file
    my $filename = File::Spec->catfile( $FindBin::RealBin, '..', 'data', 'FTData.json' );

    open( my $fh, '>', $filename );

    # We might want to pretty print or do some other formatting/translations here
    print $fh encode_json( $data ) . "\n";

    close( $fh );

    say 'The data was retrieved successfully.';

    save_to_db( $data );
}
catch {
    say "The data was not retrieved successfully: $_";
};


sub save_to_db {
    my ( $entries ) = @_;

    my @fields = qw(
        object_id applicant lot block block_lot facility_type
        received expiration_date permit prior_permit status cnn schedule
        days_hours food_items address location_description latitude longitude
        x y
    );

    my %mapping = (
        object_id => 'objectid',
        facility_type => 'facilitytype',
        expiration_date => 'expirationdate',
        prior_permit => 'priorpermit',
        block_lot => 'blocklot',
        food_items => 'fooditems',
        days_hours => 'dayshours',
        location_description => 'locationdescription',
    );

    my $query = 'insert into vendors (';

    $query .= join( ', ', @fields );
    $query .= ') values ';

    my @values = ();
    my @clauses = ();

    foreach my $entry ( @{ $entries } ) {
        my $clause = '(';
        my @params = ();

        foreach my $field ( @fields ) {
            my $key = $mapping{$field} // $field;
            my $value = $entry->{$key} // '';

            push @params, "?";
            push @values, $value;
        }

        $clause .= join( ', ', @params );
        $clause .= ')';

        push @clauses, $clause;
    }

    $query .= join( ', ', @clauses );

    try {
        my $dir = File::Spec->catdir( $FindBin::RealBin, '..', 'conf' );
        my $config = Config::Merge->new( $dir )->( 'ftf' );
        my $dsn = $config->{database}->{dsn};
        my $dbh = DBI->connect( $dsn );

        if ( scalar @{ $entries } > 0 ) {
            $dbh->do( $query, undef, @values );

            say 'Data written to the database successfully.';
        }

        $dbh->disconnect();
    }
    catch {
        say "the data was not written to the database successfully: $_";
    };

    return $query;
}

