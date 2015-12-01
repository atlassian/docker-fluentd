FROM ruby:2.2.3-slim

MAINTAINER Micros <micros@atlassian.com>

RUN apt-get update -y && apt-get install -yy \
      build-essential \
      zlib1g-dev \
      libjemalloc1

COPY .gemrc /root/

RUN gem install fluentd:0.12.15
RUN fluent-gem install \
    fluent-plugin-ec2-metadata:0.0.7 fluent-plugin-hostname:0.0.2 \
    fluent-plugin-retag:0.0.1 fluent-plugin-kinesis:0.3.6 \
    fluent-plugin-elasticsearch:1.0.0 fluent-plugin-record-modifier:0.3.0 \
    fluent-plugin-multi-format-parser:0.0.2 \
    fluent-plugin-kinesis-aggregation:0.2.0

RUN mkdir -p /var/log/fluent

# monitor port
EXPOSE 24220
# forward port
EXPOSE 24224
# debug port
EXPOSE 24230

ENV LD_PRELOAD "/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
CMD ["fluentd", "-c", "/etc/fluent/fluentd.conf"]
