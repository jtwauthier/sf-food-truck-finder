#!/usr/bin/env perl

=pod

=head1 SYNOPSIS

    /opt/app/script/getFTData.pl

=head1 DESCRIPTION

getFTData.pl retrieves food truck data from the sfgov.org website and saves it to a file on the local filesystem for quicker access for the Food Truck Finder application.

=head1 TO-DOs

=over 4

=item Create a cron job to refresh this data periodically.

=back

=cut


use strictures 2;
use 5.020;

use FindBin;
use JSON;

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
}
catch {
    say "The data was not retrieved successfully: $_";
};
