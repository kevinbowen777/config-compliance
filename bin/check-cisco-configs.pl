#!/usr/bin/perl
# {{{ ---------------------------------------------------------------------- #
#
# Name: check-cisco-configs.pl
# Purpose: Pulls device information from: ../devices/device_list.txt
#		Determine whether config is an IOS or NX-OX device
#		and start running the appropriate platform's policy script
# Compatible: n/a
# Requirements: ioslib.pm
#
# Version: 1.2.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Updated: 20190919
#
# }}}----------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;
use FindBin;
use lib "$FindBin::Bin/../lib";
use POSIX qw(strftime);

use ioslib;

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date     = strftime "%m/%d/%y", localtime;
my $config;
my $dirname  = File::Basename::dirname($abs_path);
my $cfgfiles = "$dirname/../devices";
my $lines;
my ($devices) = @ARGV;

if ( not defined $devices ) {
    $devices = "$cfgfiles/device_list.txt";
}
if ( defined $devices ) {
}

print "Date,ConfigStamp,Device,Platform,Policy,Result,Remediation config\n";

# Open list of devices
open FILE, '<',  "$devices" or die "Could not open $devices $!";

while (<FILE>) {
    $lines .= $_;
}

close FILE;

foreach my $line ( split( /\n/, $lines ) ) {
    $line =~ s/\s+$//;
    $config = "";

    # Open device configuration files
    open FILE, '<', "$cfgfiles/$line" or die "Could not open $line $!";
    while (<FILE>) { $config .= $_ }
    close $devices;

    # Check device platforms - IOS, NX-OS, IOS XR
    if (   $config =~ /NVRAM/m
        || $config =~ /version 12/m
        || $config =~ /version 15/m )
    {
        # Run IOS policy check
        my $output = `$dirname/policycheck_IOS_1.2.1.pl $line`;
        print $output;
    }
    elsif ( $config =~ /feature tacacs/m ) {

        # Run NX-OS policy check
        my $output = `$dirname/policycheck_NX-OS_1.2.1.pl $line`;
        print $output;
    }
    elsif ( $config =~ /IOS XR/m ) {

        # Match format to fit in remediation report cleanly
        print "$date,,$line,IOS XR - UNSUPPORTED,N/A,FAIL\n";
    }
    else {
        print "$date,,$line,UNSUPPORTED PLATFORM,N/A,FAIL\n";
    }
}
