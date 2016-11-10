FROM debian:latest
# mise à jour de la distribution et ajout des paquets de base
RUN apt-get update && apt-get -y install apt-utils openjdk-7-jre curl sudo nano wget apt-transport-https git-core && apt-get -y upgrade

RUN wget  https://packages.elastic.co/GPG-KEY-elasticsearch && apt-key add GPG-KEY-elasticsearch && \
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" > /etc/apt/sources.list.d/elk.list && \
echo "deb https://packages.elastic.co/kibana/4.6/debian stable main" >> /etc/apt/sources.list.d/elk.list && \
echo "deb https://packages.elastic.co/logstash/2.4/debian stable main" >> /etc/apt/sources.list.d/elk.list && \
apt-get update && apt-get -y -install logstash kibana elasticsearch

RUN /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head

RUN git clone https://github.com/arnaud-hervieux/docker_git.git && \
cp -R /docker_git/etc/ / && cp /docker_git/setup.sh /opt/setup.sh && chmod 770 /opt/setup.sh && rm -R docker_git GPG-KEY-elasticsearch

RUN adduser --system elasticsearch && adduser --system logstash && adduser --system kibana && \
addgroup --system elasticsearch && addgroup --system logstash && addgroup --system kibana && \
usermod -g logstash logstash && usermod -g kibana kibana && usermod -g elasticsearch elasticsearch 

RUN chown logstash:logstash -R /opt/logstash/ /etc/logstash/ && \
chown elasticsearch:elasticsearch -R /usr/share/elasticsearch/ /etc/elasticsearch/

ENTRYPOINT ["/opt/elk.sh"]

EXPOSE 5044 9200 5601
