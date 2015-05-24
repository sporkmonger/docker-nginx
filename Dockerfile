FROM quay.io/sporkmonger/confd:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

# Install Nginx
RUN opkg-install nginx

# Add confd files
COPY ./nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
COPY ./nginx.toml /etc/confd/conf.d/nginx.toml
COPY ./app.conf.tmpl /etc/confd/templates/app.conf.tmpl
COPY ./app.toml /etc/confd/conf.d/app.toml

# Make sure the log directory exists
RUN mkdir -p /var/log/nginx

# Remove default site
RUN rm -f /etc/nginx/sites-enabled/default

# Add boot script
COPY ./start /opt/bin/start
RUN chmod a+x /opt/bin/confd && chmod a+x /opt/bin/start

# Run the boot script
CMD /opt/bin/start
