# Overview

The `feature/kafka-0.8-ingest` branch features a Logstash client that can ingest from a single Kafka topic from a Kafka 0.8 cluster. This is important because:

1. This requires use of Logstash 2.x, as Logstash 5.x only supports Kafka 0.9+
2. Similarly, this branch will only work for Kafka 0.8 (Use the [upcoming, but not yet released] `feature/kafka-0.9-ingest` branch if you have Kafka 0.9+)

This repo assumes that you have basic auth enabled for Elasticsearch, either by a web server/proxy or using ES' built-in Shield authentication. If you do not need authentication, then you will need to comment out the `user` and `password` configuration from `./config/logstash/conf.d/logstash-output-es.conf`. 

# How to Use this Container

There are three ways to use this repo:

1. If you do not need to add any custom configuration, you can use our pre-built Docker image
2. If you want to build your own Docker image, you can add config to the `./config/logstash/conf.d` directory and `docker build` a new image
3. If you want to use the config in this repo in a native install of Logstash, simply copy the contents of the `./config/logstash/conf.d` directory into `/etc/logstash/conf.d` and restart Logstash

## Using the Docker Images

Whether you use the pre-built Docker image or build one on your own, there are environment variables that you need to know about. Their purpose - and default values - are as follows:

* `ZK_URL` (Default: None): The URL scheme for the ZooKeeper(s) used by your Kafka cluster. This would typically be of the form `10.2.3.4:2181,10.5.6.7:2181,10.8.9.10:2181`, but it can include a chroot path, such as `10.2.3.4:2181/kafka`
* `KAFKA_CLIENT_ID` (Default: logstash): This is a string that denotes a unique Kafka consumer ID. **It is critical that if you plan on using multiple containers to consume a single topic that each container uses a different `KAFKA_CLIENT_ID`**. 
* `KAFKA_GROUP_ID` (Default: logstash): This is a string that denotes the Kafka Consumer Group name you want to use. **If you plan on using multiple containers to consume a single topic, each container uses --THE SAME--  `KAFKA_GROUP_ID`**.
* `LOGSTASH_SITE_NAME` (Default: ''): This is an optional field that will:
    1. Add a `sitename` field to each message, set to the value of the string you enter
    2. Use that same string to create a unique Logstash index per site in the form of `logstash-LOGSTASH_SITE_NAME-YYYY.MM.DD` (e.g.: `logstash-dc-east-2016.12.05`)
* `KAFKA_TOPIC`: String matching the Kafka topic where Logatash clients are shipping their logs.
* `ES_USER` (Default: elastic): The user ID to authenticate to ElasticSearch
* `ES_PASSWORD` (Default: changeme): The password to authenticate to ElasticSearch

Any of the variables above that have a default value (e.g.: all except `ZK_URL`) can be ommitted, but typically you will want to set all of these values when issuing your `docker run` command. 

In addition to the variables above, you will need to issue an `--add-host` argument to specify the hostname or IP address of your ElasticSearch cluster.


## Use-Case 1: Pre-built Docker Image

If you want to use the pre-built Docker image, simply supply the environment variables via the `-e` argument for `docker run`, along with the `--add-host` argument to specify the hostname or IP address of your ElasticSearch cluster.

For example:

```
docker run -d --name kafka-ingestor-1 -e "ZK_URL=10.2.3.4:2181/kafka" -e "KAFKA_CLIENT_ID=ingestor-1" -e "KAFKA_GROUP_ID=logstash-group" -e "LOGSTASH_SITE_NAME=dc-west-1" -e 'KAFKA_TOPICS=logstash-agent' -e 'ES_USER=elastic' -e 'ES_PASSWORD=$3cr3t' --add-host=elasticsearch:10.9.8.7 ccfoss/logstash-agent:kafka-ingest
```

## Use-Case 2: Building Your Own Docker Image

If you want to customize the Logstash configuration (e.g.: add Grok patterns, etc), do the following once you have added the appropriate configuration to `./config/logstash/conf.d`:

`docker build -t [your_image_name_here] .`

Optionally, you can upload the image do Docker Hub:

1. `docker build -t [your_docker_hub_org/your_image_name_here] .`
2. `docker push [your_docker_hub_org/your_image_name_here]`

Then, on the box(es) you want to run the image on:

```
docker run -d --name kafka-ingestor-1 -e "ZK_URL=10.2.3.4:2181/kafka" -e "KAFKA_CLIENT_ID=ingestor-1" -e "KAFKA_GROUP_ID=logstash-group" -e "LOGSTASH_SITE_NAME=dc-west-1" -e 'KAFKA_TOPICS=logstash-agent' -e 'ES_USER=elastic' -e 'ES_PASSWORD=$3cr3t' --add-host=elasticsearch:10.9.8.7 [your_docker_hub_org/your_image_name_here]
```

## Use-Case 3: Native Logstash Install

If you want to use the configuration provided here with a native Logstash install, you can simply copy the contents of `./config/logstash/conf.d` into `/etc/logstash/conf.d` and restart Logstash. 

Note that you will likely also want to either:

1. Set Environment Variables for the Logstash user, as mentioned in the "Using the Docker Images" section
2. Change the configuration in the files themselves to suit your environment


