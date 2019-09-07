#!/bin/bash

#admin_file=`ls -lht /home/ubuntu/scumlogs/ | grep admin | tail -1 | awk '{print $9}'`
admin_file=admin
string=Command
DATE=`date +%Y%m%d`
tail -n0 -F /home/ubuntu/scumlogs/$admin_file | \
while read LINE
do
  if echo "$LINE" | grep "$string" 1>/dev/null 2>&1
  then
          cp /tmp/default_admin_line /tmp/admin_line
          sed -i "s/LINE/$LINE/g" /tmp/admin_line
          curl -H Content-Type:application/json -X POST -d @/tmp/admin_line https://discordapp.com/api/webhooks/_RESTOFHOOKURL_
          cp /tmp/default_admin_line /tmp/admin_line
          sleep 5
  fi
done


