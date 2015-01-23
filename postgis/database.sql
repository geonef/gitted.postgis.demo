--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: postgis_viewer_image(text, text, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_viewer_image(param_sql text, param_spatial_type text DEFAULT 'geometry'::text, param_rgb integer[] DEFAULT NULL::integer[]) RETURNS bytea
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $_$
  DECLARE var_result bytea;
  DECLARE var_bandtypes text[] := ARRAY['8BUI', '8BUI', '8BUI'];
  BEGIN
      IF param_spatial_type = 'geometry' THEN
        EXECUTE 'SELECT ST_AsPNG(ST_AsRaster((' || param_sql || '), 200,200,$1,$2, ARRAY[0,0,0]))' INTO STRICT var_result USING var_bandtypes, param_rgb ;
      ELSIF param_spatial_type = 'raster' THEN
        EXECUTE 'SELECT ST_AsPNG((' || param_sql || '), ARRAY[1,2,3])' INTO STRICT var_result;
	  ELSE -- assume raw
		EXECUTE param_sql INTO STRICT var_result;
      END IF;
      RETURN var_result;
 END
$_$;


ALTER FUNCTION public.postgis_viewer_image(param_sql text, param_spatial_type text, param_rgb integer[]) OWNER TO postgres;

--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

