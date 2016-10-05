# Overview

This repo is a simple bit of pre-canned config and extension of the official Logstash container. The intent is to use Logstash in a container as a client deployment option (vs installing it natively), with the following focuses:

1. Give a pre-defined syslog input, exposed on UDP 5514 of the host
2. Give a couple of examples of how to use custom config via a Dockerfile or via `docker-compose`

# Usage options

There are a two primary usage options for this repo:

1. Logstash client deployment via Docker Hub-hosted image
2. Logstash client deployment, with baked-in configuration, using the provided Dockerfile to buil a custom image

In both of the options, we launch Logstash with the following config, unless you change what is in the ./config/logstash/conf.d directory:

1. Listens on UDP 5514 for syslog messages (pro-tip: you can test via netcat (`nc`) like so: `nc -w0 -u 127.0.0.1 5514 <<< "pickles"`)
2. Looks for updates to `/private/log/system.log` (relevant only for Mac users, so comment out/remove/modify this if you are on any other platform)
3. Ships any logging to the ElasticSearch instance

# Option 1: Logstash client deployment via Docker Hub-hosted image

There is a pre-built Docker image - based on the Dockerfile in this repo - hosted as [ccfoss/logstash-syslog-proxy](https://hub.docker.com/r/ccfoss/logstash-syslog-proxy/). The container needs to be able to resolve the host "elasticsearch," which you can do by using the `add-host` option in your `docker run` command. 

For example, if your Elasticsearch endpoint's IP address was 10.2.3.4, you would run the container like so: `docker run --name logstash_agent --add-host=elasticsearch:10.2.3.4 ccfoss/logstash-syslog-proxy`.

Logstash will run with the following config:

1. Listens on UDP 5514 for syslog messages (pro-tip: you can test via netcat (`nc`) like so: `nc -w0 -u 127.0.0.1 5514 <<< "pickles"`)
2. Looks for updates to `/private/log/system.log` (relevant only for Mac users, so comment out/remove/modify this if you are on any other platform)
3. Ships any logging to the ElasticSearch instance

# Option 2: Use Dockerfile to build a new Docker image

If you want to have the same Logstash config on all clients, you might find it simpler to just create new Docker images with the required configuration baked right in. This means you do not have to ship the configuration around with the Dockerfile. It also means you can update the configuration by:

1. Updating the Logstash configuration in ./config/logstash/conf.d
2. Using `docker build` to update the image, followed by `docker push` to push the images
3. Stop, remove, and re-deploy the container using the latest image

This can change your Logstash upgrades and/or config changes to a single-line command: `docker stop logstash_agent; docker rm logstash_agent; docker pull myrepo/my-logstash-client:latest; docker run --name logstash_agent <your_repo/image_name>`

The build/push process goes like this:

1. Make any changes you wish to the configuration in ./config/logstash/conf.d directory.
2. Once done with config changes, run `docker build -t <your_repo/image_name> .`
3. Optionally, test your image by running it `docker run -it --rm <your_repo/image_name>`
4. Once satisfied, upload your image by running `docker push <your_repo/image_name>`.

From there, you can run the `docker stop/rm/pull/run` one-liner listed above. 
