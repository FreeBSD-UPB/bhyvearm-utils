#!/bin/sh

ifconfig vtnet0 inet 10.0.4.87 netmask 255.255.255.240
ifconfig vtnet0 ether 04:05:06:07:08:09
