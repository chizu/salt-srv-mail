opendkim:
  pkg:
    - installed
  service.running:
    - enabled: True
    - require:
      - file: /etc/opendkim
      - file: /etc/opendkim.conf
      - file: /etc/opendkim/KeyTable
      - file: /etc/opendkim/SigningTable
      - file: /etc/opendkim/TrustedHosts


opendkim-tools:
  pkg.installed


/etc/opendkim:
  file.directory:
    - user: opendkim
    - group: opendkim
    - mode: 700


opendkim-genkey -r -h rsa-sha256 -d {{ pillar['mail']['domain'] }} -s mail:
  cmd.wait:
    - cwd: /etc/opendkim
    - watch:
      - file: /etc/opendkim


/etc/opendkim/KeyTable:
  file.managed:
    - source: salt://opendkim/KeyTable
    - template: jinja
    - user: opendkim
    - group: opendkim
    - mode: 600
    - requires:
      -file: /etc/opendkim


/etc/opendkim/SigningTable:
  file.managed:
    - source: salt://opendkim/SigningTable
    - template: jinja
    - user: opendkim
    - group: opendkim
    - mode: 600
    - requires:
      -file: /etc/opendkim


/etc/opendkim/TrustedHosts:
  file.managed:
    - source: salt://opendkim/TrustedHosts
    - user: opendkim
    - group: opendkim
    - mode: 600
    - requires:
      -file: /etc/opendkim


/etc/opendkim.conf:
  file.managed:
    - source: salt://opendkim/opendkim.conf
    - user: opendkim
    - group: opendkim
    - mode: 600
