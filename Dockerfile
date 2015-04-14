FROM debian:wheezy
MAINTAINER Reza Mohammadi <reza@cafebazaar.ir>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && apt-get upgrade -yq && apt-get install -yq rsyslog postfix dovecot-imapd dovecot-ldap postfix-ldap supervisor

ADD assets/aliases.txt           /etc/aliases
ADD assets/supervisord.conf      /etc/supervisor/conf.d/supervisord.conf
ADD assets/postfix-wrapper.sh    /usr/sbin/postfix-wrapper.sh
ADD assets/dovecot-wrapper.sh    /usr/sbin/dovecot-wrapper.sh
ADD assets/mail-initializer.sh   /usr/sbin/mail-initializer.sh

EXPOSE 25/tcp 587/tcp
CMD ["/usr/sbin/mail-initializer.sh"]
