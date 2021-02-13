#!/bin/sh
#
# SQL Metrics
max_connections=$(/usr/local/bin/mysqlmon.sh max_connections)
max_used_connections=$(/usr/local/bin/mysqlmon.sh max_used_connections)
threads_connected=$(/usr/local/bin/mysqlmon.sh threads_connected)
connections=$(/usr/local/bin/mysqlmon.sh connections)
#
# OS Metrics
Memory_Utilisation=$(free -m | awk 'NR==2{printf "%.2f\t", $3*100/$2 }')
TCP_Conn=$(netstat -an | wc -l)
TCP_Conn_http=$(netstat -an | grep 80 | wc -l)
TCP_Conn_https=$(netstat -an | grep 443 | wc -l)
Users=$(uptime |awk '{ print $6 }')
IO_Wait=$(iostat | awk 'NR==4 {print $5}')
Disk_Utilisation=$(df -h | grep /dev/nvme| awk '{print $5}' | grep -o '[0-9]*')
#
# Timestamp
cdate=$(date -u +%Y-%m-%dT%H:%M:00.000Z)
#
# Instance ID
instanceid=$(curl http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)
#
# Publish Metrics
aws cloudwatch put-metric-data --metric-name MySQLMaxConnections --namespace "Custom" --dimensions="Instance=$instanceid" --value $max_connections --timestamp $cdate
aws cloudwatch put-metric-data --metric-name MySQLMaxUsedConnections --namespace "Custom" --dimensions="Instance=$instanceid" --value $max_used_connections --timestamp $cdate
aws cloudwatch put-metric-data --metric-name MySQLThreadsConnected --namespace "Custom" --dimensions="Instance=$instanceid" --value $threads_connected --timestamp $cdate
aws cloudwatch put-metric-data --metric-name MySQLConnections --namespace "Custom" --dimensions="Instance=$instanceid" --value $connections --timestamp $cdate
aws cloudwatch put-metric-data --metric-name Memory_Utilisation --dimensions Instance=$instanceid  --namespace "Custom" --value $Memory_Utilisation
aws cloudwatch put-metric-data --metric-name TCP_Connections --dimensions Instance=$instanceid  --namespace "Custom" --value $TCP_Conn
aws cloudwatch put-metric-data --metric-name TCP_Conn_http --dimensions Instance=$instanceid  --namespace "Custom" --value $TCP_Conn_http
aws cloudwatch put-metric-data --metric-name TCP_Conn_https --dimensions Instance=$instanceid  --namespace "Custom" --value $TCP_Conn_https
aws cloudwatch put-metric-data --metric-name No_of_users --dimensions Instance=$instanceid  --namespace "Custom" --value $Users
aws cloudwatch put-metric-data --metric-name IO_Wait --dimensions Instance=$instanceid  --namespace "Custom" --value $IO_Wait
aws cloudwatch put-metric-data --metric-name Disk_Utilisation --dimensions Instance=$instanceid  --namespace "Custom" --unit Percent --value $Disk_Utilisation
#
#
