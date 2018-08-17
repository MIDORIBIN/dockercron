FROM alpine
COPY myscript.sh /bin/myscript.sh
COPY root /var/spool/cron/crontabs/root
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*
RUN chmod +x /bin/myscript.sh
CMD crond -l 2 -f
