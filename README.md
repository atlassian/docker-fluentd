# Overview

fluentd docker image with ruby 2.2.x and support for both elasticsearch and kinesis

# Configuration

Create a `fluentd.conf` file following fluentd's configuration file
format. Add any input that you wish to and add the kinesis output
(see example file in this repository).

## Installed plugins

The following plugins are installed in the docker image:

1. fluent-plugin-ec2-metadata
1. fluent-plugin-hostname
1. fluent-plugin-retag
1. fluent-plugin-kinesis
1. fluent-plugin-kinesis-aggregation
1. fluent-plugin-elasticsearch
1. fluent-plugin-record-modifier
1. fluent-plugin-multi-format-parser
1. fluent-plugin-concat
1. fluent-plugin-rewrite-tag-filter

Here is an example configuration to use them. Note that this uses
the old 'match/retag' approach; ideally you should use filter plugins
like record-modifier (see fluentd.conf), but unfortunately there
is no filter equivalent for ec2metadata yet.

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

Mount the volumes where your logs are if needed and the path to the
fluentd configuration file. Pass aws credentials via environment
variables:

    docker run --ulimit nofile=65536:65536 -p 24224 -p 24220 -p 24230 \
            -v /var/log:/fluentd/log -v `pwd`:/etc/fluent \
            atlassianlabs/fluentd:0.4.0

# Release
First register a Docker Hub account and ask one of the existing member to add you into the atlassianlabs team. Then you can run the following command to release a new version:

```
make release tag=<the new version number>
```
