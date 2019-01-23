SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION ELIMINA_RESPONSABLE_ACREDITACION(ID_RESPONSABLE_ACRE_IN numeric(10,0) );
**/
CREATE OR REPLACE FUNCTION ELIMINA_RESPONSABLE_ACREDITACION (ID_RESPONSABLE_ACRE_IN NUMERIC(10,0) ) 
  RETURNS BOOLEAN AS $$
  BEGIN
      IF NOT EXISTS(SELECT * FROM RESPONSABLES_ACREDITACION WHERE
      		 ID_RESPONBLE_ACRE = ID_RESPONSABLE_ACRE_IN)
      THEN
           RAISE EXCEPTION 'UPS! NO EXISTE EL ID_RESPONBLE_ACRE QUE DESEAS ELIMINAR. -> %' , $1
           USING HINT = 'REVISA EL ID_RESPONBLE_ACRE DEL RESPONSABLE DE ACREDITACIÓN QUE DESEAS ELIMINAR.';
           RETURN FALSE;
  		ELSE
   		   DELETE FROM RESPONSABLES_ACREDITACION WHERE ID_RESPONBLE_ACRE = ID_RESPONSABLE_ACRE_IN;
           RETURN TRUE;
        END IF;
   END;
 $$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION  ELIMINA_RESPONSABLE_ACREDITACION (ID_RESPONSABLE_ACRE_IN NUMERIC(10,0) )  IS 
'Procedimiento para eliminar un responsable de acreditación, primero se busca en la tabla de responsables_acreditacion
 si existe el identificador del responsable que se desea eliminar, si se encuentra en la tabla lo eliminar, en cualquier
  otro caso manda una excepcion con el error. nota la eliminación se hace en CASCADA, es decir se  eliminar todas las 
  referencias asociadas a este identificador. ';