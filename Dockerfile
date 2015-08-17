FROM ruby:2.2.2-slim

MAINTAINER Micros <micros@atlassian.com>

RUN ulimit -n 65536

COPY .gemrc /root/

RUN apt-get update -y && apt-get install -y \
			build-essential \
			zlib1g-dev

RUN gem install fluentd && gem install fluent-plugin-ec2-metadata && \
			gem install fluent-plugin-hostname && gem install fluent-plugin-retag  && \
			gem install fluent-plugin-kinesis

RUN mkdir -p /var/log/fluent

EXPOSE 24224

CMD ["fluentd","-c","/etc/fluent/fluentd.conf"]
