FROM ruby:2.2.2-slim

MAINTAINER Micros <micros@atlassian.com>

RUN ulimit -n 65536

COPY .gemrc /root/

RUN apt-get update -y && apt-get install -y \
			build-essential \
			zlib1g-dev

RUN gem install fluentd:0.12.15
RUN fluent-gem install \
			fluent-plugin-ec2-metadata:0.0.7 fluent-plugin-hostname:0.0.2 \
			fluent-plugin-retag:0.0.1 fluent-plugin-kinesis:0.3.5 \
			fluent-plugin-elasticsearch:1.0.0 fluent-plugin-record-modifier:0.3.0 \
			fluent-plugin-multi-format-parser:0.0.2

RUN mkdir -p /var/log/fluent

EXPOSE 24224

CMD ["fluentd","-c","/etc/fluent/fluentd.conf"]
