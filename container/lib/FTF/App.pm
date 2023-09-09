package FTF::App;


=pod

=head1 DESCRIPTION

FTF::App is the main application class in the Food Truck Finder project.  It is responsible for configuring, initializing, and setting up the resources that the application needs to run properly.

=cut


use strictures 2;
use 5.020;

use parent 'Mojolicious';

use JSON;

use Config::Merge;
use File::Spec;
use Try::Tiny;

use MojoX::Log::Log4perl;

use FTF::Hook;


# VERSION


=method startup

This is the method which gets called when the application starts.  we use it to call our individual configuration methods.  It doesn't accept or return any parameters.

=cut

sub startup {
    my ( $self ) = @_;

    my $dir = File::Spec->catdir( $self->home(), 'conf' );
    my $config = Config::Merge->new( $dir )->( 'ftf' );
    my $logger = MojoX::Log::Log4perl->new( $config->{logging} );

    $self->log( $logger );

    my $filename = File::Spec->catfile( $self->home(), 'data', 'FTData.json' );
    my $ft_data = $self->load_ft_data( $filename );

    $config->{ft_data} = $ft_data;

    $self->config( $config );

    $self->configure_plugins();
    $self->configure_hooks();
    $self->configure_routes();

    return;
}


=method load_ft_data

Loads food truck data from the specified file

Accepts: a string representing a filename
Returns: A reference to an array containing food truck data which was read from the specified file

=cut

sub load_ft_data {
    my ( $self, $filename ) = @_;

    local $/ = undef;

    open( my $fh, '<', $filename );

    my $content = <$fh>;

    close( $fh );

    my $data = [];

    try {
        $data = decode_json( $content );

        $self->log->info( 'Imported food truck data from file successfully' );
    }
    catch {
        $self->log->warn( 'Could not import food truck data from file successfully: %s', $_ );
    };

    return $data;
}


=method configure_plugins

This method configures plugins and application resources.  We use it to configure the core application functionality as well as functionality provided by extensions.

=cut

sub configure_plugins {
    my ( $self ) = @_;

    # Put plugin configuration here
    # This is where we configure authentication, authorization, database connections, etc

    $self->renderer->default_format( 'json' );

    return;
}


=method configure_hooks

This method configures functionality provided through application hooks.

=cut

sub configure_hooks {
    my ( $self ) = @_;

    $self->hook( before_dispatch => \&FTF::Hook::before_dispatch );
    $self->hook( after_render => \&FTF::Hook::after_render );

    return;
}


=method configure_routes

This method configures application routes.

=cut

sub configure_routes {
    my ( $self ) = @_;

    my $r = $self->routes->namespaces( [ 'FTF::Controller' ] );

    # Normally, we would separate these out into individual methods.
    # Since we only have a couple of routes, we can leave them here.

    my $system = $r->any( '/' )->to( 'System#' );

    $system->get( '/' )->to( '#retrieve_index' );

    my @methods  = ( 'GET', 'POST', 'PUT', 'DEL' );
    my %params = ( value => '.*' );

    $system->any( \@methods, '/<:value>', \%params )->to( '#default' );

    return;
}


1;

# ABSTRACT: Food Truck Finder application class
