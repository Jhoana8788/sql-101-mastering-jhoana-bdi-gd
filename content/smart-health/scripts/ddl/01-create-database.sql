--01. create user
CREATE USER sm_admin WITH PASSWORD 'sm2025**'

--02. create database (with ENCODING ='UTF8)
CREATE DATABASE smarthdb WITH
ENCODING='UTF8'
LC_COLLATE='es_CO.UTF-8'
LC_CTYPE='es_CO.UTF-8'
TEMPLATE=templateo0
OWNER = sm_admin

--03. grant privileges
GRANT ALL PRIVILEGES ON DATEBASE smarthdb TO sm_admin;

-- 04. Create Schema APLICA DESPUES\C
CREATE SCHEMA IF NOT EXISTS smart_health AUTHORIZATION sm_admin;

-- 05. Comment on database
COMMENT ON DATABASE smarthdb IS 'Base de datos para el control de pacientes y citas';
-- 06. Comment of schema
COMMENT ON SCHEMA smart_health IS 'Esquema principal para el control de pacientes y citas';