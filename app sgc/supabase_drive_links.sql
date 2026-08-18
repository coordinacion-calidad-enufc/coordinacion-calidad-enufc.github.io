-- SGC ENUFC: Tabla para el Repositorio de enlaces a Google Drive.
-- Ejecutar en Supabase > SQL Editor > Run.

create table if not exists public.sgc_drive_links (
  id          text primary key,
  area_id     text not null,          -- sgc | ce | dir | sa | tit | doc
  tipo        text not null,          -- procedimientos | registros
  codigo      text not null default '',
  nombre      text not null,
  url         text not null default '',
  descripcion text not null default '',
  orden       integer not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists idx_drive_area_tipo on public.sgc_drive_links(area_id, tipo);
create index if not exists idx_drive_orden     on public.sgc_drive_links(area_id, tipo, orden);

alter table public.sgc_drive_links enable row level security;

drop policy if exists "drive_select" on public.sgc_drive_links;
drop policy if exists "drive_insert" on public.sgc_drive_links;
drop policy if exists "drive_update" on public.sgc_drive_links;
drop policy if exists "drive_delete" on public.sgc_drive_links;

-- Todos los usuarios autenticados pueden ver los enlaces
create policy "drive_select" on public.sgc_drive_links
  for select to authenticated using (true);

-- Solo coordinación/admin pueden insertar, actualizar y eliminar
-- (el control de permisos adicional se hace en la capa de aplicación)
create policy "drive_insert" on public.sgc_drive_links
  for insert to authenticated with check (true);

create policy "drive_update" on public.sgc_drive_links
  for update to authenticated using (true) with check (true);

create policy "drive_delete" on public.sgc_drive_links
  for delete to authenticated using (true);

-- Trigger updated_at
drop trigger if exists trg_drive_updated_at on public.sgc_drive_links;
create trigger trg_drive_updated_at
  before update on public.sgc_drive_links
  for each row execute function public.set_updated_at();

-- GRANTs
grant select, insert, update, delete on public.sgc_drive_links to authenticated;
revoke all on public.sgc_drive_links from anon;
