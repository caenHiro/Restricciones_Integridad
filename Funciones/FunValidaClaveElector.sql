SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION IS_REPRESENTANTES_VALIDA_CLAVE_ELECTOR (VARCHAR(20);
**/
CREATE OR REPLACE FUNCTION VALIDA_CLAVE_ELECTOR (VARCHAR(20)) 
RETURNS BOOLEAN  AS $$ 
    BEGIN   
    IF (SELECT CHAR_LENGTH ($1) = 11)
	   THEN 
 		   RETURN ( (SELECT CHAR_LENGTH ( $1 ) = 11 ) AND (SELECT 
        TEXTREGEXEQ (SUBSTRING ( $1 ,1, 4 ), '([A-Z]{1,4})' ) ) AND (
        select TEXTREGEXEQ ( SUBSTRING ( $1 ,5, 6 ) , 
          '^[0-9][0-9][0-9][0-9][0-9][0-9]{1,6}' )) AND (SELECT TEXTREGEXEQ 
        (SUBSTRING ( $1 ,11, 11 ) , '[H|M]{1}') ) );
      ELSE
        RETURN FALSE;
    END IF;
    END;
    $$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION VALIDA_CLAVE_ELECTOR(  VARCHAR(20)    ) IS
  'Función encargada de validar que la clave de elector contenga el formato solicitado, esto es que  esté conformada por 4 
   caracteres alfabéticos que son las consonantes iniciales de los apellidos y el nombre del elector, 6 numéricos que contienen su 
   fecha de nacimiento iniciando por el año  y uno del sexo H si es hombre y M si es mujer.'; 