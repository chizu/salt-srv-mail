include:
  - nginx
  - postgresql


roundcube:
  pkg.installed


roundcube-pgsql:
  pkg.installed


php5-fpm:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - requires:
      - pkg: php-apc


php-apc:
  pkg.installed
