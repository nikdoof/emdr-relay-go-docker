# emdr-relay-go
#
# Basic container to run a EMDR Relay instance.

# Base on Ubuntu 
FROM      ubuntu:quantal

# Add some sane options to Apt/Dpkg
ENV DEBIAN_FRONTEND noninteractive
RUN echo "APT::Get::Install-Recommends \"0\";" >> /etc/apt/apt.conf.d/99local
RUN echo "APT::Get::Install-Suggests \"0\";" >> /etc/apt/apt.conf.d/99local
RUN echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache

# Grab build deps
RUN echo "deb http://archive.ubuntu.com/ubuntu quantal universe" > /etc/apt/sources.list.d/universe.list
RUN apt-get -qq update 
RUN apt-get install -y golang libzmq-dev uuid-dev libtool mercurial git supervisor pkg-config

# Pull Go deps
RUN go get github.com/alecthomas/gozmq
RUN go get code.google.com/p/vitess/go/cache

# Setup the emdr user
RUN useradd --home /home/emdr --create-home --system emdr

# Grab the code
RUN cd /home/emdr/ && git clone https://github.com/gtaylor/emdr-relay-go.git
RUN cd /home/emdr/emdr-relay-go && go build emdr-relay-go.go

# Copy configs
RUN cp /home/emdr/emdr-relay-go/example_configs/supervisord-relay.conf /etc/supervisor/conf.d/emdr-relay-go.conf
RUN cp /home/emdr/emdr-relay-go/example_configs/example.cron.daily /etc/cron.daily/emdr-relay-go && chmod a+x /etc/cron.daily/emdr-relay-go

# Expose ports and set initial run command
EXPOSE 8050
CMD /usr/bin/supervisord -n