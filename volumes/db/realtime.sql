-- Realtime setup
\set pgpass `echo "$POSTGRES_PASSWORD"`

CREATE SCHEMA IF NOT EXISTS _realtime;
ALTER SCHEMA _realtime OWNER TO postgres;