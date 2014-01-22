include:
  - postgresql
  - opendkim
  - dspam
  - roundcube


/var/mail/encrypted:
  file.directory:
    - makedirs: True


encfs:
  pkg.installed


/var/mail/decrypted:
  mount.mounted:
    - fstype: fuse
    - device: encfs#/var/mail/encrypted
    - mkmnt: True
    - opts: 
      - allow_other
      - default_permissions
    - require:
      - file: /var/mail/encrypted
      - pkg: encfs
  file.directory:
    - owner: root
    - group: mail
    - mode: 775
    - require:
      - mount: /var/mail/decrypted


packages:
  pkg.installed:
    - pkgs:
      - dovecot-core
      - dovecot-imapd
      - dovecot-pgsql
      - dovecot-lmtpd


mailuser:
  postgres_user.present:
    - name: {{ pillar['mail']['dbuser'] }}
    - password: {{ pillar['mail']['dbpass'] }}
    - runas: postgres
    - require:
      - service: postgresql


mailserver:
  postgres_database.present:
    - name: {{ pillar['mail']['dbname'] }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - owner: {{ pillar['mail']['dbuser'] }}
    - runas: postgres
    - require:
      - postgres_user: mailuser


/etc/postfix/main.cf:
  file.managed:
    - source: salt://mail/postfix/main.cf
    - template: jinja
    - user: root
    - group: postfix
    - mode: 644
    - require:
      - pkg: postfix


/etc/postfix/master.cf:
  file.managed:
    - source: salt://mail/postfix/master.cf
    - user: root
    - group: postfix
    - mode: 644
    - require:
      - pkg: postfix


/etc/postfix/pgsql:
  file.directory:
    - user: postfix
    - group: postgres
    - mode: 550
    - makedirs: True
    - require:
      - pkg: postfix


/etc/postfix/pgsql/virtual_mailbox_domains.cf:
  file.managed:
    - source: salt://mail/postfix/pgsql/virtual_mailbox_domains.cf
    - template: jinja
    - user: root
    - group: postfix
    - mode: 640
    - require:
      - pkg: postfix


/etc/postfix/pgsql/virtual_mailbox_maps.cf:
  file.managed:
    - source: salt://mail/postfix/pgsql/virtual_mailbox_maps.cf
    - template: jinja
    - user: root
    - group: postfix
    - mode: 640
    - require:
      - pkg: postfix


/etc/postfix/pgsql/virtual_alias_maps.cf:
  file.managed:
    - source: salt://mail/postfix/pgsql/virtual_alias_maps.cf
    - template: jinja
    - user: root
    - group: postfix
    - mode: 640
    - require:
      - pkg: postfix


/etc/postfix/pgsql/schema.sql:
  file.managed:
    - source: salt://mail/postfix/pgsql/schema.sql
    - template: jinja
    - user: root
    - group: postgres
    - mode: 640
    - require:
      - pkg: postfix


postfix_database_schema:
  cmd.wait:
    - user: postgres
    - name: psql -1 {{ pillar['mail']['dbname'] }} < /etc/postfix/pgsql/schema.sql
    - watch:
      - file: /etc/postfix/pgsql/schema.sql
      - postgres_database: mailserver
    - require:
      - postgres_database: mailserver


postfix-pgsql:
  pkg.installed


postfix:
  pkg:
    - installed
  service.running:
    - enabled: True
    - watch: 
      - file: /etc/postfix/main.cf
      - file: /etc/postfix/master.cf
    - require:
      - mount: /var/mail/decrypted
      - service: opendkim
      - pkg: postfix-pgsql
      - cmd: postfix_database_schema
      - file: /etc/postfix/main.cf
      - file: /etc/postfix/pgsql/virtual_mailbox_domains.cf
      - file: /etc/postfix/pgsql/virtual_mailbox_maps.cf
      - file: /etc/postfix/pgsql/virtual_alias_maps.cf


/etc/dovecot/dovecot.conf:
  file.managed:
    - source: salt://mail/dovecot/dovecot.conf
    - user: root
    - group: dovecot
    - mode: 640


/etc/dovecot/dovecot-sql.conf.ext:
  file.managed:
    - source: salt://mail/dovecot/dovecot-sql.conf.ext
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640


/etc/dovecot/conf.d:
  file.directory:
    - user: root
    - group: dovecot
    - mode: 550
    - makedirs: True

/var/lib/dovecot:
  file.directory:
    - user: root
    - group: mail
    - mode: 750
    - makedirs: True


/var/lib/dovecot/sieve:
  file.directory:
    - user: root
    - group: mail
    - mode: 750
    - makedirs: True


/var/lib/dovecot/sieve/before.sieve:
  file.managed:
    - source: salt://mail/dovecot/before.sieve
    - user: root
    - group: mail
    - mode: 640
    - require:
      - file: /var/lib/dovecot/sieve


/etc/dovecot/conf.d/10-auth.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/10-auth.conf
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/10-mail.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/10-mail.conf
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/10-master.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/10-master.conf
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/10-ssl.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/10-ssl.conf
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/20-imap.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/20-imap.conf
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/20-lmtp.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/20-lmtp.conf
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/90-sieve.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/90-sieve.conf
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/90-plugin.conf:
  file.managed:
    - source: salt://mail/dovecot/conf.d/90-plugin.conf
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


/etc/dovecot/conf.d/auth-sql.conf.ext:
  file.managed:
    - source: salt://mail/dovecot/conf.d/auth-sql.conf.ext
    - template: jinja
    - user: root
    - group: dovecot
    - mode: 640
    - require:
      - file: /etc/dovecot/conf.d


dovecot:
  service.running:
    - enabled: True
    - watch:
      - file: /etc/dovecot/dovecot.conf
      - file: /etc/dovecot/dovecot-sql.conf.ext
    - require:
      - mount: /var/mail/decrypted
      - file: /etc/dovecot/dovecot.conf
      - file: /etc/dovecot/conf.d/auth-sql.conf.ext
      - service: postfix
