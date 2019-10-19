#!/usr/bin/perl
# {{{ ----------------------------------------------------------------------- #
#
# Name: cisco-compliance_reports.pl
# 
# Description: Runs the remediation scripts and outputs them to csv files.
# It changes permissions and group ownership to make them publicly readable.
# Re-ordering the chmod and chgrp allows reports to be available upon
# completion, rather than having to wait for the whole set of reports to run.
#
# Compatible: n/a
# Requirements:
#
# Version: 1.2.1
# Author: Kevin Bowen <kevin.bowen@gmail.com>
#
# Original source:
# Updated: 20191018
#
# }}} ----------------------------------------------------------------------- #

use strict;
use warnings;

use Cwd;
use English;
use Path::Class;
use File::Basename;
use POSIX qw(strftime);

my $abs_path = Cwd::abs_path($PROGRAM_NAME);
my $date = strftime "%m/%d/%y %H:%M" ,localtime;
my $dirname  = dir(File::Basename::dirname($abs_path));
my $approot  = (dir(File::Basename::dirname($abs_path))->parent);
my $report_date = strftime "%Y%m%d-%H:%M",localtime;
my $device_dir = $approot->subdir('devices');
my $report_dir = $approot->subdir('reports');

# All Cisco Devices Report
print "Processing compliance report for all Cisco devices...\n";

`$dirname/check-cisco-configs.pl >$report_dir/cisco_remediation-all-$report_date.csv`;
`/bin/chmod 644 $report_dir/cisco_remediation-all-$report_date.csv`;
`/bin/chgrp users $report_dir/cisco_remediation-all-$report_date.csv`;

print "Completed processing of compliance report for all devices - $date.\n";

# Data Center 1 Report
print "Processing compliance report for DC1 data center...\n";

`$dirname/check-cisco-configs.pl $device_dir/dc1_device_list.txt >$report_dir/dc1/cisco_remediation-dc1-$report_date.csv`;
`/bin/chmod 644 $report_dir/dc1/cisco_remediation-dc1-$report_date.csv`;
`/bin/chgrp users $report_dir/dc1/cisco_remediation-dc1-$report_date.csv`;
print "Completed processing of compliance report for DC1 devices - $date.\n";

# Data Center 2 Report
print "Processing compliance report for DC2 data center...\n";

`$dirname/check-cisco-configs.pl $device_dir/dc2_device_list.txt >$report_dir/dc2/cisco_remediation-dc2-$report_date.csv`;
`/bin/chmod 644 $report_dir/dc2/cisco_remediation-dc2-$report_date.csv`;
`/bin/chgrp users $report_dir/dc2/cisco_remediation-dc2-$report_date.csv`;
print "Completed processing of compliance report for DC2 devices - $date.\n";

# All Prod devices Report
print "Processing compliance report for Production devices...\n";

`$dirname/check-cisco-configs.pl $device_dir/prod_device_list.txt >$report_dir/prod/cisco_remediation-prod-$report_date.csv`;
`/bin/chmod 644 $report_dir/prod/cisco_remediation-prod-$report_date.csv`;
`/bin/chgrp users $report_dir/prod/cisco_remediation-prod-$report_date.csv`;
print "Completed processing of compliance report for all Prod devices - $date.\n";

print "Completed processing of all compliance reports - $date.\n";
