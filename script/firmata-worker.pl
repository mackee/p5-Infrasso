#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Device::Firmata;
use Device::Firmata::Constants qw/:all/;
use FindBin::libs;
use Redis;
use Time::HiRes qw/sleep/;

my $device = Device::Firmata->open("/dev/tty.usbmodemfd121");
my $redis = Redis->new();

$device->pin_mode(3 => PIN_SERVO);
$device->servo_write(3 => 10);
$device->pin_mode(5 => PIN_OUTPUT);
$device->digital_write(5 => 0);
$device->pin_mode(2 => PIN_OUTPUT);
$device->digital_write(2 => 0);

my ($servo_angle, $blue_state, $red_state);
while (1) {
    my $angle = $redis->get("servo_angle") // 0;
    if (!defined $servo_angle || $servo_angle != $angle) {
        $device->servo_write(3 => $angle+10);
        $servo_angle = $angle;
    }

    my $blue = $redis->get("blue_state") // 0;
    if (!defined $blue_state || $blue_state != $blue) {
        $device->digital_write(5 => $blue);
        $blue_state = $blue;
    }

    my $red = $redis->get("red_state") // 0;
    if (!defined $red_state || $red_state != $red) {
        $device->digital_write(2 => $red);
        $red_state = $red;
    }
    sleep 0.05;
}
