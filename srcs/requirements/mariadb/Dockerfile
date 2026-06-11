FROM alpine:3.20

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN sed -i 's/skip-networking//' /etc/my.cnf.d/mariadb-server.cnf

COPY conf/my.cnf /etc/my.cnf.d/my.cnf
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
