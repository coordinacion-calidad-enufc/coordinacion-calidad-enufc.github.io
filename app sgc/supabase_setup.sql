-- ══════════════════════════════════════════════════════════════════════
--  SGC ENUFC — Script completo de tablas Supabase
--  Ejecuta este script en el SQL Editor de tu proyecto Supabase
--  (https://supabase.com → Tu proyecto → SQL Editor → New query)
--  Puedes ejecutarlo completo sin problema; usa CREATE TABLE IF NOT EXISTS
--  para no borrar datos existentes.
-- ══════════════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────────────
-- 1. ÁREAS
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS areas (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre     TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 2. USUARIOS
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS usuarios (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  correo     TEXT NOT NULL,
  nombre     TEXT NOT NULL DEFAULT '',
  rol        TEXT NOT NULL DEFAULT 'area',
  area_id    UUID REFERENCES areas(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 3. CONFIGURACIÓN GENERAL
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS configuracion_sgc (
  clave      TEXT PRIMARY KEY,
  valor      TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 4. PREGUNTAS DE AUDITORÍA
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS preguntas_auditoria (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pregunta   TEXT NOT NULL,
  area_id    UUID REFERENCES areas(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 5. INDICADORES
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS indicadores (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero      TEXT,
  nombre      TEXT NOT NULL,
  tipo        TEXT DEFAULT 'porcentaje',
  esperado    NUMERIC,
  area        TEXT,
  formula     TEXT,
  descripcion TEXT,
  frecuencia  TEXT DEFAULT 'semestral',
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 6. MEDICIONES DE INDICADORES
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS mediciones (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  indicador_id     UUID REFERENCES indicadores(id) ON DELETE SET NULL,
  nombre_indicador TEXT,
  periodo          TEXT,
  resultado        NUMERIC,
  numerador        NUMERIC,
  denominador      NUMERIC,
  obs              TEXT,
  created_at       TIMESTAMPTZ DEFAULT now(),
  updated_at       TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 7. AUDITORÍAS
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS auditorias (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  folio       TEXT,
  auditor     TEXT,
  fecha       DATE,
  area        TEXT,
  obs         TEXT,
  meta        JSONB DEFAULT '{}',
  items       JSONB DEFAULT '[]',
  area_id     UUID REFERENCES areas(id) ON DELETE SET NULL,
  usuario_id  UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  estatus     TEXT DEFAULT 'activa',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 8. RESULTADOS DE AUDITORÍA
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS auditoria_resultados (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auditoria_id UUID REFERENCES auditorias(id) ON DELETE CASCADE,
  pregunta_id  UUID REFERENCES preguntas_auditoria(id) ON DELETE SET NULL,
  resultado    TEXT,
  obs          TEXT,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 9. NO CONFORMIDADES
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS no_conformidades (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id             TEXT UNIQUE,
  numero               TEXT,
  area_numeral         TEXT,
  numeral              TEXT,
  responsable_area     TEXT,
  fecha                TEXT,
  elaborador           TEXT,
  descripcion          TEXT,
  correccion           TEXT,
  causa_raiz_desc      TEXT,
  tipo                 TEXT,
  origenes             JSONB DEFAULT '[]',
  efectividad          TEXT DEFAULT 'pend',
  estado               TEXT DEFAULT 'abierta',
  fecha_verif          TEXT,
  obs_cierre           TEXT,
  seguimiento_atencion TEXT,
  fecha_atencion       TEXT,
  pac                  JSONB DEFAULT '[]',
  p5                   JSONB DEFAULT '{}',
  created_at           TIMESTAMPTZ DEFAULT now(),
  updated_at           TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 10. PLANES DE ACCIÓN
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS planes_accion (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id     TEXT UNIQUE,
  semestre     TEXT,
  area         TEXT,
  responsable  TEXT,
  items        JSONB DEFAULT '{}',
  obs_general  TEXT,
  obs          TEXT,
  created_at   TIMESTAMPTZ DEFAULT now(),
  updated_at   TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 11. PLANES DE AUDITORÍA
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS planes_auditoria (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id     TEXT UNIQUE,
  semestre     TEXT,
  area         TEXT,
  auditor      TEXT,
  objetivo     TEXT,
  alcance      TEXT,
  items        JSONB DEFAULT '{}',
  obs          TEXT,
  created_at   TIMESTAMPTZ DEFAULT now(),
  updated_at   TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 12. SOLICITUDES DE SERVICIO
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS solicitudes_servicio (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id    TEXT UNIQUE,
  solicitante TEXT,
  area        TEXT,
  tipo        TEXT,
  descripcion TEXT,
  fecha       TEXT,
  estado      TEXT DEFAULT 'pendiente',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 13. DOCUMENTOS SGC (Control Documental)
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS documentos_sgc (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id    TEXT UNIQUE,
  codigo      TEXT,
  nombre      TEXT,
  tipo        TEXT,
  area        TEXT,
  revision    TEXT,
  fecha       TEXT,
  estado      TEXT DEFAULT 'vigente',
  url         TEXT,
  descripcion TEXT,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 14. SOLICITUDES DE CAMBIO
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS solicitudes_cambio (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id    TEXT UNIQUE,
  solicitante TEXT,
  area        TEXT,
  tipo        TEXT,
  descripcion TEXT,
  justificacion TEXT,
  fecha       TEXT,
  estado      TEXT DEFAULT 'pendiente',
  resolucion  TEXT,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 15. ASIGNACIONES DE INDICADORES
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS asignaciones_indicadores (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id         TEXT UNIQUE,
  area             TEXT,
  nombre_indicador TEXT,
  indicador_id     UUID REFERENCES indicadores(id) ON DELETE SET NULL,
  fecha_limite     TEXT,
  nota             TEXT,
  asignado_por     TEXT,
  completada       BOOLEAN DEFAULT false,
  created_at       TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 16. NOTIFICACIONES
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notificaciones (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  de_usuario    TEXT,
  para_rol      TEXT,
  para_area     TEXT,
  para_usuario  TEXT,
  tipo          TEXT,
  mensaje       TEXT,
  referencia_id TEXT,
  leida         BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 17. TAREAS PERSONALES
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sgc_tareas_personales (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_email TEXT NOT NULL,
  titulo        TEXT NOT NULL,
  descripcion   TEXT DEFAULT '',
  tags          JSONB DEFAULT '[]',
  completada    BOOLEAN DEFAULT false,
  creada        TIMESTAMPTZ DEFAULT now(),
  updated_at    TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 18. CALENDARIO DE EVENTOS
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sgc_eventos_calendario (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo      TEXT NOT NULL,
  tipo        TEXT DEFAULT 'custom',
  fecha       DATE NOT NULL,
  fecha_fin   DATE,
  descripcion TEXT,
  creado_por  TEXT,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 19. PLANIFICACIÓN (clave–valor: política, FODA, objetivos, manual,
--     eficacia de acciones, etc.)
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sgc_planificacion (
  clave      TEXT PRIMARY KEY,
  valor      JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 20. REPOSITORIO DRIVE
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sgc_drive_links (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  area_id     TEXT NOT NULL,
  tipo        TEXT NOT NULL,
  codigo      TEXT DEFAULT '',
  nombre      TEXT NOT NULL,
  url         TEXT DEFAULT '',
  descripcion TEXT DEFAULT '',
  orden       INTEGER DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 21. CONTROL DOCUMENTAL R-75/03
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sgc_r7503 (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  area_id     TEXT NOT NULL,
  codigo      TEXT,
  titulo      TEXT,
  revision    TEXT,
  fecha       TEXT,
  responsable TEXT,
  area_label  TEXT,
  orden       INTEGER DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 22. REVISIÓN POR LA DIRECCIÓN
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sgc_revision_direccion (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  semestre            TEXT,
  fecha               DATE,
  asistentes          JSONB DEFAULT '[]',
  prog_politica       BOOLEAN DEFAULT false,
  prog_objetivos      BOOLEAN DEFAULT false,
  prog_foda           BOOLEAN DEFAULT false,
  prog_encuesta       BOOLEAN DEFAULT false,
  prog_ficha          BOOLEAN DEFAULT false,
  prog_indicadores    BOOLEAN DEFAULT false,
  prog_acciones       BOOLEAN DEFAULT false,
  prog_aud_int        BOOLEAN DEFAULT false,
  prog_aud_ext        BOOLEAN DEFAULT false,
  firma_director_prog TEXT DEFAULT '',
  firma_calidad_prog  TEXT DEFAULT '',
  rep_fecha           DATE,
  rep_lugar           TEXT DEFAULT '',
  rep_hora_inicio     TEXT DEFAULT '',
  rep_hora_cierre     TEXT DEFAULT '',
  agenda              JSONB DEFAULT '[]',
  decisiones          JSONB DEFAULT '[]',
  firma_director_rep  TEXT DEFAULT '',
  firma_calidad_rep   TEXT DEFAULT '',
  updated_at          TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 23. PROVEEDORES — Lista de Proveedores Aprobados (R-84-01)
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prov_lista (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id    TEXT UNIQUE,
  proveedor   TEXT NOT NULL,
  producto    TEXT,
  contacto    TEXT,
  telefono    TEXT,
  email       TEXT,
  tipo        TEXT,
  datos       JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 24. PROVEEDORES — Hoja de Evaluación (R-84-02)
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prov_evaluacion (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id    TEXT UNIQUE,
  proveedor   TEXT NOT NULL,
  producto    TEXT,
  tipo        TEXT,
  fecha       TEXT,
  criterios   JSONB DEFAULT '{}',
  total_pts   INTEGER,
  porcentaje  NUMERIC,
  resultado   TEXT,
  firma       TEXT,
  reevals     JSONB DEFAULT '[]',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────────────
-- 25. PROVEEDORES — Solicitud de Cotización (R-84-03)
-- ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prov_solicitud (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  local_id    TEXT UNIQUE,
  proveedor   TEXT NOT NULL,
  producto    TEXT,
  fecha       TEXT,
  solicitante TEXT,
  area        TEXT,
  descripcion TEXT,
  datos       JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ══════════════════════════════════════════════════════════════════════
--  POLÍTICAS DE SEGURIDAD (Row Level Security)
--  Permite acceso público autenticado a todas las tablas.
--  Ajusta según tus necesidades de seguridad.
-- ══════════════════════════════════════════════════════════════════════

ALTER TABLE areas                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracion_sgc        ENABLE ROW LEVEL SECURITY;
ALTER TABLE preguntas_auditoria      ENABLE ROW LEVEL SECURITY;
ALTER TABLE indicadores              ENABLE ROW LEVEL SECURITY;
ALTER TABLE mediciones               ENABLE ROW LEVEL SECURITY;
ALTER TABLE auditorias               ENABLE ROW LEVEL SECURITY;
ALTER TABLE auditoria_resultados     ENABLE ROW LEVEL SECURITY;
ALTER TABLE no_conformidades         ENABLE ROW LEVEL SECURITY;
ALTER TABLE planes_accion            ENABLE ROW LEVEL SECURITY;
ALTER TABLE planes_auditoria         ENABLE ROW LEVEL SECURITY;
ALTER TABLE solicitudes_servicio     ENABLE ROW LEVEL SECURITY;
ALTER TABLE documentos_sgc           ENABLE ROW LEVEL SECURITY;
ALTER TABLE solicitudes_cambio       ENABLE ROW LEVEL SECURITY;
ALTER TABLE asignaciones_indicadores ENABLE ROW LEVEL SECURITY;
ALTER TABLE notificaciones           ENABLE ROW LEVEL SECURITY;
ALTER TABLE sgc_tareas_personales    ENABLE ROW LEVEL SECURITY;
ALTER TABLE sgc_eventos_calendario   ENABLE ROW LEVEL SECURITY;
ALTER TABLE sgc_planificacion        ENABLE ROW LEVEL SECURITY;
ALTER TABLE sgc_drive_links          ENABLE ROW LEVEL SECURITY;
ALTER TABLE sgc_r7503                ENABLE ROW LEVEL SECURITY;
ALTER TABLE sgc_revision_direccion   ENABLE ROW LEVEL SECURITY;
ALTER TABLE prov_lista               ENABLE ROW LEVEL SECURITY;
ALTER TABLE prov_evaluacion          ENABLE ROW LEVEL SECURITY;
ALTER TABLE prov_solicitud           ENABLE ROW LEVEL SECURITY;

-- Política: acceso total para usuarios autenticados
-- (borra la política si ya existía y la vuelve a crear)
DO $$
DECLARE
  t TEXT;
  tables TEXT[] := ARRAY[
    'areas','usuarios','configuracion_sgc','preguntas_auditoria',
    'indicadores','mediciones','auditorias','auditoria_resultados',
    'no_conformidades','planes_accion','planes_auditoria',
    'solicitudes_servicio','documentos_sgc','solicitudes_cambio',
    'asignaciones_indicadores','notificaciones','sgc_tareas_personales',
    'sgc_eventos_calendario','sgc_planificacion','sgc_drive_links',
    'sgc_r7503','sgc_revision_direccion',
    'prov_lista','prov_evaluacion','prov_solicitud'
  ];
  policy_name TEXT;
BEGIN
  FOREACH t IN ARRAY tables LOOP
    policy_name := 'acceso_autenticado_' || t;
    -- Eliminar política previa si existe
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', policy_name, t);
    -- Crear política nueva
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR ALL TO authenticated USING (true) WITH CHECK (true)',
      policy_name, t
    );
  END LOOP;
END $$;
