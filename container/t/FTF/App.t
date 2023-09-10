#!/usr/bin/env perl

=pod

=head1 SYNOPSIS

    # To run all tests
    prove -lv t/FTF/App.t

    # To run a single test
    T2_WORKFLOW=test_whatever prove -lv t/FTF/App.t

=head1 DESCRIPTION

t/FTF/app.t is a system test for the Food Truck Finder application.

=head1 TO-DOS

=over 4

=item Add more comprehensive tests

=back

=cut


use strictures 2;
use 5.020;

use FindBin;

use lib "$FindBin::RealBin/../../lib";

use Test2::V0;
use Test2::MojoX;

use Test2::Tools::Spec;
use Test2::Tools::Target 'FTF::App';


my $client = Test2::MojoX->new( $CLASS );


=head1 TESTS

head2 test_retrieve_index_route

Tests the index route

=cut

tests test_retrieve_index_route => sub {
    plan 4;

    $client->get_ok( '/?size=1&foods=taco' );
    $client->status_is( 200 );
    $client->json_is( '/success' => 1 );

    $client->json_is( '/result/total' => 1 );
};


=head2 test_default_route

Tests the default route

=cut

tests test_default_route => sub {
    plan 4;

    my %error = (
        message => 'The requested operation could not be completed.',
        reason => 'The specified resource, /blah, is currently unavailable.'
    );

    $client->get_ok( '/blah' );
    $client->status_is( 404 );
    $client->json_is( '/success' => 0 );
    $client->json_is( '/error' => \%error );
};


done_testing;
