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

$date = strftime "%m%d%y",localtime;

# All Data Centers Report
`check-cisco-configs.pl >../reports/cisco_remediation-all-$date.csv`;
`/bin/chmod 644 ../reports/cisco_remediation-all-$date.csv`;
`/bin/chgrp users ../reports/cisco_remediation-all-$date.csv`;

# Data Center 1 Report
# `cisco-compliance_report.pl >../reports/cisco_remediation-dc1-$date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-dc1-$date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-dc1-$date.csv`;

# Data Center 2 Report
# `cisco-compliance_report.pl >../reports/cisco_remediation-dc2-$date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-dc2-$date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-dc2-$date.csv`;

# All Dev devices Report
# `cisco-compliance_report.pl >../reports/cisco_remediation-prod-$date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-prod-$date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-prod-$date.csv`;

# All Mgmt Devices
# `cisco-compliance_report.pl >../reports/cisco_remediation-corp-$date.csv`;
# `/bin/chmod 644 ../reports/cisco_remediation-corp-$date.csv`;
# `/bin/chgrp localusr ../reports/cisco_remediation-corp-$date.csv`;
