DELETE FROM programas_erp_pers_aplicar WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_grp_val WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bloques_bi WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_botonera_perfil WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_botonera WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_historia WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_informes_ad WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_inf_det WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_informes WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_tabs WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_tabs_perfiles WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_tabs_idi WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_vent_idi WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_ventanas WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_campos_idi WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_campos WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_fil_var WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_filtros WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_bl_pl_pers_items WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_pl_det WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_plug_in_perfiles WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_plug_in WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_categ WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_rel WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bl_reldup WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers_bloques WHERE programa = 'CONFACT' AND id_personalizacion = 1;
DELETE FROM programas_erp_pers WHERE codigo = 'CONFACT' AND id_personalizacion = 1;
INSERT INTO programas_erp_pers(codigo,id_personalizacion,descripcion, tipo_programa, fecha_ult_modificacion,p_tipo_programa,p_tipo_impresora,p_imprimir_excel,p_impresion_dispositivo_por_de,p_codigo_pl_sql_grabacion,p_menu,p_destino_report_pantalla,p_destino_report_impresora,p_destino_report_archivo,p_destino_report_email,imprimir_excel,informe_inicial,informe_obligatorio)
VALUES ('CONFACT',1,'Consulta de Facturas por Organización Comercial','CONSULTA',TO_DATE('27-06-2024 13:25:35', 'DD-MM-YYYY HH24:MI:SS'),'N','N','N','N','N','N','N','N','N','N','R','BIP_CONFACT','S');
UPDATE programas_erp_pers SET version_cf = '$PNTPKLIB$ASIDE%CTRL(FTES:00001:' WHERE codigo = 'CONFACT' AND id_personalizacion = 1;
UPDATE programas_erp_pers SET bbdd_info = 'v6.2.0.6.4.4-110001:90647' WHERE codigo = 'CONFACT' AND id_personalizacion = 1;
INSERT INTO programas_erp_pers_bloques(programa,id_personalizacion,bloque,descripcion,clausula_where,enviar_excel,p_clausula_where,p_clausula_order_by,p_enviar_excel,p_codigo_pl_sql_inicializacion,p_codigo_pl_sql_validacion,p_codigo_pl_sql_borrado,p_bloquear_salida_hasta_grabar) 
VALUES ('CONFACT', 1, 'BDETALLE', 'FACTURAS_VENTAS',':where_pr','S','N','N','N','N','N','N','N');
INSERT INTO programas_erp_pers_bl_plug_in(programa,id_personalizacion,bloque,codigo,numero_orden,descripcion,icono,programa_llamado,botonera)
VALUES ('CONFACT',1,'BDETALLE','96',78,'Predicción Riesgo Impago','chart_stock','.','H');
BEGIN
UPDATE programas_erp_pers_bl_plug_in SET codigo_pl_sql = 'declare
 v_resultado varchar2(4000);
begin            
 v_resultado := pk_automl.predict(p_usuario => :global.usuario,   p_model_id => 1);
 :p_parar_ejecucion:=''S'';
 :p_tipo_mensaje:=''CAMPO''; 
 :p_codigo_mensaje:=''TEXTOLIB'';
 :p_texto_mensaje := v_resultado;
end;' WHERE programa = 'CONFACT' AND bloque = 'BDETALLE' AND codigo = '96' AND id_personalizacion = 1;
END;
/
COMMIT;
