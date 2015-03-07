FROM docker.cucloud.net/java

MAINTAINER Shawn Bower <shawn.bower@gmail.cm>

# Download version 1.4.2 of logstash
RUN cd /tmp && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
    tar -xzvf ./logstash-1.4.2.tar.gz && \
    mv ./logstash-1.4.2 /opt/logstash && \
    rm ./logstash-1.4.2.tar.gz

# Install contrib plugins
RUN /opt/logstash/bin/plugin install contrib

#create data dirs
RUN mkdir -p /data/data \
  mkdir -p /data/log \
  mkdir -p /data/plugins \
  mkdir -p /data/work 

# elasticsearch
EXPOSE 9200
EXPOSE 9300

# Kibana
EXPOSE 9292

#syslog
EXPOSE 5000

COPY conf/elasticsearch.yml /opt/logstash/bin/elasticsearch.yml
COPY conf/logstash.conf /etc/logstash.conf
COPY bin/elk-start.sh /opt/elk-start.sh
RUN chmod 755 /opt/elk-start.sh

CMD ["/opt/elk-start.sh"]