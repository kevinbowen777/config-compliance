#!/usr/bin/perl
# {{{ ---------------------------------------------------------------------- #
#
# Name: smartsios_1.2.1.pl
# Purpose: This script checks configurations in ../devices direction
# for IOS v1.00 policy violations
# Compatible:
# Requirements: ioslib.pm
#
# Version: 1.2.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Original source:
# Updated: 20190919
#
# }}} ---------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;
use FindBin;
use Path::Class;
use lib "$FindBin::Bin/../lib";
use POSIX qw(strftime);
use File::stat;

use ioslib;

# TODO: Change $dirname to $approot
my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date     = strftime "%m/%d/%y", localtime;
my $dirname  = (dir(File::Basename::dirname($abs_path))->parent);
my $cfgfiles = $dirname->subdir('devices');
my $policydir = $dirname->subdir('policies');
my $ios_policy_dir = $policydir->subdir('ios');
my $config   = '';
my $diff = "";
#Command line input
my ($file) = @ARGV;

#Open config file
open my $FILE, '<', "$cfgfiles/$file" or die "file not found $file $!";

# File timestamp
my $timestamp = strftime "%m/%d/%y", localtime(stat($FILE)->mtime);

# Dump config into $config
while (<$FILE>) {
        $config .= $_;
}
close $FILE;

my $output = "$file,";

# Policy 01 - IOS AAA Configuration
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_01_IOS_AAA"), $config );
$output = &pass_check($diff);
$diff = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,01 - AAA,$output$diff\n";

# Policy 02 - IOS TACACS
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_02_IOS_TACACS"), $config );
$output = &pass_check($diff);
$diff = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,02 - TACACS,$output$diff\n";

# Policy 03 - IOS Line Console
$diff = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_03_IOS_Line_Console"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,03 - Line CONSOLE,$output$diff\n";

# Policy 04 - IOS Line AUX
$diff = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_04_IOS_Line_AUX"), $config );
if ( $diff =~ /does not exist/mi ) {
    $output = "PASS,";
    $diff  = "";
}
else {
    $output = &pass_check($diff);
    $diff  = &strip_comments($diff);
}
print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";

# Policy 05 - IOS Line VTY 0 4
$diff = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_05_IOS_Line_VTY1"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,05 - Line VTY1,$output$diff\n";

# Policy 06 - IOS Line VTY 5 15
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_06_IOS_Line_VTY2"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,06 - Line VTY2,$output$diff\n";

# Policy 07 - IOS NTP
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_07_IOS_NTP"), $config );
$output = "PASS,";
$diff =~ tr{\n}{ };
$diff = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,07 - NTP,$output$diff\n";

# Policy 08 - IOS DNS
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_08_IOS_DNS"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,08 - DNS,$output$diff\n";

# Policy 09 - IOS SNMP ACL Configuration
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_09_IOS_SNMP_ACL"), $config );
$output = &pass_check($diff);
$diff = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,09 - SNMP ACL,$output$diff\n";

# Policy 10 - IOS SNMP Configuration
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_10_IOS_SNMP"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,10 - SNMP,$output$diff\n";

# Policy 11 - IOS SNMP Identity information
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_11_IOS_SNMP_Identity"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,11 - SNMP Identity,$output$diff\n";

# Policy 12 - IOS Banner
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_12_IOS_Banner"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,12 - Banner,$output$diff\n";

# Policy 13 - IOS SSH
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_13_IOS_SSH"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,13 - SSH,$output$diff\n";

# Policy 14 - IOS VStack
if ( $config =~ /switch 1 provision/i ) {
    $diff = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_14_IOS_VStack"), $config );
    $output = &pass_check($diff);
    $diff  = &strip_comments($diff);
	print "$date,$timestamp,$file,IOS,14 - VStack,$output$diff\n";
}
else {
    $diff   = "";
    $output = "PASS,";
	print "$date,$timestamp,$file,IOS,14 - VStack,$output$diff\n";
}

# Policy 15 - IOS Basic Services
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_15_IOS_Basic_Services"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,15 - BASIC Services,$output$diff\n";

# Policy 16 -IOS Boot System
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_16_IOS_Boot_System"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,16 - Boot System,$output$diff\n";

# Policy 17 - IOS RCMD
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_17_IOS_RCMD"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,17 - RCMD,$output$diff\n";

# Policy 18 - IOS Loopbacks
if ( $config =~ /interface Loopback0/im && $file !~ /-sw/ ) {
    my $diff = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_18_IOS_Loopback"), $config );
    $output = &pass_check($diff);
    $diff  = &strip_comments($diff);
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output$diff\n";
}
else {
    my $diff  = "";
    my $output = "PASS,";
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output$diff\n";
}

# Policy 19 - IOS Interface Security
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_19_IOS_Interface_Security"), $config );
$output .= &pass_check($diff);
$output = "PASS,";
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,19 - Interface Security,$output$diff\n";

# Policy 20 - IOS Rapid  ACL
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_20_IOS_Rapid_ACL"), $config );
$output = "PASS,";
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,20 - Rapid ACL,$output$diff\n";

# Policy 21 - IOS SNMP TRAP
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_21_IOS_SNMP_TRAP"), $config );
$output = "PASS,";
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,21 - SNMP Trap,$output$diff\n";

# Policy 22 - IOS Interface Description
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_22_IOS_Interface_Description"),
    $config );
$output = "PASS,";
$diff = &strip_comments($diff);
print
    "$date,$timestamp,$file,IOS,22 - Interface Description,$output$diff\n";

# Policy 23 - IOS IP Security
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_23_IOS_IP_Security"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,23 - IP SECURITY,$output$diff\n";

# Policy 24 - IOS Logging
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_24_IOS_Logging"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,24 - LOGGING,$output$diff\n";

# Policy 25 -IOS VTP
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_25_IOS_VTP"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,25 - VTP,$output$diff\n";

# Policy 26 - IOS BPDUGuard
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_26_IOS_BPDUGuard"), $config );
$output = &pass_check($diff);
$diff  = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,26 - BPDUGUARD,$output$diff\n";

# Policy 27 -IOS BPDUGuard Default
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_27_IOS_BPDUGuard_Default"), $config );
$output = &pass_check($diff);
$diff = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,27 - BPDUGUARD-DEFAULT,$output$diff\n";

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
