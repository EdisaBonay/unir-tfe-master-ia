DELETE FROM valor_por_defecto_bloque_lin WHERE tipo_despliegue = 'E' AND programa = 'U_AUTOML';
DELETE FROM valor_por_defecto_bloque_cab WHERE tipo_despliegue = 'E' AND programa = 'U_AUTOML';
DELETE FROM programas_erp_informes_ad WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_informes_det WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_grp_val WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bloques_bi WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_botonera WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_informes WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_historia WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_param_llamada WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_ventanas_idiomas WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_ventanas WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_tabs_idiomas WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_tabs WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_campos_idiomas WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_campos WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_pl_items WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_pl_det WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_plug_in WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_filtros_var WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_filtros WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_categorias WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_relaciones WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bl_reldup WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp_bloques WHERE programa = 'U_AUTOML';
DELETE FROM programas_erp WHERE codigo = 'U_AUTOML';
INSERT INTO programas_erp (codigo, descripcion, tipo_programa, dinamico, campo_codigo, imprimir_excel)
VALUES ('U_AUTOML', 'Machine Learning Automático', NULL, 'N', NULL, 'S');
UPDATE programas_erp SET fecha_ult_modificacion = TO_DATE('26-06-2024 18:51:36', 'DD-MM-YYYY HH24:MI:SS') WHERE codigo = 'U_AUTOML';
UPDATE programas_erp SET version_cf = '$PNTPKLIB$ASIDE%CTRL(FTES:00001:' WHERE codigo = 'U_AUTOML';
UPDATE programas_erp SET bbdd_info = 'v6.2.0.6.4.4-110001:90647' WHERE codigo = 'U_AUTOML';
INSERT INTO programas_erp_bloques (programa, bloque, descripcion, clausula_where, clausula_order_by) VALUES (
'U_AUTOML', 'B1', 'BLOQUE FILTROS', 
NULL
, NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'DATASET', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, 'GI_INFORMES_USUARIOS', 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'D_DATASET', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, NULL, 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'LOGS', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, NULL, 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'N_CLUSTERS', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, NULL, 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'TARGET', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, NULL, 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'TIEMPO_LIMITE', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, NULL, 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_campos (programa, bloque, campo, etiqueta_std, seccion, numero_orden, obligatorio, pasar_en_navegacion, activar_calculadora, activar_calendario, parametro_navegacion, lv_codigo_lista, lv_ejecutar_consulta, lv_validar_desde_lista, lv_where_defecto, ejecutar_pl_sql_prevalidacion, llamar_programa) VALUES ('U_AUTOML', 'B1', 'TIPO_TAREA', NULL, 0, 1, 'N', 'N', 'N', 'N', NULL, NULL, 'S', 'S', NULL, 'S', NULL);
INSERT INTO programas_erp_bl_plug_in (programa, bloque, codigo, numero_orden, descripcion, icono, programa_llamado, modo_menu, modo_consulta, operacion_control_activacion, codigo_pl_sql) VALUES ('U_AUTOML', 'B1', '01', 1, 'Comenzar entrenamiento', 'gear_in', '.', 38, 502, '=', NULL);
COMMIT;
