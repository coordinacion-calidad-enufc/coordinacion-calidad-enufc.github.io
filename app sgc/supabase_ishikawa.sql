-- Agregar columna ishikawa a la tabla de no conformidades
-- Ejecutar en Supabase SQL Editor

ALTER TABLE no_conformidades
ADD COLUMN IF NOT EXISTS ishikawa JSONB DEFAULT '{}';
