#!/usr/bin/perl
# -------------------------------------------------------------------------- #
#
# Name: smartsnx_1.13.pl
# Purpose: This script checks configurations in /tftpboot direction
# for NXOS v1.00 policy violations
# Compatible:
# Requirements:
#
# Version: 1.0
# Author: Kevin Bowen kevin.bowen@gmail.com
# 
# Original source:
# Updated: 20170210
#
# -------------------------------------------------------------------------- 
#
#Load Libraries
use FindBin;
use lib "$FindBin::Bin/../lib";;
use ioslib;
use POSIX qw(strftime);
use File::stat;

$date = strftime "%m/%d/%y",localtime;

#Command line input
my ($file) = @ARGV;

#Open config file
open $FILE, "/tftpboot/$file-confg" or die "file not found $file";

#File timestamp
$timestamp = stat($FILE)->mtime;
$timestamp = strftime "%m/%d/%y",localtime($timestamp);

#Dump config into $config
while (<$FILE>) { $config .= $_ }
close $FILE;

my $diff ="";

my $output ="$file,";

my @int_list = &interface_list($config);

#Policy 1 TACACS
$diff1 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy1.txt"),$config);
$output1 = &pass_check($diff1);
$diff1 = &strip_comments($diff1);
print "$date,$timestamp,$file,NXOS,1 - TACACS,$output1$diff1\n";

#Policy 2 AAA Configuration
$diff2 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy2.txt"),$config);
$output2 = &pass_check($diff2);
$diff2 = &strip_comments($diff2);
print "$date,$timestamp,$file,NXOS,2 - AAA,$output2$diff2\n";

#Policy 3 Management
$diff3 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy3.txt"),$config);
$output3 = &pass_check($diff3);
$diff3 = &strip_comments($diff3);
print "$date,$timestamp,$file,NXOS,3 - MGMT,$output3$diff3\n";

#Policy 4 Default route for mgmt
$diff4 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy4.txt"),$config);
$output4 = &pass_check($diff4);
$diff4 = &strip_comments($diff4);
print "$date,$timestamp,$file,NXOS,4 - MGMT Routing,$output4$diff4\n";

#Policy 5 NTP
$diff5 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy5.txt"),$config);
$output5 = &pass_check($diff5);
$diff5 = &strip_comments($diff5);
print "$date,$timestamp,$file,NXOS,5 - NTP,$output5$diff5\n";

#Policy 7 DNS
$diff7 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy7.txt"),$config);
$output7 = &pass_check($diff7);
$diff7 = &strip_comments($diff7);
print "$date,$timestamp,$file,NXOS,6 - DNS,$output7$diff7\n";

#Policy 8 SNMP Authorization
$diff8 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy8.txt"),$config);
$output8 = &pass_check($diff8);
$diff8 = &strip_comments($diff8);
print "$date,$timestamp,$file,NXOS,8 - SNMP AUTH,$output8$diff8\n";

#Policy 9 SNMP Configuration
$diff9 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy9.txt"),$config);
$output9 = &pass_check($diff9);
$diff9 = &strip_comments($diff9);
print "$date,$timestamp,$file,NXOS,9 - SNMP CFG,$output9$diff9\n";

#Policy 10 Identity Configuration
$diff10 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy10.txt"),$config);
$output10 = &pass_check($diff10);
$diff10 = &strip_comments($diff10);
print "$date,$timestamp,$file,NXOS,10 - IDENTITY,$output10$diff10\n";

#Policy 11 Banner
$diff11 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy11.txt"),$config);
$output11 = &pass_check($diff11);
$diff11 = &strip_comments($diff11);
print "$date,$timestamp,$file,NXOS,11 - BANNER,$output11$diff11\n";

#Policy 12 SSH
$diff12 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy12.txt"),$config);
$output12 = &pass_check($diff12);
$diff12 = &strip_comments($diff12);
print "$date,$timestamp,$file,NXOS,12 - SSH,$output12$diff12\n";

#Policy 13 Boot Commands
$diff13 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy13.txt"),$config);
$output13 = &pass_check($diff13);
$diff13 = &strip_comments($diff13);
print "$date,$timestamp,$file,NXOS,13 - BOOT,$output13$diff13\n";

#Policy 14 Loopback commands
$diff14 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy14a.txt"),$config);
$diff14 .= &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy14b.txt"),$config);
$output14 = &pass_check($diff14);
$diff14 = &strip_comments($diff14);
print "$date,$timestamp,$file,NXOS,14 - LOOPBACK,$output14$diff14\n";

#Policy 15 Int Security
$diff15 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy15.txt"),$config);
$output15 = "PASS,";
$diff15 = &strip_comments($diff15);
print "$date,$timestamp,$file,NXOS,15 - INT SEC,$output15$diff15\n";

#Policy 16 Rapid ACL
$diff16 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy16.txt"),$config);
$output16 = "PASS,";
$diff16 = &strip_comments($diff16);
print "$date,$timestamp,$file,NXOS,16 - RAPID ACL,$output16$diff16\n";

#Policy 17 SNMP Logging
$diff17 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy17.txt"),$config);
$output17 = "PASS,";
$diff17 = &strip_comments($diff17);
print "$date,$timestamp,$file,NXOS,17 - SNMP LOG,$output17$diff17\n";

## Policy 18 Interface Description
$diff18 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy18.txt"),$config);
$output18 = "PASS,";
$diff18 = &strip_comments($diff18);
print "$date,$timestamp,$file,NXOS,18 - INT DESCR,$output18$diff18\n";

## Policy 19 Interface Security
$diff19 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/nexus1.13/policy19.txt"),$config,@int_list);
$output19 .= &pass_check($diff19);
$output19 ="PASS,";
$diff19 = &strip_comments($diff19);
print "$date,$timestamp,$file,NXOS,19 - INT SEC,$output19$diff19\n";

## Policy 20 IP Security
$diff20 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/nexus1.13/policy19.txt"),$config,@int_list);
$output20 ="PASS,";
$diff20 = &strip_comments($diff20);
print "$date,$timestamp,$file,NXOS,20 - IP SEC,$output20$diff20\n";

## Policy 21 Logging
$diff21 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/nexus1.13/policy19.txt"),$config,@int_list);
$output21 ="PASS,";
$diff21 = &strip_comments($diff21);
print "$date,$timestamp,$file,NXOS,21 - LOGGING,$output21$diff21\n";

## Policy 22 Line Console
$diff22 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy22.txt"),$config);
$output22 = &pass_check($diff22);
$diff22 = &strip_comments($diff22);
print "$date,$timestamp,$file,NXOS,22 - CONSOLE,$output22$diff22\n";

## Policy 23 Line VTY
$diff23 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy23a.txt"),$config);
$diff23 .= &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/nexus1.13/policy23b.txt"),$config);
$output23 = &pass_check($diff23);
$diff23 = &strip_comments($diff23);
print "$date,$timestamp,$file,NXOS,23 - VTY,$output23$diff23\n";

## Policy 24 CoPP Policy
$diff24 = &ios_config_acls(&open_file("/scripts/configcheck/policies/nexus1.13/policy26.txt"),$config);
$output24 = &pass_check($diff24);
$diff24 = &strip_comments($diff24);
print "$date,$timestamp,$file,NXOS,24 - COPP,$output24$diff24\n";

## Policy 25 Logging
$diff25 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/nexus1.13/policy25.txt"),$config,@int_list);
$output25 ="PASS,";
$diff25 = &strip_comments($diff25);
print "$date,$timestamp,$file,NXOS,25 - MULTICAST,$output25$diff25\n";

## Policy 27 BPDUGUARD
$diff27 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/nexus1.13/policy_27-enterprise-nxos_bpduguard_configuration.txt"),$config,@int_list);
$output27 ="PASS,";
$diff27 = &strip_comments($diff27);
print "$date,$timestamp,$file,NXOS,27 - BPDUGUARD,$output27$diff27\n";

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
