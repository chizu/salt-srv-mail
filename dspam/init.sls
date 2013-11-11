dspam:
  pkg.installed


dovecot-antispam:
  pkg.installed


postfix-pcre:
  pkg.installed


dovecot-sieve:
  pkg.installed


/etc/dspam/dspam.conf:
  file.managed:
    - source: salt://dspam/dspam.conf
    - requires:
      - pkg: dspam


/etc/dspam/default.prefs:
  file.managed:
    - source: salt://dspam/default.prefs
    - requires:
      - pkg: dspam


/etc/postfix/dspam_filter_access:
  file.managed:
    - source: salt://dspam/dspam_filter_access
    - requires:
      - pkg: postfix


/var/mail/decrypted/dspam:
  file.directory:
    - user: dspam
    - group: dspam
    - requires:
      - mount: /var/mail/decrypted
      - pkg: dspam
