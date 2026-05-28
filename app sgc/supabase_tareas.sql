-- SGC ENUFC: Tabla de tareas personales por usuario.
-- Ejecutar en Supabase > SQL Editor > Run.

create table if not exists public.sgc_tareas_personales (
  id            text primary key,
  usuario_email text not null,
  titulo        text not null,
  descripcion   text not null default '',
  tags          jsonb not null default '[]',
  completada    boolean not null default false,
  creada        timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists idx_tareas_usuario on public.sgc_tareas_personales(usuario_email);

alter table public.sgc_tareas_personales enable row level security;

drop policy if exists "tareas_select" on public.sgc_tareas_personales;
drop policy if exists "tareas_insert" on public.sgc_tareas_personales;
drop policy if exists "tareas_update" on public.sgc_tareas_personales;
drop policy if exists "tareas_delete" on public.sgc_tareas_personales;

-- Cada usuario sólo ve y modifica sus propias tareas
create policy "tareas_select" on public.sgc_tareas_personales
  for select to authenticated
  using (usuario_email = auth.jwt() ->> 'email');

create policy "tareas_insert" on public.sgc_tareas_personales
  for insert to authenticated
  with check (usuario_email = auth.jwt() ->> 'email');

create policy "tareas_update" on public.sgc_tareas_personales
  for update to authenticated
  using (usuario_email = auth.jwt() ->> 'email')
  with check (usuario_email = auth.jwt() ->> 'email');

create policy "tareas_delete" on public.sgc_tareas_personales
  for delete to authenticated
  using (usuario_email = auth.jwt() ->> 'email');

-- Trigger updated_at
drop trigger if exists trg_tareas_updated_at on public.sgc_tareas_personales;
create trigger trg_tareas_updated_at
  before update on public.sgc_tareas_personales
  for each row execute function public.set_updated_at();

-- GRANTs
grant select, insert, update, delete on public.sgc_tareas_personales to authenticated;
revoke all on public.sgc_tareas_personales from anon;
