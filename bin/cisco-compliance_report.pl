#!/usr/bin/perl
# -------------------------------------------------------------------------- #
#
# Name: cisco-compliance_report.pl
# Purpose: Pulls device information from: ../devices/device_list.txt
#		and start running policy scripts for IOS and NX-OS devices
# Compatible: n/a
# Requirements: ioslib.pm
#
# Version: 1.2.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Updated: 20190919
#
# -------------------------------------------------------------------------- #

use 5.14.0;
# use strict;
# use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";;
use ioslib;
use POSIX qw(strftime);

my $date = strftime "%m%d%y",localtime;
my $config;
my $devices = '../devices/device_list.txt';
my $lines;

print"Date,ConfigStamp,Device,Platform,Policy,Result,Remediation config\n";

# Open device-list devices
# open my $devices, '<', "$devices" or die "Could not open $devices: $!";
open FILE, "$devices" or die "Could not open $devices $!";

while (<FILE>) {
	$lines .= $_;
}

close FILE;

foreach my $line (split(/\n/, $lines)) {
	$line =~ s/\s+$//;
	$config = "";
	print "==============================\n";
	# print "$line\n";
	# Open config devices
	open FILE, '<', "../devices/$line" or die "Could not open $line $!";;
	while (<FILE>) { $config .= $_ }
	close devices;

 if($config =~ /NVRAM/m || $config =~ /version 12/m || $config =~ /version 15/m){
	# Print "SMARTSIOS 1.00  $line\n";
	my $output = `smartsios_1.2.1.pl $line`;
	print $output;
 } elsif($config =~ /feature tacacs/m){
 	# Print "SMARTSNX 1.00 $line\n";
	my $output = `smartsnx_1.2.1.pl $line`;
	print $output;
 } elsif($config =~ /IOS XR/m){
	print "IOS XR $line\n";
 } else{
	print "UNKNOWN $line\n";
 }
}

#`/bin/chmod 644 /scripts/reports/datacenter-1/datacenter-1_device_remediation_$date.txt`;

