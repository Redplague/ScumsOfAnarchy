#!/bin/bash

#admin_file=`ls -lht /home/ubuntu/scumlogs/ | grep admin | tail -1 | awk '{print $9}'`
admin_file=login
string=logg
DATE=`date +%Y%m%d`
tail -n0 -F /home/ubuntu/scumlogs/$admin_file | \
while read LINE
do
  if echo "$LINE" | grep "$string" 1>/dev/null 2>&1
  then
          cp /home/ubuntu/scumlogs/files/efault_login_line /home/ubuntu/scumlogs/files/ogin_line
          sed -i "s/LINE/$LINE/g" /home/ubuntu/scumlogs/files/login_line
          curl -H Content-Type:application/json -X POST -d @/home/ubuntu/scumlogs/files/login_line https://discordapp.com/api/webhooks/_APIURL_
          cp /home/ubuntu/scumlogs/files/default_login_line /home/ubuntu/scumlogs/files/login_line
          sleep 2
  fi
done
