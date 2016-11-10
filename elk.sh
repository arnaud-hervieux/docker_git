#!/bin/bash

ES_USER=elasticsearch
ES_GROUP=elasticsearch
ES_HOME="/usr/share/elasticsearch"
ES_PROGS="/usr/share/elasticsearch/bin/${ES_USER}"
ES_DATA_DIR="/data/${ES_USER}"
ES_LOG_DIR="/data/logs/${ES_USER}"
ES_CONF_DIR="/etc/${ES_USER}"
ES_pidfile="/var/run/${ES_USER}/${ES_USER}.pid"

ES_ARG="-d -p ${ES_pidfile} --default.home.dir=${ES_HOME}  --default.path.conf=${ES_CONF_DIR}"

LS_USER=logstash
LS_GROUP=logstash
LS_HOME="/opt/logstash"
LS_PROGS="/opt/logstash/bin/${LS_USER}"
LS_CONF_DIR="/etc/${LS_USER}/conf.d/"
LS_LOG_DIR="/data/logs/${LS_USER}"
LS_pidfile="/var/run/logstash.pid"

LS_ARG="agent --config ${LS_CONF_DIR}"

K_USER=kibana
K_GROUP=kibana
K_HOME=/opt/kibana
K_PROGS=/opt/kibana/bin/$K_USER
K_CONF_DIR=/etc/$K_USER
K_pidfile="/var/run/kibana.pid"

K_ARG="-c ${K_CONF_DIR}/kibana.yml --quiet"

 if [ ! -d $$LS_LOG_DIR ]
  then
	mkdir "$LS_LOG_DIR"  
	chmod 755 "$LS_LOG_DIR"
	chown -R "$LS_USER":"$LS_GROUP" "$LS_LOG_DIR"
  fi

start-stop-daemon  -d $ES_HOME --start --user $ES_USER -c $ES_USER:$ES_GROUP --pidfile $ES_pidfile --exec $ES_PROGS -- $ES_ARG
start-stop-daemon  -d $LS_HOME --start --user $LS_USER -c $LS_USER:$LS_GROUP --pidfile $LS_pidfile --exec $LS_PROGS -- $LS_ARG
start-stop-daemon  -d $ES_HOME --start --user $ES_USER -c $KS_USER:$K_GROUP --pidfile $K_pidfile --exec $K_PROGS -- $K_ARG
