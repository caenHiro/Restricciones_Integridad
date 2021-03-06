﻿SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION INSERTA_ACREDITACION_REPRESENTANTE(ID_RESPONSABLE_ACREDITACION NUMERIC(10,0), 
  ID_REPRESENTANTE_PRELIMINAR NUMERIC(10,0));
**/
CREATE OR REPLACE FUNCTION INSERTA_ACREDITACION_REPRESENTANTE(ID_RESPONSABLE_ACREDITACION NUMERIC(10,0), 
  ID_REPRESENTANTE_PRELIMINAR NUMERIC(10,0))
  RETURNS Integer AS $$
    DECLARE
      VAR_FECHA_HORA TIMESTAMP := NOW();
      VAR_USUARIO VARCHAR(50) := CURRENT_USER;
      VAR_ID_REPRE_PRE_ACREDITADO INTEGER;
      VAR_ID_REPRE_DATOS INTEGER; 
      VAR_REPRESENTANTES_PRELIMINARES REPRESENTANTES_PRELIMINARES%ROWTYPE;
  BEGIN
    VAR_ID_REPRE_DATOS := (SELECT ID_REPRESENTANTE_DATOS FROM REPRESENTANTES_PRELIMINARES 
      WHERE ID_REPRESENTANTE_PRE = ID_REPRESENTANTE_PRELIMINAR ); 
    FOR VAR_REPRESENTANTES_PRELIMINARES IN SELECT * FROM REPRESENTANTES_PRELIMINARES 
      WHERE ID_REPRESENTANTE_DATOS = VAR_ID_REPRE_DATOS  ORDER BY  FECHA_HORA DESC
    LOOP
      IF (CUMPLE_CONDICION_ACREDITACION(VAR_REPRESENTANTES_PRELIMINARES))
        THEN 
        VAR_ID_REPRE_PRE_ACREDITADO := 
            VAR_REPRESENTANTES_PRELIMINARES.ID_REPRESENTANTE_PRE;
      END IF;
    END LOOP;   
    IF VAR_ID_REPRE_PRE_ACREDITADO IS NULL 
      THEN  
         RAISE EXCEPTION 'UPS! SE GENERO UN ERROR NO ES POSIBLE ACREDITAR AL REPRESENTANTE. -> %' , $2
         USING HINT = 
            'REVISA EL ID_REPRESENTANTE_PRELIMINAR, SE CUMPLA LAS CONDICIONES PARA SER ACREDITADO';
         RETURN 0 ;
      ELSE 
      INSERT INTO REPRESENTANTES_ACREDITADOS VALUES (1, VAR_ID_REPRE_PRE_ACREDITADO, VAR_ID_REPRE_DATOS,
        VAR_FECHA_HORA::DATE , ID_RESPONSABLE_ACREDITACION, VAR_FECHA_HORA::TIME ,DEFAULT , VAR_USUARIO ,  VAR_FECHA_HORA );
    END IF;
	return 1 ;
  END;
$$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION INSERTA_ACREDITACION_REPRESENTANTE (ID_RESPONSABLE_ACREDITACION NUMERIC(10,0), 
  ID_REPRESENTANTE_PRELIMINAR NUMERIC(10,0))  IS 'Procedimiento encargado de guardar información de una acreditación de un
   representante preliminar, para esto, primero se busca en la tabla de representantes_preliminares para saber cuántos 
   representantes preliminares tienen el mismo id_representante_datos, los ordenamos por fecha de registro y vamos viendo de
   esa lista de representantes buscamos cuál es el primero que cumple las condiciones para poder ser acreditado, para esta 
   validación se ocupa la funcion  cumple_condicion_acreditacion, una ves que se  encuentra al representante que se puede 
   acreditar proseguimos a la inserción de este en la tabla representantes_acreditados, como se puede notar siempre mandamos
   el mismo id_representante_pre con el valor 1, esto es debido a que tenemos un trigger encargado de colocar el valor
   correspondiente al identificador antes de la inserción.';