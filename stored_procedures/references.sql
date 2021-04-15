CREATE OR REPLACE FUNCTION CREATE_REFERENCE(ref_name varchar, fields json) RETURNS void AS $$
DECLARE
BEGIN
  EXECUTE BUILD_COMMAND_FOR_CREATE_REF(ref_name, fields);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION BUILD_COMMAND_FOR_CREATE_REF(ref_name varchar, fields json) RETURNS text AS $$
DECLARE
  length int;
  create_command text;
  field_name text;
  field_type text;
BEGIN

  length := json_array_length(fields);

  create_command := format('create table %s (id serial ', ref_name);
  FOR i IN 0..length-1 LOOP
    field_name := (fields::json->>i)::json->>'name';
    field_type := CONVERT_TYPE((fields::json->>i)::json->>'type');
    create_command := create_command || format(', %s %s', field_name, field_type);
  END LOOP;
  create_command := create_command || ');';

  RETURN create_command;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CONVERT_TYPE(type_name text) RETURNS text AS $$
DECLARE
  output_type text;
BEGIN
  CASE type_name
    WHEN 'string' THEN
      output_type := 'varchar(255)';
    WHEN 'text' THEN
      output_type := 'text';
    WHEN 'number' THEN
      output_type := 'numeric(14, 2)';
    ELSE
      RAISE EXCEPTION 'Bad type %. There are only types string, text and number', type_name;
  END CASE;
  RETURN output_type;
END;
$$
LANGUAGE plpgsql;
