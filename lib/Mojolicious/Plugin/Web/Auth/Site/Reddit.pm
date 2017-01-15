use strict;
use warnings;

package Mojolicious::Plugin::Web::Auth::Site::Reddit;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has access_token_url => 'https://www.reddit.com/api/v1/access_token';
has authorize_url    => 'https://www.reddit.com/api/v1/authorize';
has response_type    => 'code';
has user_info        => 0;

#has user_info_url    => 'https://www.reddit.com/api/v1/me';

sub moniker { 'reddit' }

1;
__END__

# ABSTRACT: Reddit OAuth Plugin for Mojolicious::Plugin::Web::Auth

=pod

=head1 SYNOPSIS

    my $scope = 'identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread';

    # Mojolicious
    $self->plugin(
        'Web::Auth',
        module      => 'Reddit',
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

=cut
