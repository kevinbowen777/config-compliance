#!/usr/bin/perl

# {{{ ---------------------------------------------------------------------- #
#
# Name:		ios-call-testing.pl
# Purpose: This script tests subroutine calls to ioslib.pm
# Requirements: ioslib.pm
#
# Version: 0.0.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Original source: policycheck_IOS-1.2.1.pl
# Updated: 20191015
#
# }}} ---------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;
use FindBin;
use lib "$FindBin::Bin/../lib";
use POSIX qw(strftime);
use File::stat;

use ioslib;

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date     = strftime "%m/%d/%y", localtime;
my $dirname  = File::Basename::dirname($abs_path);
my $cfgfiles = "$dirname/../devices";
my $config   = '';

my $ios_policy_dir = "$dirname/../policies/ios";

#Command line input
my ($file) = @ARGV;

#Open config file
open my $FILE, '<', "$cfgfiles/$file" or die "file not found $file";

# File timestamp
my $timestamp = stat($FILE)->mtime;
$timestamp = strftime "%m/%d/%y", localtime($timestamp);

# Dump config into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $diff = "";

my $output = "$file,";

my @int_list = &interface_list($config);

# Policy 04 - IOS Line AUX
my $diff4 = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_04_IOS_Line_AUX"), $config );
#if ( $diff4 =~ /does not exist/i ) {
	#my $output4 = "PASS,";
	#my $diff4   = "";
	#}
	#else {
	# my $output4 = &pass_check($diff4);
	#$diff4   = &strip_comments($diff4);
	#}
my $output4 = &pass_check($diff4);
$diff4   = &strip_comments($diff4);
print "$date,$timestamp,$file,IOS,04 - Line AUX,$output4$diff4\n";

# Policy 08 - IOS DNS
my $diff8 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_08_IOS_DNS"), $config );
my $output8 = &pass_check($diff8);
$diff8   = &strip_comments($diff8);
print "$date,$timestamp,$file,IOS,08 - DNS,$output8$diff8\n";

# Policy 14 - IOS VStack
if ( $config =~ /switch 1 provision/im ) {
	my $diff14 = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_14_IOS_VStack"), $config );
	my $output14 = &pass_check($diff14);
	$diff14   = &strip_comments($diff14);
	print "$date,$timestamp,$file,IOS,14 - VStack,$output14$diff14\n";
   }
else {
	my $diff14   = "";
	my $output14 = "PASS,";
	print "$date,$timestamp,$file,IOS,14 - VStack,$output14$diff14\n";
	}

# Policy 16 -IOS Boot System
my $diff16 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_16_IOS_Boot_System"), $config );
my $output16 = &pass_check($diff16);
$diff16   = &strip_comments($diff16);
print "$date,$timestamp,$file,IOS,16 - Boot System,$output16$diff16\n";

# Policy 17 - IOS RCMD
my $diff17 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_17_IOS_RCMD"), $config );
my $output17 = &pass_check($diff17);
$diff17   = &strip_comments($diff17);
print "$date,$timestamp,$file,IOS,17 - RCMD,$output17$diff17\n";

# Policy 18 - IOS Loopbacks
if ( $config =~ /interface Loopback0/im && $file !~ /-sw/ ) {
    my $diff18 = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_18_IOS_Loopback"), $config );
    my $output18 = &pass_check($diff18);
    $diff18   = &strip_comments($diff18);
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output18$diff18\n";
}
else {
    my $diff18   = "";
    my $output18 = "PASS,";
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output18$diff18\n";
}

#
sub strip_comments {

    my $new_config = shift or die;

    #separate the config commands from the comments in the new config
    my $config = "";
    foreach my $line ( split( /\n/, $new_config ) ) {
        if ( $line =~ s/^\s*(!)/$1/ ) {

            #nothing
        }
        else {
            $config .= "$line\n";
        }
    }

    # This will strip SNMP Community strings from the report
    $config =~ s{Alle5Gut}{<REDACTED>}g;
    $config =~ s{\$3rvIceNoW!}{<REDACTED>}g;
    $config =~ tr{\n}{ };
    return "$config";
}
