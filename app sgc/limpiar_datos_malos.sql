-- LIMPIEZA FINAL: conserva SOLO semestres válidos (lista blanca)
-- Ejecutar en Supabase > SQL Editor > Run

DELETE FROM public.sgc_encuesta_satisfaccion
WHERE semestre NOT IN (
  'Primero','Segundo','Tercero','Cuarto',
  'Quinto','Sexto','Séptimo','Octavo'
);

DELETE FROM public.sgc_ficha_satisfaccion
WHERE semestre NOT IN (
  'Primero','Segundo','Tercero','Cuarto',
  'Quinto','Sexto','Séptimo','Octavo'
);

-- Verificar resultado:
SELECT 'encuesta' AS tabla, semestre, count(*) AS total
FROM public.sgc_encuesta_satisfaccion
GROUP BY semestre ORDER BY semestre;

SELECT 'ficha' AS tabla, semestre, count(*) AS total
FROM public.sgc_ficha_satisfaccion
GROUP BY semestre ORDER BY semestre;
