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
my $timestamp = strftime "%m/%d/%y", localtime(stat($FILE)->mtime);

# Dump config into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $diff = "";

my $output = "$file,";

my @int_list = &interface_list($config);

# Policy 04 - IOS Line AUX
$diff = &ios_config_nested_lines(
    &open_file("$ios_policy_dir/policy_04_IOS_Line_AUX"), $config );
if ( $diff =~ /does not exist/i ) {
	my $output = "PASS,you don't exist";
	my $diff   = "";
	print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";
	}
else {
	my $output = &pass_check($diff);
	$diff   = &strip_comments($diff);
	print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";
}
# print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";

# Policy 08 - IOS DNS
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_08_IOS_DNS"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,08 - DNS,$output$diff\n";

# Policy 14 - IOS VStack
if ( $config =~ /switch 1 provision/im ) {
	my $diff = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_14_IOS_VStack"), $config );
	my $output = &pass_check($diff);
	$diff   = &strip_comments($diff);
	print "$date,$timestamp,$file,IOS,14 - VStack,$output$diff\n";
   }
else {
	my $diff   = "";
	my $output = "PASS,";
	print "$date,$timestamp,$file,IOS,14 - VStack,$output$diff\n";
	}

# Policy 16 -IOS Boot System
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_16_IOS_Boot_System"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,16 - Boot System,$output$diff\n";

# Policy 17 - IOS RCMD
$diff = &ios_config_global_lines(
    &open_file("$ios_policy_dir/policy_17_IOS_RCMD"), $config );
$output = &pass_check($diff);
$diff   = &strip_comments($diff);
print "$date,$timestamp,$file,IOS,17 - RCMD,$output$diff\n";

# Policy 18 - IOS Loopbacks
if ( $config =~ /interface Loopback0/im && $file !~ /-sw/ ) {
    my $diff = &ios_config_global_lines(
        &open_file("$ios_policy_dir/policy_18_IOS_Loopback"), $config );
    my $output = &pass_check($diff);
    $diff   = &strip_comments($diff);
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output$diff\n";
}
else {
    my $diff   = "";
    my $output = "PASS,";
    print "$date,$timestamp,$file,IOS,18 - Loopback,$output$diff\n";
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
