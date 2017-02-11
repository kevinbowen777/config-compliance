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
#
# Updated: 20170210
#
# -------------------------------------------------------------------------- #

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";;
use ioslib;
use POSIX qw(strftime);

my $date = strftime "%m%d%y",localtime;
my $config;
my $file = "/devices/device_list.txt";

print"Date,ConfigStamp,Device,Platform,Policy,Result,Remediation config\n";

# Open device-list file
open my $FILE, '<', "$file" or die $file;
while (<FILE>) { my $lines .= $_ }
close $FILE;

foreach my $line (split(/\n/, my $lines)) {
	$line =~ s/\s+$//;
	$config = "";
	# Print "$line\n";
	# Open config file
	open my $FILE, '<', "../devices/$line";
	while (<FILE>) { $config .= $_ }
	close FILE;

 if($config =~ /NVRAM/m || $config =~ /version 12/m || $config =~ /version 15/m){
	# Print "SMARTSIOS 1.00  $line\n";
	my $output = `smartsios_1.00.pl $line`;
	print $output;
 } elsif($config =~ /feature tacacs/m){
 	# Print "SMARTSNX 1.00 $line\n";
	my $output = `smartsnx_1.00.pl $line`;
	print $output;
 } elsif($config =~ /IOS XR/m){
	print "IOS XR $line\n";
 } else{
	print "UNKNOWN $line-confg\n";
 }
}

#`/bin/chmod 644 /scripts/reports/datacenter-1/datacenter-1_device_remediation_$date.txt`;

