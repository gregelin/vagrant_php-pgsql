--
-- Public Inspection File PostgreSQL Set Up Script
-- Creates PostgreSQL database schema, database, roles, tables
-- for SAMPLEDB Application
--
-- Created by Greg Elin <greg.elin@fcc.gov>
-- Version 0.1.0     03.21.2013
--

--
-- Dependency
-- database sampledb must exist. Create from shell CLI with following:
-- createdb sampledb --username=postgres --host=localhost
--

--
-- SET configuration
--
SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: sample; Type: SCHEMA; Schema: -; Owner: sample_user
--
CREATE SCHEMA sample;

--
-- Create sampledb_dbo_role
--
CREATE ROLE sampledb_dbo_role
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;

GRANT all privileges on database sampledb to sampledb_dbo_role;
GRANT all privileges on SCHEMA sample to sampledb_dbo_role;

--
-- Create sample_user
--
CREATE ROLE sample_user LOGIN password 'sample_password'
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;
GRANT sampledb_dbo_role TO sample_user;

--
-- Create sampledb_select_role
--
CREATE ROLE sampledb_select_role
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;

ALTER SCHEMA sample OWNER TO sample_user;

--
-- Name: staging; Type: SCHEMA; Schema: -; Owner: postgres
--
CREATE SCHEMA staging;
ALTER SCHEMA staging OWNER TO postgres;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--
CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;
ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;
SET search_path = sample, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

--
-- Name: contact; Type: TABLE; Schema: sample_ Owner: sample_user; Tablespace: 
--
CREATE TABLE contact (
    contact_id integer NOT NULL,
    call_sign character varying(10),
    first_name character varying(50),
    last_name character varying(50),
    phone character varying(20),
    email text,
    website_url text,
    time_stamp timestamp with time zone
);

--
-- Name: contact_contact_id_seq; Type: SEQUENCE; Schema: sample_ Owner: sample_user
--
CREATE SEQUENCE contact_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE sample.contact_contact_id_seq OWNER TO sample_user;

--
-- Name: contact_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: sample; Owner: sample_user
--
ALTER SEQUENCE contact_contact_id_seq OWNED BY contact.contact_id;

--
-- Name: contact_contact_id_seq; Type: SEQUENCE SET; Schema: sample_ Owner: sample_user
--
SELECT pg_catalog.setval('contact_contact_id_seq', 2160, true);

--
-- Data for Name: contact; Type: TABLE DATA; Schema: staging; Owner: postgres
--
COPY contact (contact_id, first_name, last_name, phone, phone_ext, email, website_url, time_stamp) FROM stdin;
2096	Han	Solo	801-303-8500	han@hotmail.com	myspace.com/han	2012-10-16 12:24:24-04
2097	Princess	Leah	801-315-1111	princess@gmail.com	princessleah.me	2012-10-16 13:12:38-04
2098	Luke	Skywalker	202-555-1212	luke@destiny.com	skywalker.github.com	2012-10-16 13:52:06-04
\.


