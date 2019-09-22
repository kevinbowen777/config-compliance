#!/usr/bin/perl
# -------------------------------------------------------------------------- #
#
# Name: check-cisco-configs.pl
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

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;
use FindBin;
use lib "$FindBin::Bin/../lib";;
use POSIX qw(strftime);

use ioslib;

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date = strftime "%m%d%y",localtime;
my $config;
my $dirname = File::Basename::dirname($abs_path);
# my $devices = "$FindBin::Bin/../devices/device_list.txt";
my $cfgfiles = '/home/kbowen/dev/sandbox/config-compliance/devices';
my $devices = '/home/kbowen/dev/sandbox/config-compliance/devices/device_list.txt';
my $lines;

print"Date,ConfigStamp,Device,Platform,Policy,Result,Remediation config\n";

# Open list of devices
open FILE, "$devices" or die "Could not open $devices $!";

while (<FILE>) {
	$lines .= $_;
}

close FILE;

foreach my $line (split(/\n/, $lines)) {
	$line =~ s/\s+$//;
	$config = "";
	
	# Open device configuration files 
	open FILE, '<', "$cfgfiles/$line" or die "Could not open $line $!";;
	# open FILE, '<', "../devices/$line" or die "Could not open $line $!";;
	while (<FILE>) { $config .= $_ }
	close $devices;

 # Check device platforms - IOS, NX-OS, IOS XR
 if($config =~ /NVRAM/m || $config =~ /version 12/m || $config =~ /version 15/m){
	# Print "SMARTSIOS 1.00  $line\n";
	my $output = `$dirname/smartsios_1.2.1.pl $line`;
	print $output;
 } elsif($config =~ /feature tacacs/m){
 	# Print "SMARTSNX 1.00 $line\n";
	my $output = `$dirname/smartsnx_1.2.1.pl $line`;
	print $output;
 } elsif($config =~ /IOS XR/m){
	print ",,$line,IOS XR - UNSUPPORTED,N/A,FAIL\n";
 } else{
	print ",,$line,UNSUPPORTED PLATFORM,N/A,FAIL\n";
 }
}
