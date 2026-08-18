-- SGC ENUFC: Tabla para Revisión por la Dirección (R-93/01 · R-93/02).
-- Ejecutar en Supabase > SQL Editor > Run.

create table if not exists public.sgc_revision_direccion (
  id                  text primary key,
  semestre            text not null,
  fecha               date,

  -- R-93/01: Programa de Seguimiento
  asistentes          jsonb not null default '[]',
  prog_politica       boolean not null default false,
  prog_objetivos      boolean not null default false,
  prog_foda           boolean not null default false,
  prog_encuesta       boolean not null default false,
  prog_ficha          boolean not null default false,
  prog_indicadores    boolean not null default false,
  prog_acciones       boolean not null default false,
  prog_aud_int        boolean not null default false,
  prog_aud_ext        boolean not null default false,
  firma_director_prog text not null default '',
  firma_calidad_prog  text not null default '',

  -- R-93/02: Reporte de Revisión
  rep_fecha           date,
  rep_lugar           text not null default '',
  rep_hora_inicio     text not null default '',
  rep_hora_cierre     text not null default '',
  agenda              jsonb not null default '[]',   -- [{tema, relevancia, observaciones}]
  decisiones          jsonb not null default '[]',   -- [{tema, descripcion, responsable, acciones, fecha_cumplimiento}]
  firma_director_rep  text not null default '',
  firma_calidad_rep   text not null default '',

  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

create index if not exists idx_revision_fecha on public.sgc_revision_direccion(fecha desc);

alter table public.sgc_revision_direccion enable row level security;

drop policy if exists "revision_select" on public.sgc_revision_direccion;
drop policy if exists "revision_insert" on public.sgc_revision_direccion;
drop policy if exists "revision_update" on public.sgc_revision_direccion;
drop policy if exists "revision_delete" on public.sgc_revision_direccion;

-- Todos los usuarios autenticados pueden ver las revisiones
create policy "revision_select" on public.sgc_revision_direccion
  for select to authenticated using (true);

-- Solo calidad/admin pueden insertar, actualizar y eliminar
-- (el control adicional se hace en la capa de aplicación)
create policy "revision_insert" on public.sgc_revision_direccion
  for insert to authenticated with check (true);

create policy "revision_update" on public.sgc_revision_direccion
  for update to authenticated using (true) with check (true);

create policy "revision_delete" on public.sgc_revision_direccion
  for delete to authenticated using (true);

-- Trigger updated_at
drop trigger if exists trg_revision_updated_at on public.sgc_revision_direccion;
create trigger trg_revision_updated_at
  before update on public.sgc_revision_direccion
  for each row execute function public.set_updated_at();

-- GRANTs
grant select, insert, update, delete on public.sgc_revision_direccion to authenticated;
revoke all on public.sgc_revision_direccion from anon;
