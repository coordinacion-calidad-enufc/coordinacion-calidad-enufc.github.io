// ============================================================
// Apps Script — Encuesta de Satisfacción R-91/02
// ============================================================
// INSTRUCCIONES:
// 1. Abre el Google Sheet vinculado a la Encuesta de Satisfacción
// 2. Extensiones > Apps Script
// 3. Pega este código reemplazando todo el contenido
// 4. Llena SUPABASE_URL y SUPABASE_SERVICE_KEY con tus datos
// 5. Guarda (Ctrl+S)
// 6. Ejecutores > Añadir activador:
//      Función: onFormSubmit
//      Tipo de evento: Al enviar el formulario
// ============================================================

const SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';         // ← cambia esto
const SUPABASE_SERVICE_KEY = 'TU-SERVICE-ROLE-KEY';             // ← cambia esto
// (La Service Role Key está en Supabase > Project Settings > API > service_role)

function onFormSubmit(e) {
  const row = e.values;

  const payload = {
    marca_temporal:             parseFecha(row[0]),
    semestre:                   row[1]  || '',
    licenciatura:               row[2]  || '',
    doc_dominio_materia:        row[3]  || '',
    doc_estrategias_ensenanza:  row[4]  || '',
    doc_recursos_didacticos:    row[5]  || '',
    doc_estrategias_eval:       row[6]  || '',
    doc_asesoria_academica:     row[7]  || '',
    doc_satisfaccion_formacion: row[8]  || '',
    doc_acompanamiento_prac:    row[9]  || '',
    porcentaje_clases:          row[10] || '',
    porcentaje_actividades:     row[11] || '',
    participa_cultural:         row[12] || '',
    satisfaccion_cultural:      row[13] || '',
    participa_talleres:         row[14] || '',
    calif_talleres:             row[15] || '',
    infra_salones:              row[16] || '',
    infra_aula_medios:          row[17] || '',
    infra_banos:                row[18] || '',
    infra_biblioteca:           row[19] || '',
    infra_biblioteca_escolar:   row[20] || '',
    infra_auditorio:            row[21] || '',
    infra_areas_verdes:         row[22] || '',
    infra_canchas:              row[23] || '',
    infra_salon_danza:          row[24] || '',
    limpieza:                   row[25] || '',
    comentarios:                row[26] || '',
  };

  enviarASupabase('sgc_encuesta_satisfaccion', payload);
}

function parseFecha(str) {
  if (!str) return null;
  const parts = str.match(/(\d+)\/(\d+)\/(\d+)\s+(\d+):(\d+):(\d+)/);
  if (!parts) return null;
  return new Date(parts[3], parts[2]-1, parts[1], parts[4], parts[5], parts[6]).toISOString();
}

function enviarASupabase(tabla, payload) {
  const options = {
    method: 'post',
    contentType: 'application/json',
    headers: {
      'Authorization': 'Bearer ' + SUPABASE_SERVICE_KEY,
      'apikey': SUPABASE_SERVICE_KEY,
      'Prefer': 'return=minimal'
    },
    payload: JSON.stringify(payload),
    muteHttpExceptions: true
  };
  const resp = UrlFetchApp.fetch(SUPABASE_URL + '/rest/v1/' + tabla, options);
  Logger.log(resp.getResponseCode() + ': ' + resp.getContentText());
}
