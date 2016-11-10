#!/bin/bash


ES_USER=elasticsearch
ES_GROUP=elasticsearch
ES_HOME=/usr/share/elasticsearch
ES_PROGS=/usr/share/elasticsearch/bin/$ES_USER
ES_DATA_DIR=/data/$ES_USER
ES_LOG_DIR=/data/logs/$ES_USER
ES_CONF_DIR=/etc/$ES_USER
ES_pidfile="/var/run/"$ES_USER"/"$ES_USER".pid"

ES_ARG="-d -default.path.conf=$ES_CONF_DIR"

LS_USER=logstash
LS_GROUP=logstash
LS_HOME=/opt/logstash
LS_PROGS=/opt/logstash/bin/$LS_USER
LS_CONF_DIR=/etc/$LS_USER/conf.d/
LS_LOG_DIR=/data/logs/$LS_USER
LS_pidfile="/var/run/logstash.pid"

LS_ARG="agent-f $LS_CONF_DIR -l $LS_LOG_DIR"

K_USER=kibana
K_GROUP=kibana
K_HOME=/opt/kibana
K_PROGS=/opt/kibana/bin/$K_USER
K_CONF_DIR=/etc/$K_USER
K_pidfile="/var/run/kibana.pid"

K_ARG=" "

start-stop-daemon -d $ES_HOME --start -b --user "$ES_USER" -c "$ES_USER" --pidfile "$ES_pidfile" --exec $ES_PROGS -- $ES_ARG
start-stop-daemon -d $LS_HOME --start -b --user "$LS_USER" -c "$LS_USER" --pidfile "$LS_pidfile" --exec $LS_PROGS -- $LS_ARG
start-stop-daemon -d $ES_HOME --start -b --user "$ES_USER" -c "$ES_USER" --pidfile "$K_pidfile" --exec $K_PROGS -- $K_ARG