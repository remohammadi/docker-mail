#!/bin/bash

INITIALIZED_TIMESTAMP_FILE="/etc/mail-initialized"

usage() { 
    echo "$@" 1>&2;
    echo
    echo "Files: "
    echo " * /data/initial-configs/mail.key & /data/initial-configs/mailcert.pem"
    echo "   An SSL key+certificate pair valid for your mail domain."
    echo " * /data/initial-configs/dovecot-extra.conf"
    echo "   Authentication and also customization dovecot config, see samples."
    echo
    echo "Environment variables expected: (+ for optional)"
    echo " * FULL_HOSTNAME:         e.g. mail.example.org"
    echo " + ROOT_ALIAS_ADDRESS:    Gets the local emails. e.g. admin@example.org"
    exit 2
}

if [ ! -f $INITIALIZED_TIMESTAMP_FILE ]; then
    echo "Initializing Mail..."

    [ -f "/data/initial-configs/mailcert.pem" ] || usage "/data/initial-configs/mailcert.pem not found."
    [ -f "/data/initial-configs/mail.key" ] || usage "/data/initial-configs/mail.key not found."
    [ -f "/data/initial-configs/dovecot-extra.conf" ] || usage "/data/initial-configs/dovecot-extra.conf not found."
    [ "$FULL_HOSTNAME" ] || usage "FULL_HOSTNAME not set."


    #####################################################################
    # Writing configs                                                   #
    #####################################################################

    if [ "$ROOT_ALIAS_ADDRESS" ] ; then
        echo "root: $ROOT_ALIAS_ADDRESS" >> /etc/aliases
        echo "root alias address set to $ROOT_ALIAS_ADDRESS."
    else
        echo "No root alias address provided. No problem!"
    fi
    newaliases

    cat >> /etc/postfix/master.cf <<EOL
submission inet n       -       -       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_wrappermode=no
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=private/auth
EOL
    echo "/etc/postfix/master.cf is updated."

    cat > /etc/postfix/main.cf <<EOL
myhostname = $FULL_HOSTNAME
mydestination = $FULL_HOSTNAME, localhost, localhost.localdomain
relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit= 0
recipient_delimiter= +
inet_interfaces=all

smtpd_tls_cert_file=/data/initial-configs/mailcert.pem
smtpd_tls_key_file=/data/initial-configs/mail.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtpd_tls_security_level=may
smtpd_tls_protocols = !SSLv2, !SSLv3
EOL
    echo "/etc/postfix/main.cf is updated."


    cat > /etc/dovecot/dovecot.conf <<EOL
disable_plaintext_auth = no
mail_privileged_group = mail

mail_home = /var/mail/%u
mail_location = maildir:~/mail

protocols = " imap"
service auth {
  unix_listener /var/spool/postfix/private/auth {
    group = postfix
    mode = 0660
    user = postfix
  }
}
ssl=required
ssl_cert = </data/initial-configs/mailcert.pem
ssl_key = </data/initial-configs/mail.key

EOL
    cat /data/initial-configs/dovecot-extra.conf >> /etc/dovecot/dovecot.conf
    echo "/etc/dovecot/dovecot.conf is updated."


    TIMESTAMPE="$(date)"
    echo "$TIMESTAMPE" > $INITIALIZED_TIMESTAMP_FILE
    echo "Mail initialized @ $TIMESTAMPE."
fi

/usr/bin/supervisord
