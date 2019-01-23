﻿SET SEARCH_PATH TO REPRESENTANTES , CASILLAS , GEOGRAFICO , PARTIDOSPOLITICOS;
/**
DROP FUNCTION ELIMINA_ASISTENCIAS_REPRESENTANTES (ID_REPRE_PRELIMINAR_IN NUMERIC(10,0) , ID_ESTADO_IN  DECIMAL(2,0) , ID_DISTRITO_FEDERAL_IN NUMERIC(2,0) , 
  SECCION_IN NUMERIC(5,0) ,   TIPO_CASILLA_IN VARCHAR(6) ,  TIPO_PRESENCIA_IN VARCHAR(1) ) ;
**/
 CREATE OR REPLACE FUNCTION ELIMINA_ASISTENCIAS_REPRESENTANTES (ID_REPRE_PRELIMINAR_IN NUMERIC(10,0) , ID_ESTADO_IN  DECIMAL(2,0) , ID_DISTRITO_FEDERAL_IN NUMERIC(2,0) , 
  SECCION_IN NUMERIC(5,0) ,   TIPO_CASILLA_IN VARCHAR(6) ,  TIPO_PRESENCIA_IN VARCHAR(1) ) 
  RETURNS BOOLEAN AS $$
    BEGIN
      IF EXISTS (SELECT * FROM ASISTENCIAS WHERE ID_REPRESENTANTE_PRE = ID_REPRE_PRELIMINAR_IN AND ID_ESTADO = ID_ESTADO_IN  AND ID_DISTRITO_FEDERAL = ID_DISTRITO_FEDERAL_IN  AND 
        SECCION = SECCION_IN AND TIPO_CASILLA = TIPO_CASILLA_IN AND TIPO_PRESENCIA = TIPO_PRESENCIA_IN)
      THEN     
         IF TIPO_PRESENCIA_IN = 'I'
          THEN 
            UPDATE  ASISTENCIAS  SET FIRMA_INICIO  = NULL , PRESENCIA_INICIO =  NULL   WHERE ID_REPRESENTANTE_ACRE = ID_REPRESENTANTE_ACRE_IN  AND ID_ESTADO = ID_ESTADO_IN  AND 
            ID_DISTRITO_FEDERAL = ID_DISTRITO_FEDERAL_IN  AND      SECCION = SECCION_IN AND TIPO_CASILLA = TIPO_CASILLA_IN ; 
         ELSEIF TIPO_PRESENCIA_IN = 'F'
                 THEN 
            UPDATE  ASISTENCIAS  SET FIRMA_FIN  = NULL , PRESENCIA_FIN =  NULL   WHERE ID_REPRESENTANTE_ACRE = ID_REPRESENTANTE_ACRE_IN  AND ID_ESTADO = ID_ESTADO_IN  AND 
            ID_DISTRITO_FEDERAL = ID_DISTRITO_FEDERAL_IN  AND      SECCION = SECCION_IN AND TIPO_CASILLA = TIPO_CASILLA_IN ; 
          ELSEIF TIPO_PRESENCIA_IN = 'C'
          THEN 
            UPDATE  ASISTENCIAS  SET FIRMA_COMPUTO  = NULL , PRESENCIA_COMPUTO =  NULL   WHERE ID_REPRESENTANTE_ACRE = ID_REPRESENTANTE_ACRE_IN  AND ID_ESTADO = ID_ESTADO_IN  AND 
            ID_DISTRITO_FEDERAL = ID_DISTRITO_FEDERAL_IN  AND      SECCION = SECCION_IN AND TIPO_CASILLA = TIPO_CASILLA_IN ; 
          ELSE
             RAISE EXCEPTION 'UPS! NO EXISTE EL  TIPO DE LA ASISTENCIA  ' 
             USING HINT = 'REVISA EL TIPO ASISTENCIAS QUE DESEAS ELIMINAR.';
             RETURN FALSE;
          END IF;
           IF EXISTS (SELECT * FROM ASISTENCIAS WHERE ID_REPRESENTANTE_PRE = ID_REPRE_PRELIMINAR_IN AND ID_ESTADO = ID_ESTADO_IN  AND ID_DISTRITO_FEDERAL = ID_DISTRITO_FEDERAL_IN  AND 
                  SECCION = SECCION_IN AND TIPO_CASILLA = TIPO_CASILLA_IN AND FIRMA_INICIO IS NULL AND FIRMA_FIN IS NULL AND FIRMA_COMPUTO IS NULL )
           THEN 
             DELETE FROM REPRESENTANTES_PRELIMINARES WHERE ID_REPRESENTANTE_PRE = ID_REPRE_PRELIMINAR_IN AND ID_ESTADO = ID_ESTADO_IN  AND ID_DISTRITO_FEDERAL = ID_DISTRITO_FEDERAL_IN  AND 
             SECCION = SECCION_IN AND TIPO_CASILLA = TIPO_CASILLA_IN;     
          END IF ;
           RETURN TRUE;      
      ELSE
           RAISE EXCEPTION 'UPS! NO EXISTE EL ID_REPRESENTANTE_PRE QUE DESEAS ELIMINAR. -> %' , $1
           USING HINT = 'REVISA EL ID_REPRESENTANTE_PRE DEL REPRESENTANTE QUE DESEAS ELIMINAR.';
           RETURN FALSE;
        END IF;
      END; 
  $$ LANGUAGE PLPGSQL;

COMMENT ON FUNCTION ON FUNCTION ELIMINA_ASISTENCIAS_REPRESENTANTES (ID_REPRE_PRELIMINAR_IN NUMERIC(10,0) , ID_ESTADO_IN  DECIMAL(2,0) , ID_DISTRITO_FEDERAL_IN NUMERIC(2,0) , 
  SECCION_IN NUMERIC(5,0) ,   TIPO_CASILLA_IN VARCHAR(6) ,  TIPO_FIRMA_IN VARCHAR(1) )  IS 
'Procedimiento para eliminar una asistencia asiganada del representantes acreditado,  cabe resaltal que si el representante ya no tiene asiganada 
ninguna asistencia se hace un delete sobre la tabla de asistencias para que no se este guardo registros sin informacion.';