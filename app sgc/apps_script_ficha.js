// ============================================================
// Apps Script — Ficha de Satisfacción R-91/01
// ============================================================
// INSTRUCCIONES:
// 1. Abre el Google Sheet vinculado a la Ficha de Satisfacción
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
  const row = e.values; // valores en orden de columnas del sheet

  const payload = {
    marca_temporal:        parseFecha(row[0]),
    semestre:              row[1]  || '',
    licenciatura:          row[2]  || '',
    ce_inscripcion:        row[3]  || '',
    ce_reinscripcion:      row[4]  || '',
    ce_constancias:        row[5]  || '',
    ce_credenciales:       row[6]  || '',
    ce_duplicado_boleta:   row[7]  || '',
    ce_boleta_calif:       row[8]  || '',
    tit_asesor:            row[9]  || '',
    tit_constancia_cursos: row[10] || '',
    tit_respuesta_carta:   row[11] || '',
  };

  enviarASupabase('sgc_ficha_satisfaccion', payload);
}

function parseFecha(str) {
  if (!str) return null;
  // Formato Google Sheets: "20/4/2026 8:38:58"
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
