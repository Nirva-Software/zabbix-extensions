#!/bin/bash
# Author: Lesovsky A.V.
# Modified: Martin L.
# Adapters auto-discovery via MegaCLI. VERY VERY EXPERIMENTAL (TESTED ON MEGACLI 4.00.11 February 06, 2009)

MEGACLI=/sbin/MegaCli

adp_list=$(sudo $MEGACLI -AdpAllInfo -aALL -NoLog |grep "^Adapter #" |cut -d# -f2)

if [[ $1 = raw ]]; then
  for adp in ${adp_list}; do echo $adp; done ; exit 0
fi

echo -n '{"data":['
for adp in $adp_list; do echo -n "{\"{#ADPNUM}\": \"$adp\"},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
