-- SGC ENUFC: Tabla para Política de Calidad, FODA, Seguimiento FODA y Objetivos de Calidad.
-- Ejecutar una sola vez en Supabase > SQL Editor > Run.

create extension if not exists pgcrypto;

-- Tabla genérica clave-valor para documentos de planificación
create table if not exists public.sgc_planificacion (
  clave text primary key,
  valor jsonb not null default '{}',
  updated_at timestamptz not null default now()
);

alter table public.sgc_planificacion enable row level security;

drop policy if exists "plan_select" on public.sgc_planificacion;
drop policy if exists "plan_all" on public.sgc_planificacion;

create policy "plan_select"
  on public.sgc_planificacion for select
  to authenticated using (true);

create policy "plan_all"
  on public.sgc_planificacion for all
  to authenticated using (true) with check (true);

drop trigger if exists trg_sgc_planificacion_updated_at on public.sgc_planificacion;
create trigger trg_sgc_planificacion_updated_at
  before update on public.sgc_planificacion
  for each row execute function public.set_updated_at();
