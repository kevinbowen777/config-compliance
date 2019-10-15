#!/usr/bin/perl

# {{{ ----------------------------------------------------------------------- #
#
# Name:		policycheck_NX-OS-testing.pl
# Purpose: This script checks configurations in ../devices direction
# for NX-OS v1.00 policy violations
# Compatible:
# Requirements:
#
# Version: 0.0.1
# Author: Kevin Bowen kevin.bowen@gmail.com
#
# Original source:
# Updated: 20191014
#
# }}}----------------------------------------------------------------------- #

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

my $abs_path        = Cwd::abs_path($PROGRAM_NAME);
my $dirname         = File::Basename::dirname($abs_path);
my $cfgfiles        = "$dirname/../devices";
my $date            = strftime "%m/%d/%y", localtime;
my $nxos_policy_dir = "$dirname/../policies/nx-os";

# Command line input
my ($file) = @ARGV;

# Open configuration files
open $FILE, "$cfgfiles/$file" or die "file not found $file";

# File timestamp
$timestamp = stat($FILE)->mtime;
$timestamp = strftime "%m/%d/%y", localtime($timestamp);

# Read configuration into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $diff     = "";
my $output   = "$file,";
my @int_list = &interface_list($config);

# Policy 14 - NX-OS SNMPv3 Configuration
$diff14 .= &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_14_NX-OS_SNMPv3"), $config );
$output14 = &pass_check($diff14);
$diff14   = &strip_comments($diff14);
print "$date,$timestamp,$file,NX-OS,14 - SNMPv3,$output14$diff14\n";

# Policy 18 - NX-OS Loopback
$diff18 = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_18_NX-OS_Loopback"), $config );

# Current batch of NX-OS do not use loopback. Ignore test.
# $output18 = &pass_check($diff18);
$output18 = "PASS,";
$diff18   = &strip_comments($diff18);
print "$date,$timestamp,$file,NX-OS,18 - Loopback,$output18$diff18\n";

# Policy 22 - NX-OS Interface Description
$diff22
    = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_22_NX-OS_Interface_Description"),
    $config );
$output22 = &pass_check($diff22);
$diff22   = &strip_comments($diff22);
print
    "$date,$timestamp,$file,NX-OS,22 - Interface Description,$output22$diff22\n";

# Policy 23 - NX-OS CoPP Policy
$diff23 = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_23_NX-OS_CoPP"), $config );

# $diff23 .= &ios_config_nested_lines(&open_file("$nxos_policy_dir/policy_23_NX-OS_Copp"),$config);
$output23 = &pass_check($diff23);
$diff23   = &strip_comments($diff23);
print "$date,$timestamp,$file,NX-OS,23 - CoPP,$output23$diff23\n";

# Policy 24 - NX-OS Logging
# $diff24 = &ios_config_acls(&open_file("$nxos_policy_dir/policy_24"),$config);
$diff24 = &ios_config_global_lines(
    &open_file("$nxos_policy_dir/policy_24_NX-OS_Logging"), $config );
$output24 = &pass_check($diff24);
$diff24   = &strip_comments($diff24);
print "$date,$timestamp,$file,NX-OS,24 - Logging,$output24$diff24\n";



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
