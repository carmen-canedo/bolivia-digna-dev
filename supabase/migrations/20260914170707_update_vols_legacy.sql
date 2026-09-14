ALTER TABLE public.vols ALTER COLUMN fecha_nacimiento DROP NOT NULL;
ALTER TABLE public.vols ALTER COLUMN pais_origen DROP NOT NULL;
ALTER TABLE public.vols ADD COLUMN horas_acumuladas INT NOT NULL DEFAULT 0 CHECK (horas_acumuladas >= 0);