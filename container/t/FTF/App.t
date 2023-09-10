#!/usr/bin/env perl

=pod

=head1 SYNOPSIS

    # To run all tests
    prove -lv t/FTF/app.t

    # To run a single test
    T2_WORKFLOW=test_whatever prove -lv t/FTF/app.t

=head1 DESCRIPTION

t/FTF/app.t is a integration test for the Food Truck Finder application.

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

head2 test_default_route

Tests the default route

=cut

tests test_default_route => sub {
    plan 4;

    $client->get_ok( '/' );
    $client->status_is( 200 );
    $client->json_is( '/success' => 1 );
    $client->json_is( '/result' => {} );
};


done_testing;