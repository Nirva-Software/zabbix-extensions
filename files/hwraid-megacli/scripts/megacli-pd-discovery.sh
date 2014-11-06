#!/bin/bash
# Author: Lesovsky A.V.
# Modified: Martin L.
# Physical drives auto-discovery. VERY VERY EXPERIMENTAL (TESTED ON MEGACLI 4.00.11 February 06, 2009)

MEGACLI=/sbin/MegaCli

if [[ $1 = raw ]]; then
	adp_list=$2
else
	adp_list=$(sudo $MEGACLI -AdpAllInfo -aALL -NoLog |grep "^Adapter #" |cut -d# -f2)
fi
enc_list=$(for a in $adp_list; do sudo $MEGACLI -EncInfo -a$a -NoLog |grep -w "Device ID" |awk '{print $4}'; done)
pd_list=$(for a in $adp_list; 
            do
              for e in $enc_list; 
                do 
                  sudo $MEGACLI -PDList -a$a -NoLog |sed -n -e "/Enclosure Device ID: $e/,/Slot Number:/p" |grep -wE 'Slot Number:' |awk -v adp=$a -v enc=$e '{print adp":"enc":"$3}' 
                done
            done)

if [[ $1 = raw ]]; then
  for pd in ${pd_list}; do echo $pd; done ; exit 0
fi

echo -n '{"data":['
for pd in $pd_list; do echo -n "{\"{#PD}\": \"$pd\"},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
