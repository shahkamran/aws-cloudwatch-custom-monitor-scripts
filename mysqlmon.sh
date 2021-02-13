#!/bin/sh

MYSQL_USER='USERNAME'
MYSQL_PASS='PASSWORD'

case $1 in
    max_connections)
        mysql --user=$MYSQL_USER --password=$MYSQL_PASS -e "show variables like 'max_connections'" 2>/dev/null | grep -i "max_connections" | awk '{print $2}'
        ;;
    max_used_connections)
        mysql --user=$MYSQL_USER --password=$MYSQL_PASS -e "show status like 'max_used_connections'" 2>/dev/null | grep -i "max_used_connections" | awk '{print $2}'
        ;;
    threads_connected)
        mysql --user=$MYSQL_USER --password=$MYSQL_PASS -e "show status like 'threads_connected'" 2>/dev/null | grep -i "threads_connected" | awk '{print $2}'
        ;;
    connections)
        mysql --user=$MYSQL_USER --password=$MYSQL_PASS -e "show status like 'Connections'" 2>/dev/null | grep -i "Connections" | awk '{print $2}'
        ;;
    *)
        echo "Please provide one of max_connections, max_used_connections, threads_connected, connections"
        exit 1
        ;;
esac
