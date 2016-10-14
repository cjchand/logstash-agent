FROM logstash

COPY ./config/logstash /etc/logstash

CMD ["-f", "/etc/logstash/conf.d"]
