#!/bin/bash

#---------------------------------Set variables----------------------------------------------

Date= date +%F
Year= date +%Y

Dago= date --date='90 days ago' +%d
Mago= date --date='90 days ago' +%m
Dateago= date --date='90 days ago' +%F

sourceDir=/backup/
targetDir=/backup2/

LOGFILE=/backup2/backup.log

if [ "`df | grep "/dev/sda1" | awk '{print $5}' | sed 's/\%//'`" -ge 10 ]
    then
	#-----------------------------------Создание каталогов----------------------------------------
	#find "$sourceDir" -type d | sed -e "s?$sourceDir?$targetDir?" | xargs mkdir -pv \; >>$LOGFILE
	#-----------------------------------Перенос файлов созданных более 90 дней назад------------------------------------
	echo "----------------На диске: $Disk осталось менее 10% свободного места------------------------------------"
	echo "---Перемещение файлов созданных более 90 дней назад, до $Dago на резервное хранилище-----------------------------"
	find $sourceDir -type f -mtime +10 -exec rsync -avRog --log-file=$LOGFILE --remove-source-files {} $targetDir \;
	
	
	echo "----------------------------Создание архивов----------------------------------"
	for i in /backup2/backup/$Year/*/*/*
	    do
		echo "$i"
		cd $i
		tar -cvzf 1.tgz $i >>$LOGFILE
	done
    else
	echo "----------------nothing to do---------------------------------"
fi