CREATE OR REPLACE PROCEDURE CREATE_REFERENCE(ref_name varchar, fields json) AS $$
DECLARE
  command_md_ref text;
  command_md_ref_fields text;
  command_create_table text;
  ref_id int;
  ref_table_name text;

  error_message text;
  error_number text;
BEGIN
  command_md_ref := BUILD_COMMAND_FOR_INSERT_MD_REF(ref_name);
  EXECUTE command_md_ref INTO ref_id;

  command_md_ref_fields := BUILD_COMMAND_FOR_INSERT_REF_FIELDS(ref_id, fields);

  command_create_table := BUILD_COMMAND_FOR_CREATE_TABLE(
    GET_REF_TABLE_NAME(ref_name),
    fields
  );

  EXECUTE command_md_ref_fields;
  EXECUTE command_create_table;
EXCEPTION
  WHEN others THEN
    ROLLBACK;
    GET STACKED DIAGNOSTICS error_message = MESSAGE_TEXT,
                            error_number = RETURNED_SQLSTATE;
    RAISE EXCEPTION 'Message: % |***| Error code: %',
                            error_message, error_number;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_INSERT_MD_REF(
  ref_name varchar) RETURNS text AS $$
DECLARE
  new_table_name text;
  command text;
BEGIN
  new_table_name := GET_NEW_REF_TABLE_NAME();
  command := format('INSERT INTO md_refs (ref_name, table_name) ');
  command := command || format('VALUES (%L, %L) ', ref_name, new_table_name);
  command := command || 'RETURNING id;';
  RETURN command;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_INSERT_REF_FIELDS(
  ref_id int, fields json) RETURNS text AS $$
DECLARE
  command text;
  fields_cursor CURSOR FOR SELECT * from json_array_elements(fields);
  field_name text;
  field_type text;
BEGIN
  command := '';
  FOR field IN fields_cursor LOOP
    command := command || 'INSERT INTO md_refs_fields (ref, name, type) VALUES (';
    field_name := field.value::json->>'name';
    field_type := field.value::json->>'type';
    command := command || format('%s, %L, %L); ', ref_id, field_name, field_type);
  END LOOP;
  RETURN command;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_NEW_REF_TABLE_NAME() RETURNS text AS $$
DECLARE
BEGIN
  RETURN 'ref_'::text || CAST(nextval('ref_tables') AS text);
END
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_REF_TABLE_NAME(ref_name_in varchar) RETURNS text AS $$
DECLARE
    table_name_output text;
BEGIN
  SELECT table_name
  INTO table_name_output
  FROM md_refs
  WHERE ref_name=$1;
  RETURN table_name_output;
END
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_CREATE_TABLE(
  new_table_name varchar, fields json) RETURNS text AS $$
DECLARE
  create_command text;
  field_name text;
  field_type text;
  fields_cursor CURSOR FOR SELECT * from json_array_elements(fields);
BEGIN

  create_command := format('create table %s (id serial', new_table_name);
  FOR field IN fields_cursor LOOP
    field_name := field.value::json->>'name';
    field_type := CONVERT_TYPE(field.value::json->>'type');
    create_command := create_command || format(', %s %s', field_name, field_type);
  END LOOP;
  create_command := create_command || ');';

  RETURN create_command;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CONVERT_TYPE(
  type_name varchar(50)) RETURNS varchar(50) AS $$
DECLARE
  output_type varchar(50);
BEGIN
  SELECT type_system
  INTO output_type
  FROM md_types
  WHERE type_md = type_name;

  IF output_type IS NULL
  THEN
    RAISE EXCEPTION 'Bad type %. There are only types string, text and number', type_name;
  END IF;

  RETURN output_type;
END;
$$
LANGUAGE plpgsql;


CREATE TYPE field AS (
  name varchar,
  type varchar
);


CREATE OR REPLACE FUNCTION GET_REFERENCE(reference_name text) RETURNS SETOF field AS $$
BEGIN
  RETURN QUERY
  SELECT f.name, f.type
  FROM md_refs_fields as f,
       md_refs        as r
  WHERE f.ref = r.id and r.ref_name = reference_name;

  IF NOT FOUND THEN
      RAISE EXCEPTION 'No reference named %s', $1;
  END IF;

  RETURN;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE DELETE_REFERENCE(reference_name text) AS $$
DECLARE
  command_delete_md_ref text;
  command_delete_md_ref_fields text;
  command_delete_table text;

  error_message text;
  error_number text;
BEGIN

  command_delete_table := BUILD_COMMAND_FOR_DELETE_TABLE(
    GET_REF_TABLE_NAME(reference_name)
  );
  command_delete_md_ref_fields := BUILD_COMMAND_FOR_DELETE_REF_FIELDS(
    GET_REF_ID_BY_NAME(reference_name)
  );
  command_delete_md_ref := BUILD_COMMAND_FOR_DELETE_MD_REF(reference_name);

  EXECUTE command_delete_table;
  EXECUTE command_delete_md_ref_fields;
  EXECUTE command_delete_md_ref;

EXCEPTION
  WHEN others THEN
    ROLLBACK;
    GET STACKED DIAGNOSTICS error_message = MESSAGE_TEXT,
                            error_number = RETURNED_SQLSTATE;
    RAISE EXCEPTION 'Message: % |***| Error code: %',
                            error_message, error_number;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_DELETE_TABLE(table_name varchar) RETURNS text AS $$
BEGIN
  RETURN format('DROP TABLE %s;', table_name);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_DELETE_REF_FIELDS(ref_id int) RETURNS text AS $$
BEGIN
  RETURN format('DELETE FROM md_refs_fields WHERE id=%s;', ref_id);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_REF_ID_BY_NAME(reference_name text) RETURNS int AS $$
DECLARE
    ref_id text;
BEGIN
  SELECT id
  INTO ref_id
  FROM md_refs
  WHERE ref_name=reference_name;
  RETURN ref_id;
END
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_DELETE_MD_REF(reference_name text) RETURNS text AS $$
BEGIN
  RETURN format('DELETE FROM md_refs WHERE ref_name=%L;', reference_name);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_REFERENCES_LIST() RETURNS SETOF text AS $$
BEGIN
  RETURN QUERY
  SELECT ref_name
  FROM   md_refs;

  RETURN;
END
$$
LANGUAGE plpgsql;
