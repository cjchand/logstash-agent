# Overview

This repo is a simple bit of pre-canned config and extension of the official Logstash container. The intent is to use Logstash in a container as a client deployment option (vs installing it natively), with the following focuses:

1. Give a pre-defined ElasticsSearch output
2. Use Logstash to poll the [RabbitMQ Management APIs](https://cdn.rawgit.com/rabbitmq/rabbitmq-management/rabbitmq_v3_6_5/priv/www/api/index.html)

# Requirements

In order to use this container, you **must** install the [RabbitMQ Management Plugin](https://www.rabbitmq.com/management.html). While the link has more details, you can install the plugin by running this command on your RabbitMQ server(s):
`rabbitmq-plugins enable rabbitmq_management`

You will also need to configure a user account for Logstash to query the RMQ Management APIs, as well as ensure that the Logstash container can reach port 15672.

# Usage options

There is a pre-built Docker image - based on the Dockerfile in this repo - hosted as [ccfoss/logstash-rmq-collector](https://hub.docker.com/r/ccfoss/logstash-rmq-collector/). The container needs to be able to resolve the pseudo-hosts "elasticsearch" and "rabbitmq", which you can do by using the `add-host` option in your `docker run` command. 

For example, if your Elasticsearch endpoint's IP address was 10.2.3.4, you would run the container like so: 
`docker run --name logstash_agent --add-host elasticsearch:10.2.3.4 --add-host rabbitmq:10.5.6.7 ccfoss/logstash-rmq-collector`

Logstash will then poll the RabbitMQ Management APIs every 10 seconds to collect various information about the RabbitMQ cluster, queues, connections, consumers, disk read/writes, and more.

