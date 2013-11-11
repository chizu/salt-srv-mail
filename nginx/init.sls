nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True

/etc/nginx/sites-enabled/default:
  file.absent