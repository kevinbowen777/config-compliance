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

# use strict;
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
my $config;

my $ios_policy_dir = "$dirname/../policies/ios";

#Command line input
my ($file) = @ARGV;

#Open config file
open $file, "$cfgfiles/$file" or die "file not found $file";

# File timestamp
my $timestamp = stat($file)->mtime;
$timestamp = strftime "%m/%d/%y", localtime($timestamp);

# Dump config into $config
while (<$file>) { $config .= $_ }
close $file;

my $diff = "";

my $output = "$file,";

my @int_list = &interface_list($config);

# Policy 01 - IOS AAA Configuration
$diff1 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_01_IOS_AAA"), $config );
$output1 = &pass_check($diff1);
$diff1   = &strip_comments($diff1);
print "$date,$timestamp,$file,IOS,01 - AAA,$output1$diff1\n";

# Policy 02 - IOS TACACS
$diff2 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_02_IOS_TACACS"), $config );
$output2 = &pass_check($diff2);
$diff2   = &strip_comments($diff2);
print "$date,$timestamp,$file,IOS,02 - TACACS,$output2$diff2\n";

# Policy 03 - IOS Line Console
$diff3 = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_03_IOS_Line_Console"), $config );
$output3 = &pass_check($diff3);
$diff3   = &strip_comments($diff3);
print "$date,$timestamp,$file,IOS,03 - Line CONSOLE,$output3$diff3\n";

# Policy 04 - IOS Line AUX
$diff4 = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_04_IOS_Line_AUX"), $config );
if ( $diff4 =~ /does not exist/mi ) {
    $output4 = "PASS,";
    $diff4   = "";
}
else {
    $output4 = &pass_check($diff4);
    $diff4   = &strip_comments($diff4);
}
print "$date,$timestamp,$file,IOS,04 - Line AUX,$output4$diff4\n";

# Policy 05 - IOS Line VTY 0 4
$diff5 = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_05_IOS_Line_VTY1"), $config );
$output5 = &pass_check($diff5);
$diff5   = &strip_comments($diff5);
print "$date,$timestamp,$file,IOS,05 - Line VTY1,$output5$diff5\n";

# Policy 06 - IOS Line VTY 5 15
$diff6 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_06_IOS_Line_VTY2"), $config );
$output6 = &pass_check($diff6);
$diff6   = &strip_comments($diff6);
print "$date,$timestamp,$file,IOS,06 - Line VTY2,$output6$diff6\n";

# Policy 07 - IOS NTP
$diff7 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_07_IOS_NTP"), $config );
$output7 = "PASS,";
$diff7 =~ tr{\n}{ };
$diff7 = &strip_comments($diff7);
print "$date,$timestamp,$file,IOS,07 - NTP,$output7$diff7\n";

# Policy 08 - IOS DNS
$diff8 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_08_IOS_DNS"), $config );
$output8 = &pass_check($diff8);
$diff8   = &strip_comments($diff8);
print "$date,$timestamp,$file,IOS,08 - DNS,$output8$diff8\n";

# Policy 09 - IOS SNMP ACL Configuration
$diff9 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_09_IOS_SNMP_ACL"), $config );
$output9 = &pass_check($diff9);
$diff9   = &strip_comments($diff9);
print "$date,$timestamp,$file,IOS,09 - SNMP ACL,$output9$diff9\n";

# Policy 10 - IOS SNMP Configuration
$diff10 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_10_IOS_SNMP"), $config );
$output10 = &pass_check($diff10);
$diff10   = &strip_comments($diff10);
print "$date,$timestamp,$file,IOS,10 - SNMP,$output10$diff10\n";

# Policy 11 - IOS SNMP Identity information
$diff11 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_11_IOS_SNMP_Identity"), $config );
$output11 = &pass_check($diff11);
$diff11   = &strip_comments($diff11);
print "$date,$timestamp,$file,IOS,11 - SNMP Identity,$output11$diff11\n";

# Policy 12 - IOS Banner
$diff12 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_12_IOS_Banner"), $config );
$output12 = &pass_check($diff12);
$diff12   = &strip_comments($diff12);
print "$date,$timestamp,$file,IOS,12 - Banner,$output12$diff12\n";

# Policy 13 - IOS SSH
$diff13 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_13_IOS_SSH"), $config );
$output13 = &pass_check($diff13);
$diff13   = &strip_comments($diff13);
print "$date,$timestamp,$file,IOS,13 - SSH,$output13$diff13\n";

# Policy 14 - IOS VStack
if ( $config =~ /switch 1 provision/i ) {
    $diff14 = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_14_IOS_VStack"), $config );
    $diff14   = &strip_comments($diff14);
    $output14 = &pass_check($diff14);
}
else {
    $diff14   = "";
    $output14 = "PASS,";
}
print "$date,$timestamp,$file,IOS,14 - VStack,$output14$diff14\n";

# Policy 15 - IOS Basic Services
$diff15 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_15_IOS_Basic_Services"), $config );
$output15 = &pass_check($diff15);
$diff15   = &strip_comments($diff15);
print "$date,$timestamp,$file,IOS,15 - BASIC Services,$output15$diff15\n";

# Policy 16 -IOS Boot System
$diff16 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_16_IOS_Boot_System"), $config );
$output16 = &pass_check($diff16);
$diff16   = &strip_comments($diff16);
print "$date,$timestamp,$file,IOS,16 - Boot System,$output16$diff16\n";

# Policy 17 - IOS RCMD
$diff17 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_17_IOS_RCMD"), $config );
$output17 = &pass_check($diff17);
$diff17   = &strip_comments($diff17);
print "$date,$timestamp,$file,IOS,17 - RCMD,$output17$diff17\n";

# Policy 18 - IOS Loopbacks
if ( $config =~ /interface Loopback0/im && $file !~ /-sw/ ) {
    my $diff18 = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_18_IOS_Loopback"), $config );
    $output18 = &pass_check($diff18);
    $diff18   = &strip_comments($diff18);
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output18$diff18\n";
}
else {
    my $diff18   = "";
    my $output18 = "PASS,";
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output18$diff18\n";
}

# Policy 19 - IOS Interface Security
$diff19 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_19_IOS_Interface_Security"), $config );
$output19 .= &pass_check($diff19);
$output19 = "PASS,";
$diff19   = &strip_comments($diff19);
print "$date,$timestamp,$file,IOS,19 - Interface Security,$output19$diff19\n";

# Policy 20 - IOS Rapid  ACL
$diff20 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_20_IOS_Rapid_ACL"), $config );
$output20 = "PASS,";
$diff20   = &strip_comments($diff20);
print "$date,$timestamp,$file,IOS,20 - Rapid ACL,$output20$diff20\n";

# Policy 21 - IOS SNMP TRAP
$diff21 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_21_IOS_SNMP_TRAP"), $config );
$output21 = "PASS,";
$diff21   = &strip_comments($diff21);
print "$date,$timestamp,$file,IOS,21 - SNMP Trap,$output21$diff21\n";

# Policy 22 - IOS Interface Description
$diff22
    = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_22_IOS_Interface_Description"),
    $config );
$output22 = "PASS,";
$diff22   = &strip_comments($diff22);
print
    "$date,$timestamp,$file,IOS,22 - Interface Description,$output22$diff22\n";

# Policy 23 - IOS IP Security
$diff23 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_23_IOS_IP_Security"), $config );
$output23 = &pass_check($diff23);
$diff23   = &strip_comments($diff23);
print "$date,$timestamp,$file,IOS,23 - IP SECURITY,$output23$diff23\n";

# Policy 24 - IOS Logging
$diff24 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_24_IOS_Logging"), $config );
$output24 = &pass_check($diff24);
$diff24   = &strip_comments($diff24);
print "$date,$timestamp,$file,IOS,24 - LOGGING,$output24$diff24\n";

# Policy 25 -IOS VTP
$diff25 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_25_IOS_VTP"), $config );
$output25 = &pass_check($diff25);
$diff25   = &strip_comments($diff25);
print "$date,$timestamp,$file,IOS,25 - VTP,$output25$diff25\n";

# Policy 26 - IOS BPDUGuard
$diff26 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_26_IOS_BPDUGuard"), $config );
$output26 = &pass_check($diff26);
$diff26   = &strip_comments($diff26);
print "$date,$timestamp,$file,IOS,26 - BPDUGUARD,$output26$diff26\n";

# Policy 27 -IOS BPDUGuard Default
$diff27 = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_27_IOS_BPDUGuard_Default"), $config );
$output27 = &pass_check($diff27);
$diff27   = &strip_comments($diff27);
print "$date,$timestamp,$file,IOS,27 - BPDUGUARD-DEFAULT,$output27$diff27\n";

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
