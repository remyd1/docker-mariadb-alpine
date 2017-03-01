FROM alpine:edge
MAINTAINER Tim Haak <tim@haak.co>

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    DB_USER="admin" \
    DB_PASS="password" \
    TERM="xterm"

RUN apk -U upgrade && \
    apk --update add \
      bash \
      mariadb mariadb-client git \
      && \
      git clone https://github.com/major/MySQLTuner-perl.git /MySQLTuner-perl && \
      rm -rf /tmp/src && \
      rm -rf /var/cache/apk/*

ADD ./files/my.cnf /etc/mysql/my.cnf
ADD ./files/mysqlMem.sh  /MySQLTuner-perl/mysqlMem.sh
ADD ./files/checkFragmentation.sh  /MySQLTuner-perl/checkFragmentation.sh
ADD ./files/start.sh /start.sh

RUN chmod u+x /start.sh /MySQLTuner-perl/mysqlMem.sh /MySQLTuner-perl/checkFragmentation.sh

VOLUME ["/data"]
EXPOSE 3306

CMD ["/start.sh"]
