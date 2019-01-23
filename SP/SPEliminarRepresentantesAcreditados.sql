SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION ELIMINA_REPRESENTANTE_ACREDITADO(ID_REPRE_ACREDITADO_IN NUMERIC(10,0) );
**/
CREATE OR REPLACE FUNCTION ELIMINA_REPRESENTANTE_ACREDITADO (ID_REPRE_ACREDITADO_IN NUMERIC(10,0) ) 
  RETURNS BOOLEAN AS $$
    BEGIN
      IF NOT EXISTS(SELECT * FROM REPRESENTANTES_ACREDITADOS WHERE 
                      ID_REPRESENTANTE_ACRE = ID_REPRE_ACREDITADO_IN)
      THEN
           RAISE EXCEPTION 'UPS! NO EXISTE EL ID_REPRESENTANTE_ACRE QUE DESEAS ELIMINAR. -> %' , $1
           USING HINT = 'REVISA EL ID_REPRESENTANTE_ACRE DEL REPRESENTANTE QUE DESEAS ELIMINAR.';
           RETURN FALSE;
      ELSE
          DELETE FROM REPRESENTANTES_ACREDITADOS WHERE
                   ID_REPRESENTANTE_ACRE = ID_REPRE_ACREDITADO_IN;
          RETURN TRUE;
      END IF;
    END;
$$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION  ELIMINA_REPRESENTANTE_ACREDITADO (ID_REPRE_ACREDITADO_IN NUMERIC(10,0) )  IS 
'Procedimiento para eliminar un representante acreditado, primero se busca en la tabla de representantes_acreditados 
si existe el identificador del representante que se desea eliminar, si se encuentra en la tabla lo eliminar, 
en cualquier otro caso manda una excepcion con el error. nota la eliminación se hace en CASCADA, 
es decir se eliminar todas las referencias asociadas a este identificador.';