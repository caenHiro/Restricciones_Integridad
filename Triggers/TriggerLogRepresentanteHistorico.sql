﻿SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION LOG_TRIGGER_HISTORICO();
**/
CREATE OR REPLACE FUNCTION LOG_TRIGGER_HISTORICO()
RETURNS TRIGGER AS $$
DECLARE
	VAR_USUARIO VARCHAR(50) := CURRENT_USER;
	VAR_HORA_FECHA TIMESTAMP := NOW();
	VAR_TUPLA RECORD;
	VAR_TIPO_OP CHAR;
 BEGIN
		IF TG_OP = 'UPDATE' THEN
		   VAR_TIPO_OP := 'U';
		   VAR_TUPLA := NEW;
		ELSIF TG_OP = 'INSERT' THEN
		   VAR_TIPO_OP := 'I';
		   VAR_TUPLA := NEW;
		ELSE
		   VAR_TIPO_OP := 'D';
		   VAR_TUPLA := OLD;
		END IF;
		IF UPPER(TG_TABLE_NAME) = 'REPRESENTANTES_DATOS' THEN
			INSERT INTO REPRESENTANTES.REPRESENTANTES_DATOS_HISTORICO VALUES ( 1, VAR_TIPO_OP , VAR_TUPLA.ID_REPRESENTANTE_DATOS , VAR_TUPLA.CLAVE_ELECTOR , VAR_TUPLA.NOMBRE,
							VAR_TUPLA.APELLIDO_PATERNO, VAR_TUPLA.APELLIDO_MATERNO , VAR_TUPLA.SEXO , VAR_TUPLA.DOMICILIO , VAR_TUPLA.USUARIO,
							VAR_TUPLA.FECHA_HORA );

		ELSIF UPPER(TG_TABLE_NAME) = 'REPRESENTANTES_PRELIMINARES' THEN
			INSERT INTO REPRESENTANTES.REPRESENTANTES_PRELIMINARES_HISTORICO VALUES ( 1, VAR_TIPO_OP, VAR_TUPLA.ID_REPRESENTANTE_PRE , VAR_TUPLA.ID_REPRESENTANTE_DATOS ,
							VAR_TUPLA.ID_ESTADO , VAR_TUPLA.ID_DISTRITO_FEDERAL , VAR_TUPLA.TIPO_ASOCIACION , VAR_TUPLA.ID_PARTIDO_CANDIDATO , 
							VAR_TUPLA.CLAVE_ELECTOR , VAR_TUPLA.USUARIO , VAR_TUPLA.FECHA_HORA);

		ELSIF UPPER(TG_TABLE_NAME) = 'REPRESENTANTES_CASILLA' THEN
			INSERT INTO REPRESENTANTES.REPRESENTANTES_CASILLA_HISTORICO VALUES ( 1, VAR_TIPO_OP ,   VAR_TUPLA.ID_REPRESENTANTE_PRE , VAR_TUPLA.ID_REPRESENTANTE_DATOS , VAR_TUPLA.ID_ESTADO, 
							VAR_TUPLA.ID_DISTRITO_FEDERAL, VAR_TUPLA.CALIDAD_REPRESENTANTE , VAR_TUPLA.SECCION , 
							VAR_TUPLA.TIPO_CASILLA , VAR_TUPLA.USUARIO , VAR_TUPLA.FECHA_HORA);

		ELSIF UPPER(TG_TABLE_NAME) = 'REPRESENTANTES_GENERALES' THEN
			INSERT INTO REPRESENTANTES.REPRESENTANTES_GENERALES_HISTORICO VALUES (1,  VAR_TIPO_OP , VAR_TUPLA.ID_REPRESENTANTE_PRE , VAR_TUPLA.ID_REPRESENTANTE_DATOS , VAR_TUPLA.ID_ESTADO , 
							VAR_TUPLA.ID_DISTRITO_FEDERAL, VAR_TUPLA.USUARIO , VAR_TUPLA.FECHA_HORA );

		ELSIF UPPER(TG_TABLE_NAME) = 'REPRESENTANTES_ACREDITADOS' THEN
			INSERT INTO REPRESENTANTES.REPRESENTANTES_ACREDITADOS_HISTORICO VALUES ( 1,  VAR_TIPO_OP , VAR_TUPLA.ID_REPRESENTANTE_ACRE , VAR_TUPLA.ID_REPRESENTANTE_PRE ,VAR_TUPLA.ID_REPRESENTANTE_DATOS ,
							VAR_TUPLA.FECHA_ACREDITACION, VAR_TUPLA.ID_RESPONBLE_ACRE , VAR_TUPLA.HORA_ACREDITACION , VAR_TUPLA.ACTIVO , 
							VAR_TUPLA.USUARIO , VAR_TUPLA.FECHA_HORA);
		ELSE
			  RAISE EXCEPTION 'UPS! SE GENERO UN ERROR YA QUE NO SE ENCUENTRA EL NOMBRE DE LA TABLA -> %' , TG_TABLE_NAME
	          USING HINT = 'COMUNICATE CON TU ADMINISTRADOR DE BASES DE DATOS.';
	          RETURN  NULL;
		END IF;	 
	RETURN VAR_TUPLA;
END;
$$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION LOG_TRIGGER_HISTORICO () is 'Procedimiento encargado de generar las iserciones en las tablas de los históricos.';
/**
DROP TRIGGER GENERA_IDS_REPRESENTANTES_ACREDITADOS;
**/
CREATE TRIGGER GENERA_HISTORICO_REPRESENTANTES_DATOS
    AFTER INSERT OR UPDATE OR DELETE ON REPRESENTANTES_DATOS
    FOR EACH ROW
    EXECUTE PROCEDURE LOG_TRIGGER_HISTORICO();

COMMENT ON TRIGGER GENERA_HISTORICO_REPRESENTANTES_DATOS ON REPRESENTANTES_DATOS is 'Trigger de la tabla 
REPRESENTANTES_DATOS';
/**
DROP TRIGGER GENERA_HISTORICO_REPRESENTANTES_PRELIMINARES;
**/
CREATE TRIGGER GENERA_HISTORICO_REPRESENTANTES_PRELIMINARES
    AFTER INSERT OR UPDATE OR DELETE ON REPRESENTANTES_PRELIMINARES
    FOR EACH ROW
    EXECUTE PROCEDURE LOG_TRIGGER_HISTORICO();

COMMENT ON TRIGGER GENERA_HISTORICO_REPRESENTANTES_PRELIMINARES ON REPRESENTANTES_PRELIMINARES is 'Trigger de la tabla 
REPRESENTANTES_PRELIMINARES';
/**
DROP TRIGGER GENERA_HISTORICO_REPRESENTANTES_CASILLA;
**/
CREATE TRIGGER GENERA_HISTORICO_REPRESENTANTES_CASILLA
    AFTER INSERT OR UPDATE OR DELETE ON REPRESENTANTES_CASILLA
    FOR EACH ROW
    EXECUTE PROCEDURE LOG_TRIGGER_HISTORICO();

COMMENT ON TRIGGER GENERA_HISTORICO_REPRESENTANTES_CASILLA ON REPRESENTANTES_CASILLA is 'Trigger de la tabla 
REPRESENTANTES_CASILLA';
/**
DROP TRIGGER GENERA_HISTORICO_REPRESENTANTES_GENERALES;
**/
CREATE TRIGGER GENERA_HISTORICO_REPRESENTANTES_GENERALES
    AFTER INSERT OR UPDATE OR DELETE ON REPRESENTANTES_GENERALES
    FOR EACH ROW
    EXECUTE PROCEDURE LOG_TRIGGER_HISTORICO();

COMMENT ON TRIGGER GENERA_HISTORICO_REPRESENTANTES_GENERALES ON REPRESENTANTES_GENERALES is 'Trigger de la tabla 
REPRESENTANTES_GENERALES';
/**
DROP TRIGGER GENERA_HISTORICO_REPRESENTANTES_ACREDITADOS;
**/
CREATE TRIGGER GENERA_HISTORICO_REPRESENTANTES_ACREDITADOS
    AFTER INSERT OR UPDATE OR DELETE ON REPRESENTANTES_ACREDITADOS
    FOR EACH ROW
    EXECUTE PROCEDURE LOG_TRIGGER_HISTORICO();

COMMENT ON TRIGGER GENERA_HISTORICO_REPRESENTANTES_ACREDITADOS ON REPRESENTANTES_ACREDITADOS is 'Trigger de la tabla 
REPRESENTANTES_ACREDITADOS';