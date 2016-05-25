# mono 4.2.2.30-onbuild
#
# VERSION               0.0.1
#
FROM mono:latest

MAINTAINER Yanchi
#設定工作目錄
WORKDIR /etc

#設定時區
#RUN rm /etc/timezone \
#    && echo "Asia/Taipei" > /etc/timezone \
#    && chmod 644 /etc/timezone
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && chmod 644 /etc/timezone
    
#執行apt-get更新套件，設定Cron工作排程器
RUN apt-get update \
    && apt-get install -y --no-install-recommends runit \
    && apt-get install -y --no-install-recommends vim \
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
#啟動服務
#RUN service cron start
CMD ["runsv", "/etc/service/cron"]
#CMD ["service","cron start"]
#ENTRYPOINT ["/etc/init.d/cron","start"]
# Finished
