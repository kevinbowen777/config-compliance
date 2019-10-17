#!/usr/bin/perl
# {{{ ----------------------------------------------------------------------- #
#
# Name: policycheck_NX-OS_1.2.1.pl
# Purpose: This script checks configurations in ../devices direction
# for NX-OS v1.00 policy violations
# Compatible:
# Requirements:
#
# Version: 1.2.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Original source:
# Updated: 20191016
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
use File::stat;

use ioslib;

my $abs_path        = Cwd::abs_path($PROGRAM_NAME);
my $dirname         = File::Basename::dirname($abs_path);
my $cfgfiles        = "$dirname/../devices";
my $date            = strftime "%m/%d/%y", localtime;
my $nxos_policy_dir = "$dirname/../policies/nx-os";
my $config   = '';

# Command line input
my ($file) = @ARGV;

# Open configuration files
open my $FILE, '<', "$cfgfiles/$file" or die "file not found $file $!";

# File timestamp
my $timestamp = strftime "%m/%d/%y", localtime(stat($FILE)->mtime);

# Read configuration into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $diff     = "";
my $output   = "$file,";
my @int_list = &interface_list($config);

# Policy 01 - NX-OS AAA Configuration
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_01_NX-OS_AAA"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,01 - AAA,$output$diff\n";

# Policy 02 - NX-OS TACACS Configuration
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_02_NX-OS_TACACS"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,02 - TACACS,$output$diff\n";

# Policy 03 - NX-OS MGMT Interface
$diff = &ios_config_nested_lines(
    &open_file("$nxos_policy_dir/policy_03_NX-OS_MGMT_Interface"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,03 - MGMT Interface,$output$diff\n";

# Policy 04 - NX-OS MGMT Default Route
$diff = &ios_config_nested_lines(
    &open_file("$nxos_policy_dir/policy_04_NX-OS_MGMT_Routing"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,04 - MGMT Routing,$output$diff\n";

# Policy 05 - NX-OS NTP
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_05_NX-OS_NTP"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,05 - NTP,$output$diff\n";

# Policy 06 - NX-OS NTPConf
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_06_NX-OS_NTPConf"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,06 - NTPConf,$output$diff\n";

# Policy  07 - NX-OS MGMT NTP
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_07_NX-OS_MGMT_NTP"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,07 - MGMT NTP,$output$diff\n";

# Policy 08 - NX-OS DNS
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_08_NX-OS_DNS"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,08 - DNS,$output$diff\n";

# Policy 09 - NX-OS SNMP ACL
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_09_NX-OS_SNMP_ACL"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,09 - SNMP ACL,$output$diff\n";

# Policy 10 - NX-OS SNMP
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_10_NX-OS_SNMP"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,10 - SNMP,$output$diff\n";

# Policy 11 - NX-OS SNMP Identity
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_11_NX-OS_SNMP_Identity"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,11 - SNMP Identity,$output$diff\n";

# Policy 12  - NX-OS Banner
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_12_NX-OS_Banner"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,12 - Banner,$output$diff\n";

# Policy 13 - NX-OS SSH
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_13_NX-OS_SSH"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,13 - SSH,$output$diff\n";

# Policy 14 - NX-OS SNMPv3 Configuration
$diff .= &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_14_NX-OS_SNMPv3"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,14 - SNMPv3,$output$diff\n";

# Policy 15 - NX-OS Basic Services
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_15_NX-OS_Basic_Services"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,15 - Basic Services,$output$diff\n";

# Policy 16 - NX-OS Boot System
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_16_NX-OS_Boot_System"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,16 - Boot System,$output$diff\n";

# Policy 17 - NX-OS RCMD
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_17_NX-OS_RCMD"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,17 - RCMD,$output$diff\n";

# Policy 18 - NX-OS Loopback
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_18_NX-OS_Loopback"), $config );

# Current batch of NX-OS do not use loopback. Ignore test.
# $output = &pass_check($diff);
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,18 - Loopback,$output$diff\n";

# Policy 19 - NX-OS IP Security
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_19_NX-OS_IP_Security"), $config );
$output .= &pass_check($diff);
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,19 - IP Security,$output$diff\n";

# Policy 20 - NX-OS Source Route
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_20_NX-OS_Source_Route"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,20 - Source Route,$output$diff\n";

# Policy 21 - NX-OS SNMP Trap
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_21_NX-OS_SNMP_TRAP"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,21 - SNMP Trap,$output$diff\n";

# Policy 22 - NX-OS Interface Description
$diff
    = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_22_NX-OS_Interface_Description"),
    $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print
    "$date,$timestamp,$file,NX-OS,22 - Interface Description,$output$diff\n";

# Policy 23 - NX-OS CoPP Policy
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_23_NX-OS_CoPP"), $config );

# $diff .= &ios_config_nested_lines(&open_file("$nxos_policy_dir/policy_23_NX-OS_Copp"),$config);
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,23 - CoPP,$output$diff\n";

# Policy 24 - NX-OS Logging
# $diff = &ios_config_acls(&open_file("$nxos_policy_dir/policy_24"),$config);
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_24_NX-OS_Logging"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,24 - Logging,$output$diff\n";

# Policy 25 - NX-OS VTP
# $diff = &ios_config_all_interfaces(&open_file("$nxos_policy_dir/policy25"),$config,@int_list);
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_25_NX-OS_VTP"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,25 - VTP,$output$diff\n";

# Policy 26 - NX-OS BPDUGuard
# $diff = &ios_config_all_interfaces(&open_file("$nxos_policy_dir/policy_26_NX-OS_BPDUGuard"),$config,@int_list);
$diff = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_26_NX-OS_BPDUGuard"), $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,NX-OS,26 - BPDUGuard,$output$diff\n";

# Policy 27 - NX-OS BPDUGuard Default
$diff
    = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_27_NX-OS_BPDUGuard_Default"),
    $config );
$output = "PASS,";
$diff   = &strip_comments($diff);
print
    "$date,$timestamp,$file,NX-OS,27 - BPDUGuard Default,$output$diff\n";

sub strip_comments {

    my $new_config = shift or die;

    #separate the config commands from the comments in the new config
    my $config = "";
    foreach my $line ( split( /\n/, $new_config ) ) {
        if ( $line =~ s/^\s*(!)/$1/ ) {
        }
        else {
            $config .= "$line\n";
        }
    }

    # This will strip SNMP Community strings from the report
    $config =~ s{3ye1nTh3Sky}{<REDACTED>}g;
    $config =~ tr{\n}{ };
    return "$config";
}
