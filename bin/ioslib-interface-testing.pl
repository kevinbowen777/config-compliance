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
use lib "$FindBin::Bin/../lib";
use POSIX qw(strftime);
use File::stat;

use ioslib;

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date     = strftime "%m/%d/%y", localtime;
my $dirname  = File::Basename::dirname($abs_path);
my $cfgfiles = "$dirname/../devices";
my $config   = '';
my $diff = "";


my $ios_policy_dir = "$dirname/../policies/ios";

# Command line input
# requires a filename. needs better error handling for failure.
my ($file) = @ARGV;

#Open config file
open my $FILE, '<', "$cfgfiles/$file" or die "file not found $file";

# File timestamp
my $timestamp = strftime "%m/%d/%y", localtime(stat($FILE)->mtime);

# Dump config into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $output = "$file,";

my @int_list = &interface_list($config);
foreach (@int_list) {
	print "$_\n";
}

# looks like this is pulling entire config with nesting parts back not just 
# interfaces as expected. Perhaps rename subroutine??
my @int_array_nest = &int_array_nest($config);
foreach (@int_array_nest) {
	print "$_\n";
}

my @vlan_priorities = &vlan_priorities($config);
foreach (@vlan_priorities) {
	print "$_\n";
}
my @int_vlan_nest = &int_vlan_nest($config);
foreach (@int_vlan_nest) {
	print "$_\n";
}
# Policy 04 - IOS Line AUX
# $diff = &ios_config_nested_lines(
#     &open_file("$ios_policy_dir/policy_04_IOS_Line_AUX"), $config );
# if ( $diff =~ /does not exist/i ) {
# 	my $output = "PASS,you don't exist";
# 	my $diff   = "";
# 	print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";
# 	}
# else {
# 	my $output = &pass_check($diff);
# 	$diff   = &strip_comments($diff);
# 	print "$date,$timestamp,$file,IOS,04 - Line AUX,$output$diff\n";
# }

# Policy 08 - IOS DNS
# $diff = &ios_config_global_lines(
#     &open_file("$ios_policy_dir/policy_08_IOS_DNS"), $config );
# $output = &pass_check($diff);
# $diff   = &strip_comments($diff);
# print "$date,$timestamp,$file,IOS,08 - DNS,$output$diff\n";

#
sub strip_comments {

    my $new_config = shift or die;

    # Separate the config commands from the comments in the new config
	# $new_config here appears to be using the policy templates.
	# Perhaps rename the variable to reflect this?
	my $config = "";
    foreach my $line ( split( /\n/, $new_config ) ) {
		if ( $line =~ s/^\s*(!)/$1/ ) {

            # Do Nothing - Is this appropriate?
        }
        else {
            $config .= "$line\n";
        }
    }

    # This will strip SNMP Community strings from the report
	# Consider pulling the strings from an ENV file to avoid
	# storing sensitive data in VCS
	$config =~ s{Alle5Gut}{<REDACTED>}g;
	$config =~ s{\$3rvIceNoW!}{<REDACTED>}g;
    $config =~ tr{\n}{ };
	return "$config";
}
