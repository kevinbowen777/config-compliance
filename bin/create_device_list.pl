#!/usr/bin/perl

# {{{----------------------------------------------------------------------- #
#
# Name: create_device_list.pl
# Purpose:		Take .cfg files and place them in device_list.txt
#				for parsing by compliance report scripts
# Compatible:
# Requirements:
#
# Version: 1.0
# Author: Kevin Bowen <kevin.bowen@gmail.com>
# 
# Original source:
# Updated: 20190922
#
# }}}----------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $dirname = File::Basename::dirname($abs_path);
my $cfgfiles = "$dirname/../devices";
my $devices = "$cfgfiles/device_list.txt";

opendir my $dh, $cfgfiles or die "Could not open '$cfgfiles' for reading: $!\n";
open(my $fh, '>', $devices) or die "Could not open file '$devices': $!\n";

my @devices = grep {$_ ne '.' and $_ ne '..' and $_ ne 'device_list.txt'} readdir $dh;
foreach my $device (@devices) {
	print $fh "$device\n";
}
close $fh;
closedir $dh;
