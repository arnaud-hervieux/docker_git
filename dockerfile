FROM debian:latest

RUN apt-get update && apt-get -y install openjdk-7-jre curl sudo nano wget apt-utils apt-transport-https git-core && apt-get -y upgrade

RUN wget  https://packages.elastic.co/GPG-KEY-elasticsearch && apt-key add GPG-KEY-elasticsearch && \
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" > /etc/apt/sources.list.d/elk.list && \
echo "deb https://packages.elastic.co/kibana/4.6/debian stable main" >> /etc/apt/sources.list.d/elk.list && \
echo "deb https://packages.elastic.co/logstash/2.4/debian stable main" >> /etc/apt/sources.list.d/elk.list && \
apt-get update && apt-get -y install logstash kibana elasticsearch && apt-get clean

RUN /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head

ADD http://172.16.10.250/WEBDAV/config/elkapt.tar.gz /

RUN tar -zxf elkapt.tar.gz && rm elkapt.tar.gz

RUN adduser --system elasticsearch && adduser --system logstash && adduser --system kibana && \
addgroup --system elasticsearch && addgroup --system logstash && addgroup --system kibana && \
usermod -g logstash logstash && usermod -g kibana kibana && usermod -g elasticsearch elasticsearch 

RUN echo "#!/bin/bash" > /opt/setup.sh && \
echo "service logstash start && service elasticsearch start && service kibana start && top" >> /opt/setup.sh && \
chmod 770 /opt/setup.sh

RUN chown logstash:logstash -R /opt/logstash/ /etc/logstash/ && \
chown elasticsearch:elasticsearch -R /usr/share/elasticsearch/ /etc/elasticsearch/

RUN sysctl -q -w vm.max_map_count=262144

ENTRYPOINT /opt/setup.sh

EXPOSE 5044 9200 5601
