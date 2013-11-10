/var/mail/encrypted:
  file.directory:
    - makedirs: True


/var/mail/decrypted:
  file.directory:
    - group: mail
    - mode: 660
    - makedirs: True


packages:
  pkg.installed:
    - pkgs:
      - encfs
      - dovecot-core
      - dovecot-imapd
      - dovecot-pgsql
      - dovecot-lmtpd


postgresql:
  pkg:
    - installed
  service.running:
    - enabled: True


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
    - user: root
    - group: postfix
    - mode: 640
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
    - require:
      - pkg: postfix-pgsql
      - cmd: postfix_database_schema
      - file: /etc/postfix/main.cf
      - file: /etc/postfix/pgsql/virtual_mailbox_domains.cf
      - file: /etc/postfix/pgsql/virtual_mailbox_maps.cf
      - file: /etc/postfix/pgsql/virtual_alias_maps.cf
