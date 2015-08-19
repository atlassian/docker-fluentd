# Overview

fluentd docker image with ruby 2.2.x and support for both elasticsearch and kinesis

# Configuration

Create a `fluentd.conf` file following fluent configuration files format. Add any input that you wish to and add the kinesis output as follow:

```
<match **>
  type kinesis
  stream_name logs
  region us-west-1
  random_partition_key
</match>
```

## Installed plugins

The following plugins are installed in the docker image:

1. fluent-plugin-ec2-metadata
1. fluent-plugin-hostname
1. fluent-plugin-retag
1. fluent-plugin-kinesis
1. fluent-plugin-elasticsearch

Here is some example configuration to use them

```
<match syslog>
  type hostname
  key_name ec2_hostname
  add_prefix hostname
</match>
<match hostname.syslog>
  type ec2_metadata
  output_tag ec2.${tag}
  <record>
    ec2_instance_id   ${instance_id}
    ec2_instance_type ${instance_type}
    ec2_az            ${availability_zone}
    service_id        my-service-uuid
    env               my-environment
  </record>
</match>
<match ec2.hostname.**>
  type retag
  remove_prefix ec2.hostname
</match>
```


# Run

Mount the volumes where your logs are if needed and the path to the fluentd configuration file. Pass aws credentials via environment variables:

    docker run -p 24224 -v /var/log:/fluentd/log -v `pwd`:/etc/fluent \
			atlassianlabs/fluentd:latest

# Release
First registered a Docker Hub account and ask one of the existing member to add you into the atlassianlabs team. Then you can run the following command to release a new version:

```
make release tag=<the new version number>
```

