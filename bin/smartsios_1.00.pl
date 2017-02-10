#!/usr/bin/perl
# -------------------------------------------------------------------------- #
#
# Name: smartsios_4.966.pl
# Purpose: This script checks configurations in /tftpboot direction for IOS v4.966 policy violations
# Compatible:
# Requirements:
#
# Version: 1.0
# Author: Kevin Bowen kevin.bowen@disney.com
# 
# Original source:
# Updated: 05062015
# Changelog:
# 20150903_01 BSJ Comment out Policy 27, per conversation with Scott Teza
# 20151030_01 BSJ Comment out Policy 6, per email from Scott Teza
# -------------------------------------------------------------------------- 
#
#Load Libraries
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

$output ="$file,";

my @int_list = &interface_list($config);

#Policy 1 AAA Configuration
$diff1 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy1.txt"),$config);
$output1 = &pass_check($diff1);
$diff1 = &strip_comments($diff1);
print "$date,$timestamp,$file,IOS,1 - AAA,$output1$diff1\n";

#Policy 2 Tacacs Configuration
$diff2 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy2.txt"),$config);
$output2 = &pass_check($diff2);
$diff2 = &strip_comments($diff2);
print "$date,$timestamp,$file,IOS,2 - TACACS,$output2$diff2\n";

#Policy 3 Line Console
$diff3 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy3.txt"),$config);
$output3 = &pass_check($diff3);
$diff3 = &strip_comments($diff3);
print "$date,$timestamp,$file,IOS,3 - CONSOLE,$output3$diff3\n";

#Policy 4 Line Aux
$diff4 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy4.txt"),$config);
if($diff4 =~ /does not exist/mi){
 $output4= "PASS,";
 $diff4="";
}else{
 $output4 = &pass_check($diff4);
 $diff4 = &strip_comments($diff4);
}
print "$date,$timestamp,$file,IOS,4 - AUX,$output4$diff4\n";

#Policy 5 VTY
$diff5 = &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy5a.txt"),$config);
$diff5 .= &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy5b.txt"),$config);
$output5 = &pass_check($diff5);
$diff5 = &strip_comments($diff5);
print "$date,$timestamp,$file,IOS,5 - VTY,$output5$diff5\n";

#Policy 6 NTP Configuration
#$diff6 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy6.txt"),$config);
#$output6 = &pass_check($diff6);
#$diff6 = &strip_comments($diff6);
#print "$date,$timestamp,$file,IOS,6 - NTP,$output6$diff6\n";

#Policy 7
#$diff7 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy8.txt"),$config);
#$output7 ="PASS,";
#$diff7 =~ tr{\n}{ };
#$diff7 = &strip_comments($diff7);
#print "$date,$file,IOS,7 - $output7$diff7\n";

#Policy 8 DNS
$diff8 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy8.txt"),$config);
$output8 = &pass_check($diff8);
$diff8 = &strip_comments($diff8);
print "$date,$timestamp,$file,IOS,8 - DNS,$output8$diff8\n";

#Policy 9 SNMP ACL Configuration
$diff9 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy9.txt"),$config);
$output9 = &pass_check($diff9);
$diff9 = &strip_comments($diff9);
print "$date,$timestamp,$file,IOS,9 - SNMP ACL,$output9$diff9\n";

#Policy 10 Snmp Configuration
$diff10 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy10.txt"),$config);
$output10 = &pass_check($diff10);
$diff10 = &strip_comments($diff10);
print "$date,$timestamp,$file,IOS,10 - SNMP,$output10$diff10\n";

#Policy 11 Identity information\n";
$diff11 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy11.txt"),$config);
$output11 = &pass_check($diff11);
$diff11 = &strip_comments($diff11);
print "$date,$timestamp,$file,IOS,11 - SNMP INFO,$output11$diff11\n";

#Policy 12 Banner login\n";
$diff12 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy12.txt"),$config);
$output12 = &pass_check($diff12);
$diff12 = &strip_comments($diff12);
print "$date,$timestamp,$file,IOS,12 - BANNER,$output12$diff12\n";

#Policy 13 SSH Configuration\n";
$diff13 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy13a.txt"),$config);
$diff13 .= &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy13b.txt"),$config);
$diff13 .= &ios_config_nested_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy13c.txt"),$config);
$output13 = &pass_check($diff13);
$diff13 = &strip_comments($diff13);
print "$date,$timestamp,$file,IOS,13 - SSH,$output13$diff13\n";

#Policy 14 vstack
if ($config =~ /switch 1 provision/i){
 $diff14 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy14.txt"),$config);
 $diff14 = &strip_comments($diff14);
 $output14 = &pass_check($diff14);
}else{
 $diff14 = "";
 $output14 ="PASS,";
}
print "$date,$timestamp,$file,IOS,14 - VSTACK,$output14$diff14\n";

#Policy 15 Basic Services
$diff15 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy15.txt"),$config);
$output15 = &pass_check($diff15);
$diff15 = &strip_comments($diff15);
print "$date,$timestamp,$file,IOS,15 - BASIC SVCS,$output15$diff15\n";

#Policy 16 Boot System Flash
$diff16 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy16.txt"),$config);
$output16 = &pass_check($diff16);
$diff16 = &strip_comments($diff16);
print "$date,$timestamp,$file,IOS,16 - BOOT,$output16$diff16\n";

#Policy 17 RCMD
#$diff17 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy17.txt"),$config);
#$output17 = &pass_check($diff17);
#$diff17 = &strip_comments($diff17);
#print "$date,$file,IOS,17 - RCMD,$output17$diff17\n";

## Policy 18 Loopbacks
if ($config =~ /interface Loopback0/im && $file !~ /-sw/){
 $diff18 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy18.txt"),$config);
 $output18 = &pass_check($diff18);
 $diff18 = &strip_comments($diff18);
}else{
 $output18 ="PASS,";
}
print "$date,$timestamp,$file,IOS,18 - LOOPBACK,$output18$diff18\n";

## Policy 19 Interface Security
$diff119 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/ios4.96/policy19.txt"),$config,@int_list);
$output119 .= &pass_check($diff119);
$output19 ="PASS,";
$diff119 = &strip_comments($diff119);
print "$date,$timestamp,$file,IOS,19 - INT SEC,$output19$diff19\n";

## Policy 20 Interface ACL 
$diff120 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/ios4.96/policy19.txt"),$config,@int_list);
$output20 ="PASS,";
$diff120 = &strip_comments($diff120);
print "$date,$timestamp,$file,IOS,20 - INTACL,$output20$diff20\n";

## Policy 21 Interface Logging
$diff121 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/ios4.96/policy19.txt"),$config,@int_list);
$output21 ="PASS,";
$diff121 = &strip_comments($diff121);
print "$date,$timestamp,$file,IOS,21 - INTLOG,$output21$diff21\n";

## Policy 22 Interface Description
$diff122 = &ios_config_all_interfaces(&open_file("/scripts/configcheck/policies/ios4.96/policy19.txt"),$config,@int_list);
$output22 ="PASS,";
$diff122 = &strip_comments($diff122);
print "$date,$timestamp,$file,IOS,22 - DESCR,$output22$diff22\n";

## Policy 23 IP Security
$diff23 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy23.txt"),$config);
$output23 = &pass_check($diff23);
$diff23 = &strip_comments($diff23);
print "$date,$timestamp,$file,IOS,23 - SECURITY,$output23$diff23\n";

## Policy 24 Logging
$diff24 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy24.txt"),$config);
$output24 = &pass_check($diff24);
$diff24 = &strip_comments($diff24);
print "$date,$timestamp,$file,IOS,24 - LOGGING,$output24$diff24\n";

## Policy 25 VTP
$diff25 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy25.txt"),$config);
$output25 = &pass_check($diff25);
$diff25 = &strip_comments($diff25);
print "$date,$timestamp,$file,IOS,25 - VTP,$output25$diff25\n";

## Policy 26 BPDUGUARD
$diff26 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy_26-enterprise-ios_bpduguard_configuration.txt"),$config);
$output26 = &pass_check($diff26);
$diff26 = &strip_comments($diff26);
print "$date,$timestamp,$file,IOS,26 - BPDUGUARD,$output26$diff26\n";

# Change 20150903_01
## Policy 27 BPDUGUARD DEFAULT
#$diff27 = &ios_config_global_lines(&open_file("/scripts/configcheck/policies/ios4.96/policy_27-enterprise-ios_bpduguard_default_configuration.txt"),$config);
#$output27 = &pass_check($diff27);
#$diff27 = &strip_comments($diff27);
#print "$date,$timestamp,$file,IOS,27 - BPDUGUARD-DEFAULT,$output27$diff27\n";

sub strip_comments {

        my $new_config = shift or die;

        #separate the config commands from the comments in the new config
	my $config = "";
        foreach my $line (split(/\n/, $new_config)) {
                if ($line =~ s/^\s*(!)/$1/) {
                  #nothing
		}else{
                        $config .= "$line\n";
                }
        }
	
	$config =~ s{P3nc1lB0x}{<redacted>};
	$config =~ s{N3w$Pap3r}{<redacted>};
	$config =~ tr{\n}{ };
        return "$config";
}
