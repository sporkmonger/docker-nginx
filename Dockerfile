FROM quay.io/sporkmonger/confd:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

# Install Nginx
RUN apk add --update nginx && rm -rf /var/cache/apk/*

# Add confd files
COPY ./nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
COPY ./nginx.toml /etc/confd/conf.d/nginx.toml
COPY ./app.conf.tmpl /etc/confd/templates/app.conf.tmpl
COPY ./app.toml /etc/confd/conf.d/app.toml

# Wire up directories, since everything just routes to /tmp
RUN mkdir -p /tmp/nginx && mkdir -p /var/log/nginx && \
  mkdir -p /etc/nginx/sites-enabled && mkdir -p /etc/nginx/sites-available

# Remove default site
RUN rm -f /etc/nginx/sites-enabled/default

# Save time by causing this to fail if broken
RUN /usr/sbin/nginx -t -c /etc/nginx/nginx.conf

# Add boot script
COPY ./start /opt/bin/start
RUN chmod a+x /opt/bin/confd && chmod a+x /opt/bin/start

EXPOSE 80 443

# Run the boot script
CMD /opt/bin/start
