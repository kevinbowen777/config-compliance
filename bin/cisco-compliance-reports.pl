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
# Updated: 20190919
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

# All Data Centers Report
print "Processing compliance report for all data centers...\n";

`$dirname/check-cisco-configs.pl >$report_dir/cisco_remediation-all-$report_date.csv`;
`/bin/chmod 644 $report_dir/cisco_remediation-all-$report_date.csv`;
`/bin/chgrp users $report_dir/cisco_remediation-all-$report_date.csv`;

print "Completed processing of compliance report.\n";
# Data Center 1 Report
# `$dirname/cisco-compliance_report.pl >$report_dir/cisco_remediation-dc1-$report_date.csv`;
# `/bin/chmod 644 $report_dir/cisco_remediation-dc1-$report_date.csv`;
# `/bin/chgrp users $report_dir/cisco_remediation-dc1-$report_date.csv`;

# Data Center 2 Report
# `$dirname/cisco-compliance_report.pl >$report_dir/cisco_remediation-dc2-$report_date.csv`;
# `/bin/chmod 644 $report_dir/cisco_remediation-dc2-$report_date.csv`;
# `/bin/chgrp users $report_dir/cisco_remediation-dc2-$report_date.csv`;

# All Dev devices Report
# `$dirname/cisco-compliance_report.pl >$report_dir/cisco_remediation-prod-$report_date.csv`;
# `/bin/chmod 644 $report_dir/cisco_remediation-prod-$report_date.csv`;
# `/bin/chgrp users $report_dir/cisco_remediation-prod-$report_date.csv`;

# All Mgmt Devices
# `$dirname/cisco-compliance_report.pl >$report_dir/cisco_remediation-corp-$report_date.csv`;
# `/bin/chmod 644 $report_dir/cisco_remediation-corp-$report_date.csv`;
# `/bin/chgrp users $report_dir/cisco_remediation-corp-$report_date.csv`;
