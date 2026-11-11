-- Habilita extensão para geração de UUIDs caso necessário
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Função utilitária para atualizar updated_at e incrementar version automaticamente
CREATE OR REPLACE FUNCTION public.handle_updated_at_and_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_updated_at_only()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 1. TABELA: songs
-- ============================================================================
CREATE TABLE public.songs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL CHECK (char_length(trim(title)) > 0 AND char_length(title) <= 200),
    version INTEGER NOT NULL DEFAULT 1 CHECK (version >= 1),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL
);

CREATE INDEX idx_songs_user_id ON public.songs(user_id);
CREATE INDEX idx_songs_updated_at ON public.songs(user_id, updated_at);

CREATE TRIGGER trg_songs_updated_at
    BEFORE UPDATE ON public.songs
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at_and_version();

-- ============================================================================
-- 2. TABELA: song_assets
-- ============================================================================
CREATE TABLE public.song_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    song_id UUID NOT NULL REFERENCES public.songs(id) ON DELETE CASCADE,
    asset_type TEXT NOT NULL CHECK (asset_type IN ('pdf', 'audio')),
    revision INTEGER NOT NULL CHECK (revision >= 1),
    storage_path TEXT NOT NULL CHECK (char_length(trim(storage_path)) > 0),
    mime_type TEXT NOT NULL CHECK (mime_type IN ('application/pdf', 'audio/mpeg', 'audio/mp3')),
    file_size BIGINT NOT NULL CHECK (file_size > 0),
    checksum TEXT NOT NULL CHECK (char_length(trim(checksum)) >= 32),
    is_active BOOLEAN NOT NULL DEFAULT true,
    version INTEGER NOT NULL DEFAULT 1 CHECK (version >= 1),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL,
    CONSTRAINT uq_song_assets_revision UNIQUE (song_id, asset_type, revision)
);

-- Garante apenas 1 asset ativo por tipo (pdf ou audio) para cada música (ignorando excluídos)
CREATE UNIQUE INDEX idx_song_assets_single_active
    ON public.song_assets(song_id, asset_type)
    WHERE is_active = true AND deleted_at IS NULL;

CREATE INDEX idx_song_assets_song_id ON public.song_assets(song_id);

CREATE TRIGGER trg_song_assets_updated_at
    BEFORE UPDATE ON public.song_assets
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at_and_version();

-- ============================================================================
-- 3. TABELA: sync_versions
-- ============================================================================
CREATE TABLE public.sync_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    song_id UUID NOT NULL REFERENCES public.songs(id) ON DELETE CASCADE,
    pdf_asset_id UUID NOT NULL REFERENCES public.song_assets(id) ON DELETE CASCADE,
    audio_asset_id UUID NOT NULL REFERENCES public.song_assets(id) ON DELETE CASCADE,
    audio_duration_ms INTEGER NOT NULL CHECK (audio_duration_ms > 0),
    is_active BOOLEAN NOT NULL DEFAULT true,
    version INTEGER NOT NULL DEFAULT 1 CHECK (version >= 1),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL
);

-- Garante apenas 1 versão de sincronização ativa por música
CREATE UNIQUE INDEX idx_sync_versions_single_active
    ON public.sync_versions(song_id)
    WHERE is_active = true AND deleted_at IS NULL;

CREATE INDEX idx_sync_versions_song_id ON public.sync_versions(song_id);

-- Trigger para validar que pdf_asset_id e audio_asset_id pertencem ao mesmo song_id e possuem os tipos corretos
CREATE OR REPLACE FUNCTION public.validate_sync_version_assets()
RETURNS TRIGGER AS $$
DECLARE
    v_pdf_song_id UUID;
    v_pdf_type TEXT;
    v_audio_song_id UUID;
    v_audio_type TEXT;
BEGIN
    SELECT song_id, asset_type INTO v_pdf_song_id, v_pdf_type
    FROM public.song_assets WHERE id = NEW.pdf_asset_id;

    IF v_pdf_song_id IS DISTINCT FROM NEW.song_id OR v_pdf_type <> 'pdf' THEN
        RAISE EXCEPTION 'pdf_asset_id deve pertencer à mesma música e ser do tipo pdf';
    END IF;

    SELECT song_id, asset_type INTO v_audio_song_id, v_audio_type
    FROM public.song_assets WHERE id = NEW.audio_asset_id;

    IF v_audio_song_id IS DISTINCT FROM NEW.song_id OR v_audio_type <> 'audio' THEN
        RAISE EXCEPTION 'audio_asset_id deve pertencer à mesma música e ser do tipo audio';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_sync_version_assets
    BEFORE INSERT OR UPDATE ON public.sync_versions
    FOR EACH ROW
    EXECUTE FUNCTION public.validate_sync_version_assets();

CREATE TRIGGER trg_sync_versions_updated_at
    BEFORE UPDATE ON public.sync_versions
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at_and_version();

-- ============================================================================
-- 4. TABELA: measures
-- ============================================================================
CREATE TABLE public.measures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sync_id UUID NOT NULL REFERENCES public.sync_versions(id) ON DELETE CASCADE,
    measure_order INTEGER NOT NULL CHECK (measure_order >= 1),
    measure_label TEXT NOT NULL DEFAULT '' CHECK (char_length(measure_label) <= 50),
    start_ms INTEGER NULL CHECK (start_ms IS NULL OR start_ms >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_measures_order UNIQUE (sync_id, measure_order)
);

CREATE INDEX idx_measures_sync_id_order ON public.measures(sync_id, measure_order);
CREATE INDEX idx_measures_sync_id_start_ms ON public.measures(sync_id, start_ms);

-- Trigger para validar que start_ms não ultrapassa audio_duration_ms da sync_version
CREATE OR REPLACE FUNCTION public.validate_measure_timestamp()
RETURNS TRIGGER AS $$
DECLARE
    v_duration_ms INTEGER;
BEGIN
    IF NEW.start_ms IS NOT NULL THEN
        SELECT audio_duration_ms INTO v_duration_ms
        FROM public.sync_versions WHERE id = NEW.sync_id;

        IF v_duration_ms IS NOT NULL AND NEW.start_ms > v_duration_ms THEN
            RAISE EXCEPTION 'start_ms (%) excede a duração do áudio (%)', NEW.start_ms, v_duration_ms;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_measure_timestamp
    BEFORE INSERT OR UPDATE ON public.measures
    FOR EACH ROW
    EXECUTE FUNCTION public.validate_measure_timestamp();

CREATE TRIGGER trg_measures_updated_at
    BEFORE UPDATE ON public.measures
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at_only();

-- ============================================================================
-- 5. TABELA: measure_regions
-- ============================================================================
CREATE TABLE public.measure_regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    measure_id UUID NOT NULL REFERENCES public.measures(id) ON DELETE CASCADE,
    region_order INTEGER NOT NULL DEFAULT 1 CHECK (region_order >= 1),
    page_number INTEGER NOT NULL CHECK (page_number >= 1),
    x DOUBLE PRECISION NOT NULL CHECK (x >= 0.0 AND x <= 1.0),
    y DOUBLE PRECISION NOT NULL CHECK (y >= 0.0 AND y <= 1.0),
    w DOUBLE PRECISION NOT NULL CHECK (w > 0.0 AND w <= 1.0 AND (x + w) <= 1.0001),
    h DOUBLE PRECISION NOT NULL CHECK (h > 0.0 AND h <= 1.0 AND (y + h) <= 1.0001),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_measure_regions_order UNIQUE (measure_id, region_order)
);

CREATE INDEX idx_measure_regions_measure_id ON public.measure_regions(measure_id);
CREATE INDEX idx_measure_regions_page ON public.measure_regions(measure_id, page_number);

CREATE TRIGGER trg_measure_regions_updated_at
    BEFORE UPDATE ON public.measure_regions
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at_only();
