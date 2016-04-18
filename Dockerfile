# mono 4.2.2.30-onbuild
#
# VERSION               0.0.1
#
FROM mono:4.2.2.30

MAINTAINER Yanchi

WORKDIR /etc

RUN rm /etc/timezone \
    && echo "Asia/Taipei" > /etc/timezone \
    && chmod 644 /etc/timezone \
    && apt-get update \
    && apt-get install -y --no-install-recommends runit \
    && apt-get install -y --no-install-recommends cron \
    
    && mkdir /etc/service/cron \
    && echo '#!/bin/sh' > /etc/service/cron/run \
    && echo 'exec /usr/sbin/cron -f' >> /etc/service/cron/run \
    && chmod -R 700 /etc/service/cron/ \
    && chmod 600 /etc/crontab \
    && rm -f /etc/cron.daily/standard \
    && rm -f /etc/cron.daily/upstart \
    && rm -f /etc/cron.daily/dpkg \
    && rm -f /etc/cron.daily/password \
    && rm -f /etc/cron.weekly/fstrim \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
CMD ["runsv", "/etc/service/cron"]
# Finished
