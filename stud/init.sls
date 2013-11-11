stud:
  pkg:
    - installed
  service:
    - running
    - enabled: True
    - watch: 
      - file: /etc/stud/stud.conf


/etc/stud/stud.conf:
  file.managed:
    - source: salt://stud/stud.conf
