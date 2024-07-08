CREATE OR REPLACE PACKAGE pk_automl IS
  FUNCTION generate_json(p_model_id IN NUMBER) RETURN CLOB;
  FUNCTION predict(p_usuario VARCHAR2, p_model_id NUMBER) RETURN CLOB;
  FUNCTION train(p_params VARCHAR2, p_id_archivo NUMBER) RETURN CLOB;
  FUNCTION model_info(p_model_id NUMBER) RETURN CLOB;
END pk_automl;
/
CREATE OR REPLACE PACKAGE BODY pk_automl IS
  vg_url                     VARCHAR2(100) := ''; --cambiar por la url donde se despliegue el API
  vg_ruta_api_key            VARCHAR2(50) := '/setup/open_ai/api_key';
  vg_ruta_assistant_id       VARCHAR2(50) := '/setup/open_ai/assistant_id';
  vg_ruta_nueva_conversacion VARCHAR2(50) := '/train';
  vg_ruta_chat               VARCHAR2(50) := '/predict';
  vg_id_archivo_geninf       NUMBER;

  FUNCTION generate_json(p_model_id IN NUMBER) RETURN CLOB IS
  
    v_json    CLOB;
    vr_tesia2 tes_ia2%ROWTYPE;
  BEGIN
  
    SELECT *
      INTO vr_tesia2
      FROM tes_ia2
     WHERE rownum = 1;
  
    -- NoFormat Start
    v_json := '{' ||
              '"model_id": ' || p_model_id || ',' ||
              '"features": {' ||
              '"EMPRESA": "' || vr_tesia2.empresa || '",' ||
              '"EJERCICIO": ' || vr_tesia2.ejercicio || ',' ||
              '"NUMERO_SERIE": "' || vr_tesia2.numero_serie || '",' ||
              '"NUMERO_FACTURA": ' || vr_tesia2.numero_factura || ',' ||
              '"TIPO_FACTURA": ' || vr_tesia2.tipo_factura || ',' ||
              '"ORGANIZACION_COMERCIAL": "' || vr_tesia2.organizacion_comercial || '",' ||
              '"CLIENTE": "' || vr_tesia2.cliente || '",' ||
              '"FECHA_FACTURA": "' || vr_tesia2.fecha_factura || '",' ||
              '"MES_FACTURA": ' || vr_tesia2.mes_factura || ',' ||
              '"DIVISA": "' || vr_tesia2.divisa || '",' ||
              '"FORMA_COBRO": "' || vr_tesia2.forma_cobro || '",' ||
              '"CENTRO_CONTABLE": "' || vr_tesia2.centro_contable || '",' ||
              '"LIQUIDO_FACTURA": "' || vr_tesia2.liquido_factura || '",' ||
              '"ALBARAN_FACTURA": "' || vr_tesia2.albaran_factura || '",' ||
              '"DIARIO": "' || vr_tesia2.diario || '",' ||
              '"ENVIO_ELECTRONICO": "' || vr_tesia2.envio_electronico || '",' ||
              '"FECHA_CONTABILIZACION": "' || vr_tesia2.fecha_contabilizacion || '",' ||
              '"NUMERO_ASIENTO_BORRADOR": ' || vr_tesia2.numero_asiento_borrador || ',' ||
              '"CUENTA_CONTABLE": "' || vr_tesia2.cuenta_contable || '",' ||
              '"TIENE_DESCUENTO": ' || vr_tesia2.tiene_descuento || ',' ||
              '"COUNT_TIPOS_TRANSACCION": ' || vr_tesia2.count_tipos_transaccion || ',' ||
              '"IMPORTE_COBRADO_FRA": "' || vr_tesia2.importe_cobrado_fra || '",' ||
              '"MAX_FECHA_COBRO": "' || vr_tesia2.max_fecha_cobro || '",' ||
              '"NUM_EFECTOS_FACTURA": ' || vr_tesia2.num_efectos_factura || ',' ||
              '"NUM_EFECTOS_COBRADOS": ' || vr_tesia2.num_efectos_cobrados || ',' ||
              '"NUM_EFECTOS_PARCIAL": ' || vr_tesia2.num_efectos_parcial || ',' ||
              '"NUM_EFECTOS_IMPAGADO": ' || vr_tesia2.num_efectos_impagado || ',' ||
              '"NUM_EFECTOS_FUERA_PLAZO": ' || vr_tesia2.num_efectos_fuera_plazo || ',' ||
              '"NUM_EFECTOS_PDTE_EN_PLAZO": ' || vr_tesia2.num_efectos_pdte_en_plazo || '}' ||
              '}';
    -- NoFormat End  
    RETURN v_json;
  END generate_json;

  FUNCTION predict(p_usuario VARCHAR2, p_model_id NUMBER) RETURN CLOB IS
    vr_peticion              pk_galileo.tr_peticion;
    vr_respuesta             pk_galileo.tr_respuesta;
    vr_boundary_user_id      pk_galileo.tr_boundary;
    vr_boundary_thread_id    pk_galileo.tr_boundary;
    vr_boundary_message      pk_galileo.tr_boundary;
    vt_boundary              pk_galileo.tt_boundary;
    vt_status_code_esperados pk_galileo.lista_status_esperados_table;
    v_xml                    xmltype;
    v_mensaje                pkpantallas.type_max_plsql_varchar2;
  
    v_json           CLOB;
    prediction_value NUMBER;
    v_rdo            VARCHAR2(4000);
  BEGIN
    v_json := generate_json(p_model_id);
    v_mensaje := v_mensaje;
  
    vr_peticion := pk_galileo.prepara_peticion_http(p_url => vg_url || vg_ruta_chat);
    vr_peticion.metodo := 'POST';
    vr_peticion.headers('content-type') := 'application/json';
    vr_peticion.cuerpo_clob := v_json;
  
    vt_status_code_esperados(200) := 'S';
    vt_status_code_esperados(400) := 'S';
    vr_peticion.status_code_esperados := vt_status_code_esperados;
  
    vr_respuesta := pk_galileo.comunica_con_servidor_http(vr_peticion);
  
    SELECT json_value(vr_respuesta.respuesta_clob, '$.prediction')
      INTO prediction_value
      FROM dual;
  
    IF prediction_value = 2 THEN
      v_rdo := 'Riesgo de impago mínimo.';
    ELSIF prediction_value = 1 THEN
      v_rdo := 'Riesgo de impago bajo.';
    ELSIF prediction_value = 0 THEN
      v_rdo := 'Riesgo de impago medio.';
    ELSIF prediction_value = -1 THEN
      v_rdo := 'Riesgo de impago alto.';
    ELSIF prediction_value = -2 THEN
      v_rdo := 'Riesgo de impago máximo.';
    END IF;
  
    RETURN v_rdo;
  END;

  FUNCTION train(p_params VARCHAR2, p_id_archivo NUMBER) RETURN CLOB IS
    vr_peticion              pk_galileo.tr_peticion;
    vr_respuesta             pk_galileo.tr_respuesta;
    vr_boundary              pk_galileo.tr_boundary;
    vt_boundary              pk_galileo.tt_boundary;
    vt_status_code_esperados pk_galileo.lista_status_esperados_table;
    v_xml                    xmltype;
    v_out_comprimido         VARCHAR2(1);
    v_out_nombre_archivo     pkpantallas.type_max_plsql_varchar2;
    v_params                 VARCHAR2(4500);
  BEGIN
    --ejemplo estructura json
    --    '{
    --    "task": "classification",
    --    "budget_time": 120,
    --    "target":"NOMBRE_COLUMNA"
    --    }';
  
    v_params := p_params;
    vr_boundary.valor_varchar2 := v_params;
    vt_boundary('params') := vr_boundary;
  
    vr_boundary.valor_varchar2 := NULL;
  
    pk_blob2bd.recupera_archivo(p_empresa => pkpantallas.get_empresa, p_id_archivo => p_id_archivo, p_tabla => NULL, p_out_comprimido => v_out_comprimido, p_out_nombre_archivo => v_out_nombre_archivo);
  
    vr_boundary.valor_blob := pk_blob2bd.get_fichero;
  
    vr_boundary.nombre_fichero := v_out_nombre_archivo;
    vt_boundary('file') := vr_boundary;
  
    vr_peticion := pk_galileo.prepara_peticion_http(p_url => vg_url || vg_ruta_nueva_conversacion, p_boundary_params => vt_boundary);
    vr_peticion.metodo := 'POST';
  
    vt_status_code_esperados(200) := 'S';
    vt_status_code_esperados(400) := 'S';
    vr_peticion.status_code_esperados := vt_status_code_esperados;
    vr_peticion.timeout := 3600;
  
    vr_respuesta := pk_galileo.comunica_con_servidor_http(vr_peticion);
  
    v_xml := xmltype(vr_respuesta.respuesta_clob);
  
    RETURN(vr_respuesta.respuesta_clob);
  END;

  FUNCTION model_info(p_model_id NUMBER) RETURN CLOB IS
    vr_peticion              pk_galileo.tr_peticion;
    vr_respuesta             pk_galileo.tr_respuesta;
    vr_boundary              pk_galileo.tr_boundary;
    vt_boundary              pk_galileo.tt_boundary;
    vt_status_code_esperados pk_galileo.lista_status_esperados_table;
    v_xml                    xmltype;
    v_out_comprimido         VARCHAR2(1);
    v_out_nombre_archivo     pkpantallas.type_max_plsql_varchar2;
    v_params                 VARCHAR2(4500);
  BEGIN
    vr_peticion := pk_galileo.prepara_peticion_http(p_url => vg_url || '/model_info/' || p_model_id);
    vr_peticion.metodo := 'GET';
    vt_status_code_esperados(200) := 'S';
    vt_status_code_esperados(400) := 'S';
    vr_peticion.status_code_esperados := vt_status_code_esperados;
  
    vr_respuesta := pk_galileo.comunica_con_servidor_http(vr_peticion);
  
    RETURN(vr_respuesta.respuesta_clob);
  END;
END pk_automl;
/
