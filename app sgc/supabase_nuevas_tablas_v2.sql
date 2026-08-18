-- SGC ENUFC v2: Nuevas tablas para Control Documental, Solicitudes de Cambio.
-- Ejecutar una sola vez en Supabase > SQL Editor > Run.
-- No borra datos existentes.

create extension if not exists pgcrypto;

-- ============================================================
-- documentos_sgc: Control Documental
-- ============================================================
create table if not exists public.documentos_sgc (
  id uuid primary key default gen_random_uuid(),
  local_id text unique,
  codigo text,
  nombre text not null,
  tipo text not null default 'procedimiento',
  area text,
  version text,
  fecha_emision text,
  fecha_revision text,
  estado text not null default 'vigente',
  objetivo text,
  contenido text,
  elaboro text,
  reviso text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.documentos_sgc add column if not exists local_id text;
alter table public.documentos_sgc add column if not exists codigo text;
alter table public.documentos_sgc add column if not exists nombre text;
alter table public.documentos_sgc add column if not exists tipo text not null default 'procedimiento';
alter table public.documentos_sgc add column if not exists area text;
alter table public.documentos_sgc add column if not exists version text;
alter table public.documentos_sgc add column if not exists fecha_emision text;
alter table public.documentos_sgc add column if not exists fecha_revision text;
alter table public.documentos_sgc add column if not exists estado text not null default 'vigente';
alter table public.documentos_sgc add column if not exists objetivo text;
alter table public.documentos_sgc add column if not exists contenido text;
alter table public.documentos_sgc add column if not exists elaboro text;
alter table public.documentos_sgc add column if not exists reviso text;

create unique index if not exists documentos_sgc_local_id_idx
  on public.documentos_sgc(local_id);

alter table public.documentos_sgc enable row level security;

drop policy if exists "documentos_sgc_select" on public.documentos_sgc;
drop policy if exists "documentos_sgc_all" on public.documentos_sgc;

create policy "documentos_sgc_select"
  on public.documentos_sgc for select
  to authenticated
  using (true);

create policy "documentos_sgc_all"
  on public.documentos_sgc for all
  to authenticated
  using (true)
  with check (true);

-- ============================================================
-- solicitudes_cambio: Solicitudes de Cambio Documental
-- ============================================================
create table if not exists public.solicitudes_cambio (
  id uuid primary key default gen_random_uuid(),
  local_id text unique,
  area text,
  fecha text,
  documento text,
  version_actual text,
  version_prop text,
  descripcion text,
  justificacion text,
  solicitante text,
  estado text not null default 'pendiente',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.solicitudes_cambio add column if not exists local_id text;
alter table public.solicitudes_cambio add column if not exists area text;
alter table public.solicitudes_cambio add column if not exists fecha text;
alter table public.solicitudes_cambio add column if not exists documento text;
alter table public.solicitudes_cambio add column if not exists version_actual text;
alter table public.solicitudes_cambio add column if not exists version_prop text;
alter table public.solicitudes_cambio add column if not exists descripcion text;
alter table public.solicitudes_cambio add column if not exists justificacion text;
alter table public.solicitudes_cambio add column if not exists solicitante text;
alter table public.solicitudes_cambio add column if not exists estado text not null default 'pendiente';

create unique index if not exists solicitudes_cambio_local_id_idx
  on public.solicitudes_cambio(local_id);

alter table public.solicitudes_cambio enable row level security;

drop policy if exists "solicitudes_cambio_select" on public.solicitudes_cambio;
drop policy if exists "solicitudes_cambio_all" on public.solicitudes_cambio;

create policy "solicitudes_cambio_select"
  on public.solicitudes_cambio for select
  to authenticated
  using (true);

create policy "solicitudes_cambio_all"
  on public.solicitudes_cambio for all
  to authenticated
  using (true)
  with check (true);

-- ============================================================
-- Trigger para auto-actualizar updated_at
-- ============================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_documentos_sgc_updated_at on public.documentos_sgc;
create trigger trg_documentos_sgc_updated_at
  before update on public.documentos_sgc
  for each row execute function public.set_updated_at();

drop trigger if exists trg_solicitudes_cambio_updated_at on public.solicitudes_cambio;
create trigger trg_solicitudes_cambio_updated_at
  before update on public.solicitudes_cambio
  for each row execute function public.set_updated_at();
