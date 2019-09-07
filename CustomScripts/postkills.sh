#!/bin/bash

#admin_file=`ls -lht /home/ubuntu/scumlogs/ | grep admin | tail -1 | awk '{print $9}'`
string=Died
admin_file="kill"
DATE=`date +%Y%m%d`



tail -n0 -F /home/ubuntu/scumlogs/$admin_file | \
while read LINE
do
  if echo "$LINE" | grep -v "game event" | grep "$string" 1>/dev/null 2>&1
  then
          cp /tmp/default_kill_line /tmp/kill_line
          sed -i "s/LINE/$LINE/g" /tmp/kill_line
          curl -H Content-Type:application/json -X POST -d @/tmp/kill_line https://discordapp.com/api/webhooks/_RESTOFHOOKURL_
          cp /tmp/default_kill_line /tmp/kill_line
          sleep 5
  fi
done


