-- SGC ENUFC: Tablas para encuestas de satisfacción R-91/01 y R-91/02
-- Ejecutar en Supabase > SQL Editor > Run.

-- ============================================================
-- Ficha de Satisfacción del Alumno (R-91/01)
-- ============================================================

create table if not exists public.sgc_ficha_satisfaccion (
  id                    text primary key default gen_random_uuid()::text,
  marca_temporal        timestamptz,
  semestre              text not null default '',
  licenciatura          text not null default '',
  ce_inscripcion        text not null default '',
  ce_reinscripcion      text not null default '',
  ce_constancias        text not null default '',
  ce_credenciales       text not null default '',
  ce_duplicado_boleta   text not null default '',
  ce_boleta_calif       text not null default '',
  tit_asesor            text not null default '',
  tit_constancia_cursos text not null default '',
  tit_respuesta_carta   text not null default '',
  created_at            timestamptz not null default now()
);

create index if not exists idx_ficha_semestre on public.sgc_ficha_satisfaccion(semestre);
create index if not exists idx_ficha_temporal on public.sgc_ficha_satisfaccion(marca_temporal desc);

alter table public.sgc_ficha_satisfaccion enable row level security;

drop policy if exists "ficha_select" on public.sgc_ficha_satisfaccion;
drop policy if exists "ficha_insert" on public.sgc_ficha_satisfaccion;
drop policy if exists "ficha_delete" on public.sgc_ficha_satisfaccion;

create policy "ficha_select" on public.sgc_ficha_satisfaccion
  for select to authenticated using (true);
create policy "ficha_insert" on public.sgc_ficha_satisfaccion
  for insert to authenticated with check (true);
create policy "ficha_delete" on public.sgc_ficha_satisfaccion
  for delete to authenticated using (true);

grant select, insert, delete on public.sgc_ficha_satisfaccion to authenticated;
revoke all on public.sgc_ficha_satisfaccion from anon;

-- ============================================================
-- Encuesta de Satisfacción (R-91/02)
-- ============================================================

create table if not exists public.sgc_encuesta_satisfaccion (
  id                         text primary key default gen_random_uuid()::text,
  marca_temporal             timestamptz,
  semestre                   text not null default '',
  licenciatura               text not null default '',
  doc_dominio_materia        text not null default '',
  doc_estrategias_ensenanza  text not null default '',
  doc_recursos_didacticos    text not null default '',
  doc_estrategias_eval       text not null default '',
  doc_asesoria_academica     text not null default '',
  doc_satisfaccion_formacion text not null default '',
  doc_acompanamiento_prac    text not null default '',
  porcentaje_clases          text not null default '',
  porcentaje_actividades     text not null default '',
  participa_cultural         text not null default '',
  satisfaccion_cultural      text not null default '',
  participa_talleres         text not null default '',
  calif_talleres             text not null default '',
  infra_salones              text not null default '',
  infra_aula_medios          text not null default '',
  infra_banos                text not null default '',
  infra_biblioteca           text not null default '',
  infra_biblioteca_escolar   text not null default '',
  infra_auditorio            text not null default '',
  infra_areas_verdes         text not null default '',
  infra_canchas              text not null default '',
  infra_salon_danza          text not null default '',
  limpieza                   text not null default '',
  comentarios                text not null default '',
  created_at                 timestamptz not null default now()
);

create index if not exists idx_encuesta_semestre on public.sgc_encuesta_satisfaccion(semestre);
create index if not exists idx_encuesta_temporal on public.sgc_encuesta_satisfaccion(marca_temporal desc);

alter table public.sgc_encuesta_satisfaccion enable row level security;

drop policy if exists "encuesta_select" on public.sgc_encuesta_satisfaccion;
drop policy if exists "encuesta_insert" on public.sgc_encuesta_satisfaccion;
drop policy if exists "encuesta_delete" on public.sgc_encuesta_satisfaccion;

create policy "encuesta_select" on public.sgc_encuesta_satisfaccion
  for select to authenticated using (true);
create policy "encuesta_insert" on public.sgc_encuesta_satisfaccion
  for insert to authenticated with check (true);
create policy "encuesta_delete" on public.sgc_encuesta_satisfaccion
  for delete to authenticated using (true);

grant select, insert, delete on public.sgc_encuesta_satisfaccion to authenticated;
revoke all on public.sgc_encuesta_satisfaccion from anon;
