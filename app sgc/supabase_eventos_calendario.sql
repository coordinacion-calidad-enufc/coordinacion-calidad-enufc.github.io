-- SGC ENUFC: Tabla de eventos personalizados del calendario.
-- Ejecutar en Supabase > SQL Editor > Run.

create table if not exists public.sgc_eventos_calendario (
  id          text primary key,
  titulo      text not null,
  tipo        text not null default 'otro',
  fecha       date not null,
  fecha_fin   date,
  descripcion text not null default '',
  creado_por  text not null default '',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists idx_eventos_cal_fecha on public.sgc_eventos_calendario(fecha);

alter table public.sgc_eventos_calendario enable row level security;

drop policy if exists "eventos_cal_select" on public.sgc_eventos_calendario;
drop policy if exists "eventos_cal_insert" on public.sgc_eventos_calendario;
drop policy if exists "eventos_cal_update" on public.sgc_eventos_calendario;
drop policy if exists "eventos_cal_delete" on public.sgc_eventos_calendario;

-- Todos los usuarios autenticados ven todos los eventos (son institucionales)
create policy "eventos_cal_select" on public.sgc_eventos_calendario
  for select to authenticated using (true);

create policy "eventos_cal_insert" on public.sgc_eventos_calendario
  for insert to authenticated with check (true);

create policy "eventos_cal_update" on public.sgc_eventos_calendario
  for update to authenticated using (true) with check (true);

create policy "eventos_cal_delete" on public.sgc_eventos_calendario
  for delete to authenticated using (true);

-- Trigger updated_at
drop trigger if exists trg_eventos_cal_updated_at on public.sgc_eventos_calendario;
create trigger trg_eventos_cal_updated_at
  before update on public.sgc_eventos_calendario
  for each row execute function public.set_updated_at();

-- GRANTs
grant select, insert, update, delete on public.sgc_eventos_calendario to authenticated;
revoke all on public.sgc_eventos_calendario from anon;
