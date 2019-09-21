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

use POSIX qw(strftime);

$report_date = strftime "%Y%m%d",localtime;

# All Data Centers Report
print "Printing all data centers compliance report...\n";

`check-cisco-configs.pl >../reports/cisco_remediation-all-$report_date.csv`;
`/bin/chmod 644 ../reports/cisco_remediation-all-$report_date.csv`;
`/bin/chgrp users ../reports/cisco_remediation-all-$report_date.csv`;

# Data Center 1 Report
# `cisco-compliance_report.pl >../reports/cisco_remediation-dc1-$report_date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-dc1-$report_date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-dc1-$report_date.csv`;

# Data Center 2 Report
# `cisco-compliance_report.pl >../reports/cisco_remediation-dc2-$report_date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-dc2-$report_date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-dc2-$report_date.csv`;

# All Dev devices Report
# `cisco-compliance_report.pl >../reports/cisco_remediation-prod-$report_date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-prod-$report_date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-prod-$report_date.csv`;

# All Mgmt Devices
# `cisco-compliance_report.pl >../reports/cisco_remediation-corp-$report_date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-corp-$report_date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-corp-$report_date.csv`;
