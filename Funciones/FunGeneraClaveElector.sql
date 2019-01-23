SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION GENERA_CLAVE_ELECTOR( VARCHAR(80) , DATE , CHAR(1));
**/
CREATE OR REPLACE FUNCTION GENERA_CLAVE_ELECTOR (VARCHAR(80) , DATE , CHAR(1)) 
RETURNS VARCHAR(50)  AS $$
  DECLARE
       ESPACIOSBLANCOS INTEGER;
  BEGIN
   ESPACIOSBLANCOS := (SELECT ARRAY_LENGTH( ( STRING_TO_ARRAY  ($1, ' ' )) , 1)  CARACTERBLANCO);
     RETURN   UPPER(SUBSTRING(SPLIT_PART($1, ' ', ESPACIOSBLANCOS-1) FROM 
              '[Á|É|Í|Ó|Ú|Ü|Ñ|Á|É|Í|Ó|Ú|Ü|A|E|I|O|U|A|E|I|O|U]'))
                      || UPPER(SUBSTRING(SPLIT_PART($1, ' ', ESPACIOSBLANCOS) FROM '[A-Z]'))
                      || UPPER(SUBSTRING(SPLIT_PART($1, ' ', 1 ) FROM '[A-Z]'))
                      || SUBSTRING(CAST(DATE_PART('YEAR', $2) AS TEXT) FROM 3 FOR 4)
                      || (CASE WHEN  CAST((SUBSTRING(CAST(DATE_PART('MONTH', $2) AS TEXT) 
                      FROM 1 FOR 2) ) AS INTEGER)  < 10 THEN  (0 || (SUBSTRING(CAST(DATE_PART('MONTH', $2) 
                      AS TEXT) FROM 1 FOR 2))) ELSE
                      ( SUBSTRING(CAST(DATE_PART('MONTH', $2) AS TEXT) FROM 1 FOR 2 )) END )
                      || (SUBSTRING(CAST(DATE_PART('DAY', $2) AS TEXT) FROM 1 FOR 2))
                      || $3;
    END;
    $$ LANGUAGE PLPGSQL;
    
COMMENT ON FUNCTION GENERA_CLAVE_ELECTOR(  VARCHAR(80) , DATE , CHAR(1)  ) IS
	'Función encargada de regresar la clave de elector dado los parámetros de: nombre , apellido paterno ,
    apellido materno , fecha de nacimiento y el sexo del representante.';