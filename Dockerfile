FROM quay.io/sporkmonger/confd:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

# Install Nginx
RUN apt-get install -y --force-yes software-properties-common
RUN add-apt-repository ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y --force-yes nginx

# Add confd files
COPY ./nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
COPY ./nginx.toml /etc/confd/conf.d/nginx.toml

# Remove default site
RUN rm -f /etc/nginx/sites-enabled/default

# Add boot script
COPY ./start /opt/bin/start
RUN chmod +x /opt/bin/start

# Run the boot script
CMD /opt/bin/start
