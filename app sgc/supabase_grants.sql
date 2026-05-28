-- SGC ENUFC: GRANTs explícitos para todas las tablas del proyecto.
-- Ejecutar en Supabase > SQL Editor > Run.
--
-- Contexto: A partir del 30 de mayo de 2026, Supabase requiere GRANTs
-- explícitos en tablas nuevas. A partir del 30 de octubre de 2026 se
-- aplica también a proyectos existentes.
-- Este script cubre todas las tablas actuales del SGC ENUFC.

-- ============================================================
-- Tablas originales del SGC
-- ============================================================

grant select, insert, update, delete on public.areas              to authenticated;
grant select, insert, update, delete on public.usuarios           to authenticated;
grant select, insert, update, delete on public.configuracion_sgc  to authenticated;
grant select, insert, update, delete on public.indicadores        to authenticated;
grant select, insert, update, delete on public.preguntas_auditoria to authenticated;
grant select, insert, update, delete on public.auditorias         to authenticated;
grant select, insert, update, delete on public.auditoria_resultados to authenticated;
grant select, insert, update, delete on public.mediciones         to authenticated;

-- ============================================================
-- Módulos operativos (supabase_sgc_modulos_sync.sql)
-- ============================================================

grant select, insert, update, delete on public.no_conformidades   to authenticated;
grant select, insert, update, delete on public.planes_accion      to authenticated;
grant select, insert, update, delete on public.solicitudes_servicio to authenticated;
grant select, insert, update, delete on public.planes_auditoria   to authenticated;

-- ============================================================
-- Control Documental y Solicitudes de Cambio (supabase_nuevas_tablas_v2.sql)
-- ============================================================

grant select, insert, update, delete on public.documentos_sgc    to authenticated;
grant select, insert, update, delete on public.solicitudes_cambio to authenticated;

-- ============================================================
-- Asignaciones de indicadores (supabase_asignaciones.sql)
-- ============================================================

grant select, insert, update, delete on public.asignaciones_indicadores to authenticated;

-- ============================================================
-- Notificaciones in-app (supabase_notificaciones.sql)
-- ============================================================

grant select, insert, update        on public.notificaciones      to authenticated;

-- ============================================================
-- Planificación SGC: Política, FODA, Objetivos, Eficacia
-- (supabase_planificacion.sql)
-- ============================================================

grant select, insert, update, delete on public.sgc_planificacion  to authenticated;

-- ============================================================
-- Tareas personales por usuario (supabase_tareas.sql)
-- ============================================================

grant select, insert, update, delete on public.sgc_tareas_personales to authenticated;

-- ============================================================
-- Eventos del calendario SGC (supabase_eventos_calendario.sql)
-- ============================================================

grant select, insert, update, delete on public.sgc_eventos_calendario to authenticated;

-- ============================================================
-- Listado de Registros R-75/03 (supabase_r7503.sql)
-- ============================================================

grant select, insert, update, delete on public.sgc_r7503 to authenticated;

-- ============================================================
-- Repositorio Drive (supabase_drive_links.sql)
-- ============================================================

grant select, insert, update, delete on public.sgc_drive_links to authenticated;

-- ============================================================
-- Revisión por la Dirección (supabase_revision_direccion.sql)
-- ============================================================

grant select, insert, update, delete on public.sgc_revision_direccion to authenticated;

-- ============================================================
-- Revocar acceso anónimo (la app exige autenticación siempre)
-- ============================================================

revoke all on public.areas               from anon;
revoke all on public.usuarios            from anon;
revoke all on public.configuracion_sgc   from anon;
revoke all on public.indicadores         from anon;
revoke all on public.preguntas_auditoria from anon;
revoke all on public.auditorias          from anon;
revoke all on public.auditoria_resultados from anon;
revoke all on public.mediciones          from anon;
revoke all on public.no_conformidades    from anon;
revoke all on public.planes_accion       from anon;
revoke all on public.solicitudes_servicio from anon;
revoke all on public.planes_auditoria    from anon;
revoke all on public.documentos_sgc      from anon;
revoke all on public.solicitudes_cambio  from anon;
revoke all on public.asignaciones_indicadores from anon;
revoke all on public.notificaciones      from anon;
revoke all on public.sgc_planificacion   from anon;
revoke all on public.sgc_tareas_personales from anon;
revoke all on public.sgc_eventos_calendario from anon;
revoke all on public.sgc_r7503             from anon;
revoke all on public.sgc_drive_links       from anon;
revoke all on public.sgc_revision_direccion from anon;
