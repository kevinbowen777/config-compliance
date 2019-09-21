#!/usr/bin/perl
# {{{ ----------------------------------------------------------------------- #
#
# Name: smartsnx_1.2.1.pl
# Purpose: This script checks configurations in ../devices direction
# for NX-OS v1.00 policy violations
# Compatible:
# Requirements:
#
# Version: 1.2.1
# Author: Kevin Bowen kevin.bowen@gmail.com
# 
# Original source:
# Updated: 20190919
#
# }}}----------------------------------------------------------------------- # 

use FindBin;
use lib "$FindBin::Bin/../lib";;
use ioslib;
use POSIX qw(strftime);
use File::stat;

$date = strftime "%m/%d/%y",localtime;
$policy_dir = "../policies/nx-os";

#Command line input
my ($file) = @ARGV;

#Open config file
open $FILE, "../devices/$file" or die "file not found $file";

#File timestamp
$timestamp = stat($FILE)->mtime;
$timestamp = strftime "%m/%d/%y",localtime($timestamp);

#Dump config into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $diff ="";

my $output ="$file,";

my @int_list = &interface_list($config);

# Policy 01 - NX-OS AAA Configuration
$diff1 = &ios_config_global_lines(&open_file("$policy_dir/policy_01_NX-OS_AAA"),$config);
$output1 = &pass_check($diff1);
$diff1 = &strip_comments($diff1);
print "$date,$timestamp,$file,NX-OS,01 - AAA,$output1$diff1\n";

# Policy 02 - NX-OS TACACS Configuration
$diff2 = &ios_config_global_lines(&open_file("$policy_dir/policy_02_NX-OS_TACACS"),$config);
$output2 = &pass_check($diff2);
$diff2 = &strip_comments($diff2);
print "$date,$timestamp,$file,NX-OS,02 - TACACS,$output2$diff2\n";

# Policy 03 - NX-OS MGMT Interface
$diff3 = &ios_config_nested_lines(&open_file("$policy_dir/policy_03_NX-OS_MGMT_Interface"),$config);
$output3 = &pass_check($diff3);
$diff3 = &strip_comments($diff3);
print "$date,$timestamp,$file,NX-OS,03 - MGMT Interface,$output3$diff3\n";

# Policy 04 - NX-OS MGMT Default Route 
$diff4 = &ios_config_nested_lines(&open_file("$policy_dir/policy_04_NX-OS_MGMT_Routing"),$config);
$output4 = &pass_check($diff4);
$diff4 = &strip_comments($diff4);
print "$date,$timestamp,$file,NX-OS,04 - MGMT Routing,$output4$diff4\n";

# Policy 05 - NX-OS NTP
$diff5 = &ios_config_global_lines(&open_file("$policy_dir/policy_05_NX-OS_NTP"),$config);
$output5 = &pass_check($diff5);
$diff5 = &strip_comments($diff5);
print "$date,$timestamp,$file,NX-OS,05 - NTP,$output5$diff5\n";

# Policy 06 - NX-OS NTPConf
$diff6 = &ios_config_global_lines(&open_file("$policy_dir/policy_06_NX-OS_NTPConf"),$config);
$output6 = &pass_check($diff6);
$diff6 = &strip_comments($diff6);
print "$date,$timestamp,$file,NX-OS,06 - NTPConf,$output6$diff6\n";

# Policy  07 - NX-OS MGMT NTP
$diff7 = &ios_config_global_lines(&open_file("$policy_dir/policy_07_NX-OS_MGMT_NTP"),$config);
$output7 = &pass_check($diff7);
$diff7 = &strip_comments($diff7);
print "$date,$timestamp,$file,NX-OS,07 - MGMT NTP,$output7$diff7\n";

# Policy 08 - NX-OS DNS
$diff8 = &ios_config_global_lines(&open_file("$policy_dir/policy_08_NX-OS_DNS"),$config);
$output8 = &pass_check($diff8);
$diff8 = &strip_comments($diff8);
print "$date,$timestamp,$file,NX-OS,08 - DNS,$output8$diff8\n";

# Policy 09 - NX-OS SNMP ACL
$diff9 = &ios_config_global_lines(&open_file("$policy_dir/policy_09_NX-OS_SNMP_ACL"),$config);
$output9 = &pass_check($diff9);
$diff9 = &strip_comments($diff9);
print "$date,$timestamp,$file,NX-OS,09 - SNMP ACL,$output9$diff9\n";

# Policy 10 - NX-OS SNMP
$diff10 = &ios_config_global_lines(&open_file("$policy_dir/policy_10_NX-OS_SNMP"),$config);
$output10 = &pass_check($diff10);
$diff10 = &strip_comments($diff10);
print "$date,$timestamp,$file,NX-OS,10 - SNMP,$output10$diff10\n";

# Policy 11 - NX-OS SNMP Identity
$diff11 = &ios_config_global_lines(&open_file("$policy_dir/policy_11_NX-OS_SNMP_Identity"),$config);
$output11 = &pass_check($diff11);
$diff11 = &strip_comments($diff11);
print "$date,$timestamp,$file,NX-OS,11 - SNMP Identity,$output11$diff11\n";

# Policy 12  - NX-OS Banner
$diff12 = &ios_config_global_lines(&open_file("$policy_dir/policy_12_NX-OS_Banner"),$config);
$output12 = &pass_check($diff12);
$diff12 = &strip_comments($diff12);
print "$date,$timestamp,$file,NX-OS,12 - Banner,$output12$diff12\n";

# Policy 13 - NX-OS SSH
$diff13 = &ios_config_global_lines(&open_file("$policy_dir/policy_13_NX-OS_SSH"),$config);
$output13 = &pass_check($diff13);
$diff13 = &strip_comments($diff13);
print "$date,$timestamp,$file,NX-OS,13 - SSH,$output13$diff13\n";

# Policy 14 - NX-OS SNMPv3 Configuration 
$diff14 .= &ios_config_global_lines(&open_file("$policy_dir/policy_14_NX-OS_SNMPv3"),$config);
$output14 = &pass_check($diff14);
$diff14 = &strip_comments($diff14);
print "$date,$timestamp,$file,NX-OS,14 - SNMPv3,$output14$diff14\n";

# Policy 15 - NX-OS Basic Services
$diff15 = &ios_config_global_lines(&open_file("$policy_dir/policy_15_NX-OS_Basic_Services"),$config);
$output15 = "PASS,";
$diff15 = &strip_comments($diff15);
print "$date,$timestamp,$file,NX-OS,15 - Basic Services,$output15$diff15\n";

# Policy 16 - NX-OS Boot System
$diff16 = &ios_config_global_lines(&open_file("$policy_dir/policy_16_NX-OS_Boot_System"),$config);
$output16 = "PASS,";
$diff16 = &strip_comments($diff16);
print "$date,$timestamp,$file,NX-OS,16 - Boot System,$output16$diff16\n";

# Policy 17 - NX-OS RCMD
$diff17 = &ios_config_global_lines(&open_file("$policy_dir/policy_17_NX-OS_RCMD"),$config);
$output17 = "PASS,";
$diff17 = &strip_comments($diff17);
print "$date,$timestamp,$file,NX-OS,17 - RCMD,$output17$diff17\n";

# Policy 18 - NX-OS Loopback
$diff18 = &ios_config_global_lines(&open_file("$policy_dir/policy_18_NX-OS_Loopback"),$config);
$output18 = "PASS,";
$diff18 = &strip_comments($diff18);
print "$date,$timestamp,$file,NX-OS,18 - Loopback,$output18$diff18\n";

# Policy 19 - NX-OS IP Security
$diff19 = &ios_config_global_lines(&open_file("$policy_dir/policy_19_NX-OS_IP_Security"),$config);
$output19 .= &pass_check($diff19);
$output19 ="PASS,";
$diff19 = &strip_comments($diff19);
print "$date,$timestamp,$file,NX-OS,19 - IP Security,$output19$diff19\n";

# Policy 20 - NX-OS Source Route
$diff20 = &ios_config_global_lines(&open_file("$policy_dir/policy_20_NX-OS_Source_Route"),$config);
$output20 ="PASS,";
$diff20 = &strip_comments($diff20);
print "$date,$timestamp,$file,NX-OS,20 - Source Route,$output20$diff20\n";

# Policy 21 - NX-OS SNMP Trap
$diff21 = &ios_config_global_lines(&open_file("$policy_dir/policy_21_NX-OS_SNMP_TRAP"),$config);
$output21 ="PASS,";
$diff21 = &strip_comments($diff21);
print "$date,$timestamp,$file,NX-OS,21 - SNMP Trap,$output21$diff21\n";

# Policy 22 - NX-OS Interface Description
$diff22 = &ios_config_global_lines(&open_file("$policy_dir/policy_22_NX-OS_Interface_Description"),$config);
$output22 = &pass_check($diff22);
$diff22 = &strip_comments($diff22);
print "$date,$timestamp,$file,NX-OS,22 - Interface Description,$output22$diff22\n";

# Policy 23 - NX-OS CoPP Policy
$diff23 = &ios_config_global_lines(&open_file("$policy_dir/policy_23_NX-OS_CoPP"),$config);
# $diff23 .= &ios_config_nested_lines(&open_file("$policy_dir/policy_23_NX-OS_Copp"),$config);
$output23 = &pass_check($diff23);
$diff23 = &strip_comments($diff23);
print "$date,$timestamp,$file,NX-OS,23 - CoPP,$output23$diff23\n";

# Policy 24 - NX-OS Logging
# $diff24 = &ios_config_acls(&open_file("$policy_dir/policy_24"),$config);
$diff24 = &ios_config_global_lines(&open_file("$policy_dir/policy_24_NX-OS_Logging"),$config);
$output24 = &pass_check($diff24);
$diff24 = &strip_comments($diff24);
print "$date,$timestamp,$file,NX-OS,24 - Logging,$output24$diff24\n";

# Policy 25 - NX-OS VTP
# $diff25 = &ios_config_all_interfaces(&open_file("$policy_dir/policy25"),$config,@int_list);
$diff25 = &ios_config_global_lines(&open_file("$policy_dir/policy_25_NX-OS_VTP"),$config);
$output25 ="PASS,";
$diff25 = &strip_comments($diff25);
print "$date,$timestamp,$file,NX-OS,25 - VTP,$output25$diff25\n";

# Policy 26 - NX-OS BPDUGuard
# $diff26 = &ios_config_all_interfaces(&open_file("$policy_dir/policy_26_NX-OS_BPDUGuard"),$config,@int_list);
$diff26 = &ios_config_global_lines(&open_file("$policy_dir/policy_26_NX-OS_BPDUGuard"),$config);
$output26 ="PASS,";
$diff26 = &strip_comments($diff26);
print "$date,$timestamp,$file,NX-OS,26 - BPDUGuard,$output26$diff26\n";

# Policy 27 - NX-OS BPDUGuard Default
$diff27 = &ios_config_global_lines(&open_file("$policy_dir/policy_27_NX-OS_BPDUGuard_Default"),$config);
$output27 ="PASS,";
$diff27 = &strip_comments($diff27);
print "$date,$timestamp,$file,NX-OS,27 - BPDUGuard Default,$output27$diff27\n";

sub strip_comments {

        my $new_config = shift or die;

        #separate the config commands from the comments in the new config
	my $config = "";
        foreach my $line (split(/\n/, $new_config)) {
                if ($line =~ s/^\s*(!)/$1/) {
		} else{
                        $config .= "$line\n";
                }
        }
	
	$config =~ s{P3nc1lB0x}{<redacted>};
	$config =~ tr{\n}{ };
        return "$config";
}
