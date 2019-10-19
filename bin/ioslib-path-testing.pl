#!/usr/bin/perl

# {{{ ---------------------------------------------------------------------- #
#
# Name:		ios-path-testing.pl
# Purpose: This script is used for testing path settings and modules
#				used to cleanup directory usage
# Requirements: ioslib.pm
#
# Version: 0.0.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Original source: policycheck_IOS-1.2.1.pl
# Updated: 20191016
#
# }}} ---------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;
use FindBin;
# use File::Spec;
use Path::Class;
use lib "$FindBin::Bin/../lib";
use POSIX qw(strftime);
use File::stat;

use ioslib;
# TODO: Change $dirname to $approot(dir)
my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date     = strftime "%m/%d/%y", localtime;
# my $dirname  = File::Basename::dirname($abs_path);
my $dirname  = (dir(File::Basename::dirname($abs_path))->parent);
# my $cfgfiles = "$dirname/../devices";
my $cfgfiles = $dirname->subdir('devices');
my $config   = '';
my $diff = "";
# my $ios_policy_dir = "$dirname/../policies/ios";
my $policydir = $dirname->subdir('policies');
my $ios_policy_dir = $policydir->subdir('ios');
my ($devices) = $ARGV;




# print "========================\n";
# print "*** The following variables are used for path identification ***\n";
# print "========================\n";
# print "\$abs_path is:\n\t $abs_path\n";
# print "----------------\n";
# print "\$dirname is:\n\t $dirname\n";
# print "----------------\n";
# print "\$cfgfiles is:\n\t $cfgfiles\n";
# print "----------------\n";
# print "\$policydir (Class::Path) is:\n\t $policydir\n";
# print "----------------\n";
# print "\$ios_policy_dir is:\n\t $ios_policy_dir\n";
# print "----------------\n";

#for (1..6) {
#  print "Relative: $binDIR_test_free\n";
#  $binDIR_test_free = $binDIR_test_free->parent;
#}
# Command line input
# requires a filename. needs better error handling for failure.
# my ($file) = @ARGV;
if ( not defined $devices ) {
	$devices = "$cfgfiles/device_list-testing.txt";
}
if ( defined $devices ) {
        # print "\$DEVICES_argv:\n\n $devices\n";
}

#Open config file
open my $FILE, '<', "$devices" or die "file not found $devices $!";
my $timestamp = strftime "%m/%d/%y", localtime(stat($FILE)->mtime);
# print "\$DEVICES:\n\n $devices\n\n";
# Dump config into $config
while (<$FILE>) { 
        $config .= $_; 

}
close $FILE;

my $output = "$devices,";

# Policy 04 - IOS Line AUX
#$diff = &ios_config_nested_lines(
#    &open_file("$ios_policy_dir/policy_04_IOS_Line_AUX"), $config );
#if ( $diff =~ /does not exist/i ) {
#	my $output = "PASS,you don't exist";
#	my $diff   = "";
#	print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";
#	}
#else {
#	my $output = &pass_check($diff);
#	$diff   = &strip_comments($diff);
#	print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";
#}

# Policy 08 - IOS DNS
$diff = &ios_config_global_lines( &open_file("$ios_policy_dir/policy_08_IOS_DNS"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$devices,IOS,08 - DNS,$output$diff\n";
