FROM bugcrowd/aws-tools:latest

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

RUN mkdir /usr/src/drfactory

COPY push.sh /usr/src/drfactory
WORKDIR /usr/src/drfactory

VOLUME /var/run/docker.sock
CMD ./push.sh
