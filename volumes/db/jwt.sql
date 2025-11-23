-- Set JWT secret for pgjwt extension
\set jwt_secret `echo "$JWT_SECRET"`

ALTER DATABASE postgres SET "app.settings.jwt_secret" TO :'jwt_secret';