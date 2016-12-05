FROM logstash:2

ENV KAFKA_BROKERS=localhost:9200
ENV KAFKA_CLIENT_ID=logstash
ENV KAFKA_GROUP_ID=logstash
ENV KAFKA_TOPIC=logstash
ENV LOGSTASH_SITE_NAME=test

COPY ./config/logstash/conf.d /etc/logstash/conf.d

CMD ["--allow-env", "-f", "/etc/logstash/conf.d"]
