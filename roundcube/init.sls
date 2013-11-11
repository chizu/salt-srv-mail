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


/etc/nginx/sites-enabled/roundcube.conf:
  file.managed:
    - source: salt://roundcube/nginx.conf
    - requires:
      - pkg: nginx
