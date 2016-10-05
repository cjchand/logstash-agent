FROM logstash

COPY ./config/logstash/conf.d /etc/logstash/conf.d

CMD ["-f", "/etc/logstash/conf.d"]
