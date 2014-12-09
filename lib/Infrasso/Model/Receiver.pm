package Infrasso::Model::Receiver;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw/message/],
);
use EV::Hiredis;

sub process {
    my $self = shift;

    my ($command, $value) = split /:/, $self->message;
    return unless $self->can($command);
    $self->$command($value);
}

sub set_state_blue {
    my ($self, $state) = @_;
    my $redis = $self->_redis();
    $redis->set("blue_state" => $state, sub {
        $redis->disconnect;
    });
}

sub set_state_red {
    my ($self, $state) = @_;
    my $redis = $self->_redis();
    $redis->set("red_state" => $state, sub {
        $redis->disconnect;
    });
}

sub set_angle {
    my ($self, $angle) = @_;
    my $redis = $self->_redis();
    $redis->set("servo_angle" => $angle, sub {
        $redis->disconnect;
    });
}

sub _redis {
    my $redis = EV::Hiredis->new(host => "127.0.0.1");
}

1;