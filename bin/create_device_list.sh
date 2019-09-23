#!/bin/bash

#{{{
# Author: Kevin Bowen <kevin.bowen@gmail.com>
# Script Name: create_device_list.sh
# Description:
#		  finds files in config-compliance directory and creates
#			a device list based on criteria in file name.
#
# Source : http://www.github.com/kevinbowen777/config-compliance.git
# Last modified: 20190922
# Dependencies:
#	None
#     
# ------------------------------------------------------------------
#}}}

cd "${BASH_SOURCE%/*}/../devices" || exit

show_help() {
	echo "  Create a device list for processing."
	echo "	Usage: create_device_list.sh -a|--all	- All devices."
	echo "	Usage: create_device_list.sh -c|--corp	- Corp devices."
	echo "	Usage: create_device_list.sh -d|--dev	- Dev devices."
	echo "	Usage: create_device_list.sh -dc1	- All DC1 devices."
	echo "	Usage: create_device_list.sh -dc2	- All DC2 devices."
	echo "	Usage: create_device_list.sh -h|--help	- prints this message"
	echo "	Usage: create_device_list.sh -m|--mgmt  - MGMT devices."
	echo "	Usage: create_device_list.sh -p|--prod  - PROD devices."
	}
if [ $# -eq 0 ]
then
	printf "Creating list of all devices in %s\n" "$PWD"; 
	for f in *; do
		[[ -e  $f ]] || continue
		find . -type f -iname "*.cfg" -printf %f'\n'>device_list.txt
	done

	exit
fi

case "$1" in
	-a|--all)
		printf "Creating list of all devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "*.cfg" -printf %f'\n'>device_list.txt
		done
		;;

	-c|--corp)
		printf "Creating list of Corp devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "*corp*.cfg" -printf %f'\n'>corp_device_list.txt
		done
		;;

	-d|--dev)
		printf "Creating list of Dev devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "*dev*.cfg" -printf %f'\n'>dev_device_list.txt
		done
				;;

	-dc1|--dc1)
		printf "Creating list of DC1 devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "dc1*.cfg" -printf %f'\n'>dc1_device_list.txt
		done
			;;

	-dc2|--dc2)
		printf "Creating list of DC2 devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "dc2*.cfg" -printf %f'\n'>dc2_device_list.txt
		done
			;;

	-h|-\?|--help)
		show_help	# Display a usage synopsis
		exit
		;;

	-m|--mgmt)
		printf "Creating list of MGMT devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "*mgmt*.cfg" -printf %f'\n'>mgmt_device_list.txt
		done
		;;

	-p|--prod)
		printf "Creating list of PROD devices in %s\n" "$PWD"; 
		for f in *; do
			[[ -e  $f ]] || continue
			find . -type f -iname "*prod*.cfg" -printf %f'\n'>prod_device_list.txt
		done
		;;
	 *)
		show_help	# Display a usage synopsis
		exit
		;;

esac
