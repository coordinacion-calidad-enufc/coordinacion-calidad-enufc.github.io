-- SGC ENUFC: Tabla de notificaciones in-app.
-- Ejecutar una sola vez en Supabase > SQL Editor > Run.

create extension if not exists pgcrypto;

create table if not exists public.notificaciones (
  id uuid primary key default gen_random_uuid(),
  de_usuario text,
  para_usuario text,
  para_rol text,
  para_area text,
  tipo text not null default 'info',
  mensaje text not null,
  referencia_id text,
  leida boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.notificaciones enable row level security;

drop policy if exists "notif_select" on public.notificaciones;
drop policy if exists "notif_insert" on public.notificaciones;
drop policy if exists "notif_update" on public.notificaciones;

-- Cualquier usuario autenticado puede leer (el filtro por rol/area se hace en el cliente)
create policy "notif_select"
  on public.notificaciones for select
  to authenticated
  using (true);

-- Cualquier usuario autenticado puede insertar (crear notificaciones)
create policy "notif_insert"
  on public.notificaciones for insert
  to authenticated
  with check (true);

-- Cualquier usuario autenticado puede marcar como leída
create policy "notif_update"
  on public.notificaciones for update
  to authenticated
  using (true)
  with check (true);
