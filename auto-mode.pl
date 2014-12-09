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

$device->pin_mode(3 => PIN_SERVO);
$device->pin_mode(5 => PIN_OUTPUT);
$device->pin_mode(2 => PIN_OUTPUT);

while (1) {
    $device->servo_write(3 => 10);
    $device->digital_write(5 => 0);
    $device->digital_write(2 => 1);

    sleep 1;

    $device->servo_write(3 => 100);
    $device->digital_write(5 => 1);
    $device->digital_write(2 => 0);

    sleep 1;
}