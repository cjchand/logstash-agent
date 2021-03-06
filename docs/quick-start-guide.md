# Quick Start Guide

This is simply a Logstash agent that takes in syslog and ships it to ElasticSearch. The use cases are primarily around ingesting logs from:

1. *nix servers and network devices
2. Containers

... but syslog is syslog. Go nuts!

# Step 1: Deploy this container

If you just want to fire up a container without any custom config of your own, then you can use the [Docker Hub image built from this repo](https://hub.docker.com/r/ccfoss/logstash-syslog-proxy/):

`docker run --name <your_name> -p <your_port>:5514/udp --add-host elasticsearch:<your_es_ip> ccfoss/logstash-syslog-proxy`

where:

* `<your_name>`: The name you want for the container (or omit the `--name` argument if you prefer to have Docker generate one for you)
* `<your_port>`: The port on the host where clients should ship syslog to (you will need this is Step 2)
* `<your_es_ip>`: The IP address of your ElasticSearch server

For example, if your Elasticsearch endpoint's IP address was 10.2.3.4, you would run the container like so: 
`docker run --name logstash_agent --add-host=elasticsearch:10.2.3.4 -p 5514:5514/udp ccfoss/logstash-syslog-proxy`


# Step 2: Ship Your Logs

Next, we need to ship logs to the host where the Logstash container is running. Running with our two example use cases:

* For platforms running rsyslog (e.g.: Linux):
	* Add this line in `/etc/rsyslog/rsyslog.conf` and restart rsyslog:
	* `\*.\*   @@<your_logstash_host>:<your_port>`
	* where:
		* `<your_logstash_host>`: The IP address/hostname/FQDN where you launched the Logstash container in Step 1 above
		* `<your_port>`: The port you chose in Step 1 above
* For other containers (using nginx as an example):
	* `docker run --name <your_name> --log-driver=syslog --log-opt syslog-address=udp://<your_logstash_host>:<your_port> -p 80:80 nginx`
	* where:
		* `<your_name>`: The name you want for the container (or omit the `--name` argument if you prefer to have Docker generate one for you)
		* `<your_logstash_host>`: The IP address/hostname/FQDN where you launched the Logstash container in Step 1 above
		* `<your_port>`: The port you chose in Step 1 above

For example, if the IP address of the host where your Logstash container lives is 10.9.8.7 and you have port 3456 on the host forwarding to the Logstash container, it would look like this:

`docker run -it --log-driver=syslog --log-opt syslog-address=udp://10.9.8.7:3456 -p 80:80 nginx`