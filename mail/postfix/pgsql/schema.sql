-- Minimalist virtual user configuration for postfix
DROP TABLE IF EXISTS virtual_aliases;
DROP TABLE IF EXISTS virtual_users;
DROP TABLE IF EXISTS virtual_domains;

CREATE TABLE virtual_domains (
  domain_id serial PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE virtual_users (
  user_id serial PRIMARY KEY,
  domain_id int REFERENCES virtual_domains ON DELETE CASCADE,
  password text NOT NULL,
  email text NOT NULL
);

CREATE TABLE virtual_aliases (
  alias_id serial PRIMARY KEY,
  domain_id int REFERENCES virtual_domains ON DELETE CASCADE,
  source text NOT NULL,
  destination text NOT NULL
);

-- Single domain for simplicity at the moment
INSERT INTO virtual_domains (name) VALUES ('{{ pillar['mail']['domain'] }}');

{% for user in pillar['mail']['users'] %}
INSERT INTO virtual_users (domain_id, password, email)
VALUES ((SELECT domain_id FROM virtual_domains
         WHERE name='{{ pillar['mail']['domain'] }}'),
        '{{ user.password }}',
        '{{ user.email }}');
{% endfor %}

GRANT SELECT ON virtual_domains TO {{ pillar['mail']['dbuser'] }};
GRANT SELECT ON virtual_users TO {{ pillar['mail']['dbuser'] }};
GRANT SELECT ON virtual_aliases TO {{ pillar['mail']['dbuser'] }};
