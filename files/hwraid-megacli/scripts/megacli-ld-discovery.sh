#!/bin/bash
# Author: Lesovsky A.V.
# Modified: Martin L.
# Logical drives auto-discovery via MegaCLI. VERY VERY EXPERIMENTAL (TESTED ON MEGACLI 4.00.11 February 06, 2009)

MEGACLI=/sbin/MegaCli

if [[ $1 = raw ]]; then
	adp_list=$2
else
	adp_list=$(sudo $MEGACLI -AdpAllInfo -aALL -NoLog |grep "^Adapter #" |cut -d# -f2)
fi
ld_list=$(for a in $adp_list; do sudo $MEGACLI -LDInfo -Lall -a$a -NoLog |grep -w "^Virtual Disk:" |awk '{print $3}' |while read ld ; do echo $a:$ld; done ; done)

if [[ $1 = raw ]]; then
  for ld in ${ld_list}; do echo $ld; done ; exit 0
fi

echo -n '{"data":['
for ld in $ld_list; do echo -n "{\"{#LD}\": \"$ld\"},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
