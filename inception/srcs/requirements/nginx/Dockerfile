FROM debian:buster

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/sites-available/

COPY ./tools/run_nginx.sh /

WORKDIR /

EXPOSE 443

RUN chmod +x run_nginx.sh

CMD ["/run_nginx.sh"]