-- Criação dos dois buckets privados: scores (PDF) e audio (MP3)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
    ('scores', 'scores', false, 52428800, ARRAY['application/pdf']),
    ('audio', 'audio', false, 52428800, ARRAY['audio/mpeg', 'audio/mp3'])
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Função auxiliar de segurança para validar o caminho do arquivo no Storage:
-- Formato exigido: {user_id}/{song_id}/{asset_id}.{pdf|mp3} dentro do bucket 'scores' ou 'audio'
CREATE OR REPLACE FUNCTION public.validate_storage_object_access(
    p_bucket_id TEXT,
    p_object_name TEXT,
    p_require_existing_asset BOOLEAN
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_parts TEXT[];
    v_user_id UUID;
    v_song_id UUID;
    v_file_name TEXT;
    v_asset_id UUID;
    v_expected_ext TEXT;
BEGIN
    IF auth.uid() IS NULL THEN
        RETURN false;
    END IF;

    -- Divide "{user_id}/{song_id}/{asset_id}.ext"
    v_parts := string_to_array(p_object_name, '/');
    IF array_length(v_parts, 1) <> 3 THEN
        RETURN false;
    END IF;

    -- 1 e 2. Valida usuário autenticado e identificador no caminho
    BEGIN
        v_user_id := v_parts[1]::UUID;
        v_song_id := v_parts[2]::UUID;
    EXCEPTION WHEN OTHERS THEN
        RETURN false;
    END;

    IF v_user_id <> auth.uid() THEN
        RETURN false;
    END IF;

    -- Valida extensão do arquivo conforme o bucket
    v_file_name := v_parts[3];
    v_expected_ext := CASE WHEN p_bucket_id = 'scores' THEN '.pdf' ELSE '.mp3' END;

    IF right(lower(v_file_name), 4) <> v_expected_ext THEN
        RETURN false;
    END IF;

    BEGIN
        v_asset_id := left(v_file_name, char_length(v_file_name) - 4)::UUID;
    EXCEPTION WHEN OTHERS THEN
        RETURN false;
    END;

    -- 3. Valida propriedade da música na tabela public.songs
    IF NOT EXISTS (
        SELECT 1 FROM public.songs s
        WHERE s.id = v_song_id AND s.user_id = auth.uid()
    ) THEN
        RETURN false;
    END IF;

    -- 4. Para leitura/atualização/exclusão (ou caso o asset já esteja registrado),
    -- valida correspondência entre o arquivo e o song_assets autorizado
    IF p_require_existing_asset THEN
        IF NOT EXISTS (
            SELECT 1 FROM public.song_assets sa
            WHERE sa.id = v_asset_id
              AND sa.song_id = v_song_id
              AND sa.storage_path = p_object_name
        ) THEN
            RETURN false;
        END IF;
    END IF;

    RETURN true;
END;
$$;

-- Políticas de Storage para os buckets 'scores' e 'audio'
CREATE POLICY "storage_select_own_media" ON storage.objects
    FOR SELECT TO authenticated
    USING (
        bucket_id IN ('scores', 'audio')
        AND public.validate_storage_object_access(bucket_id, name, false)
    );

CREATE POLICY "storage_insert_own_media" ON storage.objects
    FOR INSERT TO authenticated
    WITH CHECK (
        bucket_id IN ('scores', 'audio')
        AND public.validate_storage_object_access(bucket_id, name, false)
    );

CREATE POLICY "storage_update_own_media" ON storage.objects
    FOR UPDATE TO authenticated
    USING (
        bucket_id IN ('scores', 'audio')
        AND public.validate_storage_object_access(bucket_id, name, false)
    )
    WITH CHECK (
        bucket_id IN ('scores', 'audio')
        AND public.validate_storage_object_access(bucket_id, name, false)
    );

CREATE POLICY "storage_delete_own_media" ON storage.objects
    FOR DELETE TO authenticated
    USING (
        bucket_id IN ('scores', 'audio')
        AND public.validate_storage_object_access(bucket_id, name, false)
    );

