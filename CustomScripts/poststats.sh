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
	  KILL_STEAM_ID=`echo $LINE | cut -d "(" -f3 | cut -d ")" -f1`
	  DEATH_STEAM_ID=`echo $LINE | cut -d "(" -f2 | cut -d ")" -f1`
	  KILL_USER_EXISTS=`mysql -BNe "select steamid from scumlogs.stats where steamid = '$KILL_STEAM_ID' ;"`
	  DEATH_USER_EXISTS=`mysql -BNe "select steamid from scumlogs.stats where steamid = '$DEATH_STEAM_ID' ;"`
	  KILL_USER_NAME=`tail -300 /home/ubuntu/scumlogs/login | grep -m1 $KILL_STEAM_ID /home/ubuntu/scumlogs/login | grep -v 'logging out' | grep -v Game | awk '{ print $2,$3,$4,$5}'  | cut -d : -f2 | cut -d "'" -f1 | cut -d "(" -f1 | sort | uniq`
	  DEATH_USER_NAME=`tail -300 /home/ubuntu/scumlogs/login | grep -m1 $DEATH_STEAM_ID /home/ubuntu/scumlogs/login | grep -v 'logging out' | grep -v Game | awk '{ print $2,$3,$4,$5}'  | cut -d : -f2 | cut -d "'" -f1 | cut -d "(" -f1 | sort | uniq`
	  KDRATIO_UPDATE_DEATH=`mysql -BNe "select deaths from scumlogs.stats where steamid = '$DEATH_STEAM_ID' ;"`
	  KDRATIO_UPDATE_KILL=`mysql -BNe "select deaths from scumlogs.stats where steamid = '$KILL_STEAM_ID' ;"`
	  KDRATIO_NO_KILLS=`mysql -BNe "select kills from scumlogs.stats where steamid = '$KILL_STEAM_ID' ;"`
#          echo $KILL_STEAM_ID
#          echo $DEATH_STEAM_ID
#          echo $KILL_USER_EXISTS
#          echo $DEATH_USER_EXISTS


	  if [[ -z "$KILL_USER_EXISTS" ]];
	  then
		  `/usr/bin/mysql -e "insert into scumlogs.stats (steamid, name, kills, deaths, kdratio) VALUES ($KILL_STEAM_ID,'$KILL_USER_NAME',0,0,0);" `
		  `/usr/bin/mysql -e "update scumlogs.stats set kills = kills + 1 where steamid = '$KILL_STEAM_ID';"`
	  else
		  `/usr/bin/mysql -e "update scumlogs.stats set kills = kills + 1 where steamid = '$KILL_STEAM_ID';"`
                  if [[ $KDRATIO_UPDATE_KILL != '0' ]];
                  then
                          `/usr/bin/mysql -e "update scumlogs.stats set kdratio = kills / deaths where steamid = '$KILL_STEAM_ID'; "`
		  elif [[ $KDRATIO_UPDATE_KILL = '0' ]];
		  then
			  `/usr/bin/mysql -e "update scumlogs.stats set kdratio = kills where steamid = '$KILL_STEAM_ID'; "`
		  fi

	  fi

	  if [[ -z "$DEATH_USER_EXISTS" ]];
	  then

		  `/usr/bin/mysql -e "insert into scumlogs.stats (steamid, name, kills, deaths, kdratio) VALUES ($DEATH_STEAM_ID,'$DEATH_USER_NAME',0,0,0);" `
                  `/usr/bin/mysql -e "update scumlogs.stats set deaths = deaths + 1 where steamid = '$DEATH_STEAM_ID';"`
	  else
		  `/usr/bin/mysql -e "update scumlogs.stats set deaths = deaths + 1 where steamid = '$DEATH_STEAM_ID';"`
                  if [[ $KDRATIO_NO_KILLS != '0' ]];
                  then
                          `/usr/bin/mysql -e "update scumlogs.stats set kdratio = kills / deaths where steamid = '$DEATH_STEAM_ID'; "`
                 fi
	  fi

	  sleep 5
  fi
done
