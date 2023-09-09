#!/usr/bin/env perl

=pod

=head1 SYNOPSIS

    plackup -p 3000 /opt/app/dispatch.fcgi

=head1 DESCRIPTION

This is the application startup script.  It is the entrypoint into the application.

=head1 TO-DOS

=over 4

=item Modify the cmd parameter so that the script can accept alternate commands

=back

=cut


use strictures 2;
use 5.020;

use FindBin;

use Mojolicious::Commands;

use lib "$FindBin::RealBin/lib";

use FTF::App;

my $app = 'FTF::App';
my $cmd = 'fastcgi';

Mojolicious::Commands->start_app( $app, $cmd );
