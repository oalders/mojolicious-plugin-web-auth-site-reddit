use strict;
use warnings;

package Mojolicious::Plugin::Web::Auth::Site::Reddit;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has access_token_url => 'https://www.reddit.com/api/v1/access_token';
has authorize_header => 'bearer ';
has authorize_url    => 'https://www.reddit.com/api/v1/authorize';
has response_type    => 'code';
has user_info        => 1;
has user_info_url    => 'https://oauth.reddit.com/api/v1/me';

sub moniker { 'reddit' }

1;
__END__

# ABSTRACT: Reddit OAuth Plugin for Mojolicious::Plugin::Web::Auth

=pod

=head1 SYNOPSIS

    use URI::FromHash qw( uri );
    my $key = 'foo';
    my $secret = 'seekrit';

    my $access_token_url = uri(
        scheme   => 'https',
        username => $key,
        password => $secret,
        host     => 'api.fitbit.com',
        path     => 'oauth2/token',
    );

    my $scope = 'identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread';

    # Mojolicious
    $self->plugin(
        'Web::Auth',
        module           => 'Reddit',
        access_token_url => $access_token_url,
        authorize_url =>
            'https://www.reddit.com/api/v1/authorize?duration=permanent',
        key         => 'Reddit consumer key',
        secret      => 'Reddit consumer secret',
        scope       => $scope,
        on_finished => sub {
            my ( $c, $access_token, $access_secret ) = @_;
            ...;
        },
    );

    # Mojolicious::Lite
    plugin 'Web::Auth',
        module      => 'Reddit',
        access_token_url => $access_token_url,
        authorize_url =>
            'https://www.reddit.com/api/v1/authorize?duration=permanent',
        key         => 'Reddit consumer key',
        secret      => 'Reddit consumer secret',
        scope       => $scope,
        on_finished => sub {
            my ( $c, $access_token, $access_secret ) = @_;
            ...
        };

    # default authentication endpoint: /auth/reddit/authenticate
    # default callback endpoint: /auth/reddit/callback

=head1 DESCRIPTION

This module adds L<Reddit|https://www.reddit.com/dev/api/> support to
L<Mojolicious::Plugin::Web::Auth>.

The default C<authorize_url> allows only for temporary tokens.  If you require
a refresh token, set your own C<authorize_url> as in the example in the
SYNOPSIS.

=cut
