package Infrasso::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Infrasso::Model::Receiver;

any '/' => sub {
    my ($c) = @_;
    return $c->render('index.tx');
};

any '/connect' => sub {
    my $c = shift;
    return $c->websocket(sub {
        my $ws = shift;
        $ws->on_receive_message(sub {
            my ($c, $message) = @_;
            my $receiver = Infrasso::Model::Receiver->new(message => $message);
            $receiver->process;
        });
    });
};

1;