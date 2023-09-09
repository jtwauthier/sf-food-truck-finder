package FTF::Hook;


=pod

=head1 DESCRIPTION

FTF::Hook is a module which provides utility functions to be used in Food Truck Finder application hooks.  the functionality in these hooks modify the request and response data.

=cut


use strictures 2;
use 5.020;


# VERSION


=method before_dispatch

Runs before the request is dispatched to the route handler.  We use this to add information to the stash so that it is available to all controller methods.

Accepts: An instance of the controller which is handling the current request
Returns: Nothing

=cut

sub before_dispatch {
    my ( $c ) = @_;

    my $env = $c->req->env();

    # We would typically use this information to customize the user experience. We could also collect data about the user's session, browser, etc
    # This is also a good place to put geo IP lookups and such
    my %data = (
        ip => $env->{REMOTE_ADDR}
    );

    $c->stash( %data );

    return;
}


=method after_render

Runs after the response data has been rendered but before it has been sent back to the web client.  We are going to use it to modify the rendered data.

Accepts: An instance of the controller which is handling the current request, a reference to the output string, and a string representing the format
Returns: Nothing

=cut

sub after_render {
    my ( $c, $o ) = @_;

    # Add a newline to the end of the output.
    # We could set up some logic to pretty print the response here.
    $$o .= "\n";

    return;
}


1;

# ABSTRACT: Application hook class for the Food Truck Finder project
