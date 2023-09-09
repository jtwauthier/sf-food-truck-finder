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

use Test2::V0;

