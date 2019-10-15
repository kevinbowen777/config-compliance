#!/usr/bin/perl

# {{{ ----------------------------------------------------------------------- #
#
# Name: cisco-compliance_reports-testing.pl
# 
# Description: Runs the remediation scripts and outputs them to csv files.
# It changes permissions and group ownership to make them publicly readable.
# Re-ordering the chmod and chgrp allows reports to be available upon
# completion, rather than having to wait for the whole set of reports to run.
#
# Compatible: n/a
# Requirements:
#
# Version: 0.0.1
# Author: Kevin Bowen <kevin.bowen@gmail.com>
#
# Original source:
# Updated: 20191014
#
# }}} ----------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use File::Basename;
use POSIX qw(strftime);

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $dirname = File::Basename::dirname($abs_path);
my $report_date = strftime "%Y%m%d-%H:%M",localtime;
my $report_dir = "$dirname/../reports";
my $device_dir = "$dirname/../devices";
my $date = strftime "%m/%d/%y %H:%M" ,localtime;

# All Cisco Devices Report
print "***** TESTING *****\n";
print "Processing compliance report for TESTING devices...\n";

`$dirname/check-cisco-configs-testing.pl >$report_dir/testing/TESTING-REPORT-$report_date.csv`;
`/bin/chmod 644 $report_dir/testing/TESTING-REPORT-$report_date.csv`;
`/bin/chgrp users $report_dir/testing/TESTING-REPORT-$report_date.csv`;

print "Completed processing of report for TESTING devices - $date.\n";
print "***** TESTING *****\n";
