FROM debian:wheezy
MAINTAINER Reza Mohammadi <reza@cafebazaar.ir>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && apt-get upgrade -yq && apt-get install -yq postfix dovecot-imapd dovecot-ldap postfix-ldap supervisor

VOLUME ["/var/mail", "/var/spool/mail"]

ADD etc-files/aliases.txt           /etc/aliases
ADD etc-files/supervisord.conf      /etc/supervisor/conf.d/supervisord.conf

ADD mail-initializer                /usr/bin/mail-initializer

EXPOSE 25/tcp 587/tcp
CMD ["/usr/bin/mail-initializer"]
