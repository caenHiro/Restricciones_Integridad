SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION ELIMINA_REPRESENTANTE_PRELIMINAR(ID_REPRE_PRELIMINAR_IN numeric(10,0) );
**/

CREATE OR REPLACE FUNCTION ELIMINA_REPRESENTANTE_PRELIMINAR (ID_REPRE_PRELIMINAR_IN NUMERIC(10,0) ) 
  RETURNS BOOLEAN AS $$
    BEGIN
      IF NOT EXISTS(SELECT * FROM REPRESENTANTES_PRELIMINARES WHERE 
                              ID_REPRESENTANTE_PRE = ID_REPRE_PRELIMINAR_IN)
      THEN
           RAISE EXCEPTION 'UPS! NO EXISTE EL ID_REPRESENTANTE_PRE QUE DESEAS ELIMINAR. -> %' , $1
           USING HINT = 'REVISA EL ID_REPRESENTANTE_PRE DEL REPRESENTANTE QUE DESEAS ELIMINAR.';
           RETURN FALSE;
      ELSE
        DELETE FROM REPRESENTANTES_PRELIMINARES WHERE ID_REPRESENTANTE_PRE = ID_REPRE_PRELIMINAR_IN;
           RETURN TRUE;
        END IF;
      END;
    $$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION  ELIMINA_REPRESENTANTE_PRELIMINAR (ID_REPRE_PRELIMINAR_IN NUMERIC(10,0) )  IS 
'Procedimiento para eliminar un representantes preliminar, primero se busca en la tabla de representantes_pre 
si existe el identificador del representante que se desea eliminar, si  se encuentra en la tabla lo eliminar,
 en cualquier otro caso manda una excepcion. nota la eliminación se hace en cascada, es decir se  eliminar 
 todas las referencias asociadas a este identificador.';