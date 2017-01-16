#!/usr/bin/env perl

use strict;
use warnings;

=head1 SYNOPSIS

    perl -Ilib examples/auth.pl daemon -m development -l http://*:8088

In your browser go to http://localhost:8088/

=head2 ACKNOWLEDGEMENTS

This code is mostly copied from the examples in
L<Mojolicious::Plugin::Web::Auth>.

=cut

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use Config::Pit;
use MIME::Base64;
use Mojolicious::Lite;
use URI::FromHash qw( uri );

print STDERR
    "[NOTICE] should be used in domains other than 'localhost' (e.g. local.example.com)\n";

my $site = 'reddit';
helper site => sub { $site };

my $pit = pit_get(
    $site,
    require => {
        key    => ucfirst($site) . ' Client ID',
        secret => ucfirst($site) . ' Client Secret',
    }
);

my $access_token_url = uri(
    scheme   => 'https',
    username => $pit->{key},
    password => $pit->{secret},
    host     => 'www.reddit.com',
    path     => '/api/v1/access_token',
);

my $scope
    = 'identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread';

plugin 'Mojolicious::Plugin::Web::Auth',
    access_token_url => $access_token_url,
    authorize_url =>
    'https://www.reddit.com/api/v1/authorize?duration=permanent',
    module      => ucfirst($site),
    key         => $pit->{key},
    scope       => $scope,
    on_finished => sub {
    my ( $c, $access_token, $account_info ) = @_;
    $c->session( 'access_token' => $access_token );
    $c->session( 'account_info' => $account_info );
    return $c->redirect_to('index');
    };

get '/' => sub {
    my ($c) = @_;
    unless ( $c->session('access_token') ) {
        use DDP;
        p $c->session;
        return $c->redirect_to('login');
    }
} => 'index';

any [qw/get post/] => '/login' => sub {
    my ($c) = @_;
    if ( uc $c->req->method eq 'POST' ) {
        return $c->redirect_to(
            sprintf( "/auth/%s/authenticate", lc $site ) );
    }
} => 'login';

post '/logout' => sub {
    my ($c) = @_;
    $c->session( expires => 1 );
    $c->redirect_to('index');
} => 'logout';

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
<%= site %> access token: <%= session('access_token') %>
<form method="post" action="/logout">
<button type="submit">Log out</button>
</form>

@@ login.html.ep
% layout 'default';
<form method="post">
<button type="submit">Log in with <%= ucfirst( site ) %></button>
</form>

@@ layouts/default.html.ep
% title 'Auth' . ucfirst(lc site);
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
