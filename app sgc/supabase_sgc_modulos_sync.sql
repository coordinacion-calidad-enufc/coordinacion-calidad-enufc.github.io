-- SGC ENUFC: sincronizacion en nube para modulos operativos.
-- Ejecutar una sola vez en Supabase > SQL Editor > Run.
-- No borra datos existentes.

create extension if not exists pgcrypto;

-- ============================================================
-- R-102/02 y R-102/03: No conformidades
-- ============================================================
create table if not exists public.no_conformidades (
  id uuid primary key default gen_random_uuid(),
  local_id text,
  area_numeral text,
  numeral text,
  responsable_area text,
  numero text,
  fecha text,
  elaborador text,
  origenes jsonb not null default '[]'::jsonb,
  tipo text,
  descripcion text,
  correccion text,
  causa_raiz_desc text,
  p5 jsonb not null default '{}'::jsonb,
  pac jsonb not null default '[]'::jsonb,
  fecha_verif text,
  estado text not null default 'abierta',
  efectividad text,
  obs_cierre text,
  seguimiento_atencion text,
  fecha_atencion text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.no_conformidades add column if not exists local_id text;
alter table public.no_conformidades add column if not exists area_numeral text;
alter table public.no_conformidades add column if not exists numeral text;
alter table public.no_conformidades add column if not exists responsable_area text;
alter table public.no_conformidades add column if not exists numero text;
alter table public.no_conformidades add column if not exists fecha text;
alter table public.no_conformidades add column if not exists elaborador text;
alter table public.no_conformidades add column if not exists origenes jsonb not null default '[]'::jsonb;
alter table public.no_conformidades add column if not exists tipo text;
alter table public.no_conformidades add column if not exists descripcion text;
alter table public.no_conformidades add column if not exists correccion text;
alter table public.no_conformidades add column if not exists causa_raiz_desc text;
alter table public.no_conformidades add column if not exists p5 jsonb not null default '{}'::jsonb;
alter table public.no_conformidades add column if not exists pac jsonb not null default '[]'::jsonb;
alter table public.no_conformidades add column if not exists fecha_verif text;
alter table public.no_conformidades add column if not exists estado text not null default 'abierta';
alter table public.no_conformidades add column if not exists efectividad text;
alter table public.no_conformidades add column if not exists obs_cierre text;
alter table public.no_conformidades add column if not exists seguimiento_atencion text;
alter table public.no_conformidades add column if not exists fecha_atencion text;
alter table public.no_conformidades add column if not exists created_at timestamptz not null default now();
alter table public.no_conformidades add column if not exists updated_at timestamptz not null default now();

create unique index if not exists no_conformidades_local_id_idx
  on public.no_conformidades(local_id);

alter table public.no_conformidades enable row level security;

drop policy if exists "no_conformidades_select" on public.no_conformidades;
drop policy if exists "no_conformidades_all" on public.no_conformidades;

create policy "no_conformidades_select"
  on public.no_conformidades for select
  to authenticated
  using (true);

create policy "no_conformidades_all"
  on public.no_conformidades for all
  to authenticated
  using (true)
  with check (true);

-- ============================================================
-- R-93/03: Planes de accion
-- ============================================================
create table if not exists public.planes_accion (
  id uuid primary key default gen_random_uuid(),
  local_id text,
  semestre text,
  fecha text,
  origen text,
  items jsonb not null default '{}'::jsonb,
  obs_general text,
  elaboro text,
  reviso text,
  seguimiento text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.planes_accion add column if not exists local_id text;
alter table public.planes_accion add column if not exists semestre text;
alter table public.planes_accion add column if not exists fecha text;
alter table public.planes_accion add column if not exists origen text;
alter table public.planes_accion add column if not exists items jsonb not null default '{}'::jsonb;
alter table public.planes_accion add column if not exists obs_general text;
alter table public.planes_accion add column if not exists elaboro text;
alter table public.planes_accion add column if not exists reviso text;
alter table public.planes_accion add column if not exists seguimiento text;
alter table public.planes_accion add column if not exists created_at timestamptz not null default now();
alter table public.planes_accion add column if not exists updated_at timestamptz not null default now();

create unique index if not exists planes_accion_local_id_idx
  on public.planes_accion(local_id);

alter table public.planes_accion enable row level security;

drop policy if exists "planes_accion_select" on public.planes_accion;
drop policy if exists "planes_accion_all" on public.planes_accion;

create policy "planes_accion_select"
  on public.planes_accion for select
  to authenticated
  using (true);

create policy "planes_accion_all"
  on public.planes_accion for all
  to authenticated
  using (true)
  with check (true);

-- ============================================================
-- R-71/01: Solicitudes de servicio
-- ============================================================
create table if not exists public.solicitudes_servicio (
  id uuid primary key default gen_random_uuid(),
  local_id text,
  fecha text,
  area text,
  tipo text,
  descripcion text,
  solicitante text,
  entrega text,
  fecha_entrega text,
  quien_recibe text,
  fecha_recepcion text,
  vobo text,
  observaciones text,
  estado text not null default 'pendiente',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.solicitudes_servicio add column if not exists local_id text;
alter table public.solicitudes_servicio add column if not exists fecha text;
alter table public.solicitudes_servicio add column if not exists area text;
alter table public.solicitudes_servicio add column if not exists tipo text;
alter table public.solicitudes_servicio add column if not exists descripcion text;
alter table public.solicitudes_servicio add column if not exists solicitante text;
alter table public.solicitudes_servicio add column if not exists entrega text;
alter table public.solicitudes_servicio add column if not exists fecha_entrega text;
alter table public.solicitudes_servicio add column if not exists quien_recibe text;
alter table public.solicitudes_servicio add column if not exists fecha_recepcion text;
alter table public.solicitudes_servicio add column if not exists vobo text;
alter table public.solicitudes_servicio add column if not exists observaciones text;
alter table public.solicitudes_servicio add column if not exists estado text not null default 'pendiente';
alter table public.solicitudes_servicio add column if not exists created_at timestamptz not null default now();
alter table public.solicitudes_servicio add column if not exists updated_at timestamptz not null default now();

create unique index if not exists solicitudes_servicio_local_id_idx
  on public.solicitudes_servicio(local_id);

alter table public.solicitudes_servicio enable row level security;

drop policy if exists "solicitudes_servicio_select" on public.solicitudes_servicio;
drop policy if exists "solicitudes_servicio_all" on public.solicitudes_servicio;

create policy "solicitudes_servicio_select"
  on public.solicitudes_servicio for select
  to authenticated
  using (true);

create policy "solicitudes_servicio_all"
  on public.solicitudes_servicio for all
  to authenticated
  using (true)
  with check (true);

-- ============================================================
-- R-92/01: Plan de auditoria interna
-- ============================================================
create table if not exists public.planes_auditoria (
  id uuid primary key default gen_random_uuid(),
  local_id text,
  numero text,
  fecha text,
  estado text not null default 'programado',
  objetivo text,
  alcance text,
  criterios text,
  lider text,
  equipo text,
  areas text,
  elaboro text,
  reviso text,
  filas jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.planes_auditoria add column if not exists local_id text;
alter table public.planes_auditoria add column if not exists numero text;
alter table public.planes_auditoria add column if not exists fecha text;
alter table public.planes_auditoria add column if not exists estado text not null default 'programado';
alter table public.planes_auditoria add column if not exists objetivo text;
alter table public.planes_auditoria add column if not exists alcance text;
alter table public.planes_auditoria add column if not exists criterios text;
alter table public.planes_auditoria add column if not exists lider text;
alter table public.planes_auditoria add column if not exists equipo text;
alter table public.planes_auditoria add column if not exists areas text;
alter table public.planes_auditoria add column if not exists elaboro text;
alter table public.planes_auditoria add column if not exists reviso text;
alter table public.planes_auditoria add column if not exists filas jsonb not null default '[]'::jsonb;
alter table public.planes_auditoria add column if not exists created_at timestamptz not null default now();
alter table public.planes_auditoria add column if not exists updated_at timestamptz not null default now();

create unique index if not exists planes_auditoria_local_id_idx
  on public.planes_auditoria(local_id);

alter table public.planes_auditoria enable row level security;

drop policy if exists "planes_auditoria_select" on public.planes_auditoria;
drop policy if exists "planes_auditoria_all" on public.planes_auditoria;

create policy "planes_auditoria_select"
  on public.planes_auditoria for select
  to authenticated
  using (true);

create policy "planes_auditoria_all"
  on public.planes_auditoria for all
  to authenticated
  using (true)
  with check (true);
