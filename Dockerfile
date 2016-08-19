FROM ubuntu:14.04.3

# Update system packages
RUN apt-get clean && \
  apt-get update && \
  apt-get -y upgrade

RUN apt-get update && apt-get install -y \
  curl \
  python \
  unzip

WORKDIR /tmp

# Install AWS CLI Client so we can get docker login from AWS
RUN curl -so awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
  unzip awscli-bundle.zip && \
  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Install jq
RUN curl -Lso jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  mv jq /usr/local/bin/jq && \
  chmod ug+x /usr/local/bin/jq

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

RUN mkdir /usr/src/drfactory

COPY push.sh /usr/src/drfactory
WORKDIR /usr/src/drfactory

VOLUME /var/run/docker.sock
CMD ./push.sh
