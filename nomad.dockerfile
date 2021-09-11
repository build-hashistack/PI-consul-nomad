FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y unzip
RUN apt-get install -y curl
RUN apt-get install -y gnupg2
RUN apt-get install -y iputils-ping
RUN apt-get install -y iproute2
RUN apt-get install -y tcpdump

# ENVIRONMENT VARIABLES #
#########################
ENV NOMAD_VERSION="1.1.4"
ENV CONSUL_VERSION="1.10.2"
ENV ARCH="arm64"

# Nomad download#
#################
RUN curl --silent --remote-name https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_${ARCH}.zip
RUN unzip nomad_${NOMAD_VERSION}_linux_${ARCH}.zip

# Nomad prepare binary #
########################

RUN mv nomad /usr/bin/
RUN nomad --autocomplete-install
RUN mkdir --parents /opt/nomad
RUN mkdir --parents /etc/nomad.d
RUN chmod 700 /etc/nomad.d

# Consul download #
###################

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

# Tansfer Start Script #
COPY "data/start_container.sh" /root
WORKDIR /root
RUN chmod u+x start_container.sh

# Start Consul and Nomad#
CMD /root/start_container.sh
# CMD consul agent -config-dir=/etc/consul.d/ && /usr/bin/nomad agent -config=/etc/nomad.d
