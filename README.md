# docker-mail
Simple [postfix-based][postfix] *mail transfer agent* docker image. Reasonable default configuration is included, but there is also room for customization.

Configured according to [this digitalocean tutorial][digitalocean1]. You can use `/data/initial-configs` to customize dovecot settings. Include the extra settings in `/data/initial-configs/dovecot-extra.conf`,
and pass the volume `/data` to the container. See `/data/initial-configs/dovecot-extra.conf.passwd-file-sample` as an example.

[postfix]: "http://en.wikipedia.org/wiki/Postfix_(software)"
[digitalocean1]: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-postfix-e-mail-server-with-dovecot

## Usage

Files:

* `/data/initial-configs/mail.key` & `/data/initial-configs/mailcert.pem` 		<br/>
   An SSL key+certificate pair valid for your mail domain.
* `/data/initial-configs/dovecot-extra.conf`  									<br/>
   Authentication and also customization dovecot config, see samples.

Environment variables expected:

* `FULL_HOSTNAME`:         e.g. mail.example.org
* `ROOT_ALIAS_ADDRESS`:    (optional) Gets the local emails. e.g. admin@example.org

**The Command**:

	# No inbox, just send emails
    $ docker run --name=mail_server --restart=always -d -p 25:25 -p 587:587 -e FULL_HOSTNAME=mail.example.org -v <ABSOLUTE_PATH>/mail-data-volume:/data remohammadi/mail
	# With more opritons
    $ docker run -p 25:25 -p 587:587 -e FULL_HOSTNAME=mail.example.org -e ROOT_ALIAS_ADDRESS=admin@example.org -v <ABSOLUTE_PATH>/mail-data-volume:/data remohammadi/mail

## TODO
 * LDAP integration
 * DKIM
 
## Contribute
Pull requests are welcomed.
