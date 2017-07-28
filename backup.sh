#!/bin/bash
echo "开始备份..."`date`

mkdir -p ${dataname}

innobackupex --defaults-file=$conf --host=$host --user=$mysql_username --password=$mysql_password --database="$databasename" --no-lock --stream=xbstream --tmpdir=$mysql_backup_dir --sleep=20 --throttle=40 --compress --compress-threads=4 $mysql_backup_dir > ${dataname}.xbstream 2> "$logfile"

xbstream -x < ${dataname}.xbstream -C ${dataname}
innobackupex --decompress ${dataname} 2> "$logfile"
find ${dataname} -name "*.qp" | xargs rm -f
innobackupex --defaults-file=$conf --host=$host --user=$mysql_username --password=$mysql_password --use-memory=4G --apply-log ${dataname} 2> "$logfile"

echo "备份完毕..."`date`

echo "删除老的备份..."`date`

cd ${mysql_backup_dir} && ls|grep ${lastweek} |xargs rm -rf

echo "删除老的备份完毕..."`date`

