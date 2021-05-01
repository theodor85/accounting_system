-- Метаданные

-- очистка
DROP TABLE IF EXISTS md_refs_fields;
DROP TABLE IF EXISTS md_refs;
DROP TABLE IF EXISTS md_types;

-- типы данных для полей
CREATE TABLE IF NOT EXISTS md_types  (
    type_md varchar(50) PRIMARY KEY,
    type_system varchar(50)
);

INSERT INTO md_types (type_md, type_system) VALUES ('text', 'text');
INSERT INTO md_types (type_md, type_system) VALUES ('string', 'varchar(255)');
INSERT INTO md_types (type_md, type_system) VALUES ('number', 'numeric(14, 2)');

-- справочники
CREATE TABLE IF NOT EXISTS md_refs  (
    id serial PRIMARY KEY,
    ref_name text UNIQUE,
    table_name varchar(10) UNIQUE
);

-- поля для справочников
CREATE TABLE IF NOT EXISTS md_refs_fields  (
    id serial PRIMARY KEY,
    ref int,
    name varchar(100),
    type varchar(50),
    CONSTRAINT fk_ref
      FOREIGN KEY (ref) REFERENCES md_refs (id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT fk_type
      FOREIGN KEY (type) REFERENCES md_types (type_md)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

-- последовательность для номеров таблиц справочников
CREATE SEQUENCE ref_tables;
