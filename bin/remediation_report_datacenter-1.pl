#!/usr/bin/perl
# -------------------------------------------------------------------------- #
#
# Name: remediation_report_datacenter1.pl
# Purpose: This script pulls device information from:
# /scripts/configcheck/device-lists/online_device_list.txt
# Compatible: n/a
# Requirements: ioslib.pm
#
# Version: 1.0
# Author: Kevin Bowen kevin.bowen@gmail.com
# Updated:
#
# Updated: 20170210
#
# -------------------------------------------------------------------------- #

#use strict;
#use warnings;
#Load Libraries
use ioslib;
use POSIX qw(strftime);

$date = strftime "%m%d%y",localtime;
my $config;
my $file = "/scripts/configcheck/device-lists/device_list.txt";

print"Date,ConfigStamp,Device,Platform,Policy,Result,Remediation config\n";

#Open device-list file
open FILE, "$file" or die $file;
while (<FILE>) { $lines .= $_ }
close FILE;

foreach my $line (split(/\n/, $lines)) {
	$line =~ s/\s+$//;
	$config = "";
	#print "$line\n";
	#Open config file
	open FILE, "/tftpboot/online_devices/$line";
	while (<FILE>) { $config .= $_ }
	close FILE;

 if($config =~ /NVRAM/m || $config =~ /version 12/m || $config =~ /version 15/m){
	#print "SMARTSIOS 4.96  $line\n";
	$output = `/scripts/configcheck/nap7_smartsios_4.96.pl $line`;
	print $output;
 }elsif($config =~ /feature tacacs/m){
 	#print "SMARTSNX 1.13 $line\n";
	$output = `/scripts/configcheck/nap7_smartsnx_1.13.pl $line`;
	print $output;
 }elsif($config =~ /IOS XR/m){
	print "IOS XR $line\n";
 }else{
	print "UNKNOWN $line-confg\n";
 }
}

#`/bin/chmod 644 /scripts/reports/datacenter-1/datacenter-1_device_remediation_$date.txt`;

