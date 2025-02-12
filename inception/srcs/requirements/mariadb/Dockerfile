FROM debian:buster

RUN apt-get update -y && apt-get upgrade -y

RUN apt install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/run-mariadb.sh /

WORKDIR /

RUN chmod +x /run-mariadb.sh

EXPOSE 3306

CMD ["/run-mariadb.sh"]
