FROM ruby:2.2.2-slim

MAINTAINER Micros <micros@atlassian.com>

RUN ulimit -n 65536

COPY .gemrc /root/

RUN apt-get update -y && apt-get install -y \
			build-essential \
			zlib1g-dev

RUN gem install fluentd
RUN fluent-gem install fluent-plugin-ec2-metadata fluent-plugin-hostname fluent-plugin-retag fluent-plugin-kinesis fluent-plugin-elasticsearch fluent-plugin-record-modifier fluent-plugin-multi-format-parser

RUN mkdir -p /var/log/fluent

EXPOSE 24224

CMD ["fluentd","-c","/etc/fluent/fluentd.conf"]
