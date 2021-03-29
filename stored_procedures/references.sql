-- CREATE OR REPLACE PROCEDURE CREATE_REFERENCE(
--   refefence_name
-- )
-- IS

CREATE OR REPLACE FUNCTION CREATE_REFERENCE(ref_name varchar) RETURNS void AS $$
DECLARE
BEGIN

  EXECUTE format('create table %s (id serial);', ref_name);

END;
$$
LANGUAGE plpgsql;
