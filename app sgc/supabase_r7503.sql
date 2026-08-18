-- SGC ENUFC: Tabla para el Listado de Registros (R-75/03).
-- Ejecutar en Supabase > SQL Editor > Run.

create table if not exists public.sgc_r7503 (
  id            text primary key,
  area_id       text not null,        -- sgc | ce | dir | sa | tit | doc
  codigo        text not null,
  titulo        text not null,
  revision      text not null default '00',
  fecha         text not null default '',
  responsable   text not null default '',
  area_label    text not null default '',  -- texto del área en el formato impreso
  orden         integer not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists idx_r7503_area_id on public.sgc_r7503(area_id);
create index if not exists idx_r7503_orden   on public.sgc_r7503(area_id, orden);

alter table public.sgc_r7503 enable row level security;

drop policy if exists "r7503_select" on public.sgc_r7503;
drop policy if exists "r7503_insert" on public.sgc_r7503;
drop policy if exists "r7503_update" on public.sgc_r7503;
drop policy if exists "r7503_delete" on public.sgc_r7503;

-- Todos los usuarios autenticados pueden ver y modificar (documento institucional)
create policy "r7503_select" on public.sgc_r7503
  for select to authenticated using (true);

create policy "r7503_insert" on public.sgc_r7503
  for insert to authenticated with check (true);

create policy "r7503_update" on public.sgc_r7503
  for update to authenticated using (true) with check (true);

create policy "r7503_delete" on public.sgc_r7503
  for delete to authenticated using (true);

-- Trigger updated_at
drop trigger if exists trg_r7503_updated_at on public.sgc_r7503;
create trigger trg_r7503_updated_at
  before update on public.sgc_r7503
  for each row execute function public.set_updated_at();

-- GRANTs
grant select, insert, update, delete on public.sgc_r7503 to authenticated;
revoke all on public.sgc_r7503 from anon;
