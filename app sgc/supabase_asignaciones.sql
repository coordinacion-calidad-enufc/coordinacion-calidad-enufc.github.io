-- SGC ENUFC: Tabla de asignaciones de indicadores por área.
-- Ejecutar una sola vez en Supabase > SQL Editor > Run.

create extension if not exists pgcrypto;

create table if not exists public.asignaciones_indicadores (
  id uuid primary key default gen_random_uuid(),
  local_id text unique,
  area text not null,
  indicador_id text,
  nombre_indicador text not null,
  fecha_limite text not null,
  nota text,
  asignado_por text,
  completada boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists asignaciones_indicadores_local_id_idx
  on public.asignaciones_indicadores(local_id);

alter table public.asignaciones_indicadores enable row level security;

drop policy if exists "asig_select" on public.asignaciones_indicadores;
drop policy if exists "asig_all" on public.asignaciones_indicadores;

create policy "asig_select"
  on public.asignaciones_indicadores for select
  to authenticated using (true);

create policy "asig_all"
  on public.asignaciones_indicadores for all
  to authenticated using (true) with check (true);

drop trigger if exists trg_asignaciones_updated_at on public.asignaciones_indicadores;
create trigger trg_asignaciones_updated_at
  before update on public.asignaciones_indicadores
  for each row execute function public.set_updated_at();
