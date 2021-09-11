FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y unzip
RUN apt-get install -y curl
RUN apt-get install -y iputils-ping
RUN apt-get install -y iproute2
RUN apt-get install -y tcpdump

# Consul download #
###################
ENV CONSUL_VERSION="1.10.2"
ENV ARCH="arm64"
ENV CONSUL_URL="https://releases.hashicorp.com/consul"
RUN curl --silent --remote-name ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${ARCH}.zip
RUN unzip consul_${CONSUL_VERSION}_linux_${ARCH}.zip

# Consul prepare binary #
#########################


RUN chown root:root consul
RUN mv consul /usr/bin/
RUN consul -autocomplete-install
RUN mkdir --parents /opt/consul/
RUN mkdir --parents /etc/consul.d/

# Start Consul #
################
CMD ["consul", "agent",  "--config-dir=/etc/consul.d/"]
