SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION IS_CADENA(VARCHAR(50));
**/
CREATE OR REPLACE FUNCTION IS_CADENA( VARCHAR(50) ) 
RETURNS BOOLEAN  AS $$
    BEGIN
	IF( SELECT CHAR_LENGTH($1) <= 50 )
	THEN
	IF ((SELECT TEXTREGEXEQ($1,
		'^[a-z|A-Z|Á|É|Í|Ó|Ú|Ü|Ñ|á|é|í|ó|ú|ü|ñ| ]+(\.[a-z|A-Z|Á|É|Í|Ó|Ú|Ü|Ñ|á|é|í|ó|ú|ü|ñ| ]+)?$'
		) ) = TRUE   )
	THEN
      RETURN TRUE;
	ELSE
	RETURN FALSE;
	END IF;
	ELSE
	 RAISE EXCEPTION 'UPS! SE GENERO UN ERROR AL VALIDAR LA CADENA. -> %' , $1 
	 USING HINT = 'SUPERO LA LONGITUD DE 50 CARACTERES, INTENTA CON UNA PALABRA MAS CORTA.';
	END IF;
    END;
    $$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION IS_CADENA( VARCHAR(50) ) IS
	' Función encargada de validar que las cadenas que se evalúa sea una cadenas
	 válidaa, es decir, que no contengan números o caracteres extras al principio, en medio o al final de la cadena.';