-- Habilita Row Level Security em todas as tabelas
ALTER TABLE public.songs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.song_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.measures ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.measure_regions ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 1. POLÍTICAS RLS: songs
-- ============================================================================
CREATE POLICY "songs_select_own" ON public.songs
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

CREATE POLICY "songs_insert_own" ON public.songs
    FOR INSERT TO authenticated
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "songs_update_own" ON public.songs
    FOR UPDATE TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "songs_delete_own" ON public.songs
    FOR DELETE TO authenticated
    USING (user_id = auth.uid());

-- ============================================================================
-- 2. POLÍTICAS RLS: song_assets
-- ============================================================================
CREATE POLICY "song_assets_select_own" ON public.song_assets
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = song_assets.song_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "song_assets_insert_own" ON public.song_assets
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = song_assets.song_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "song_assets_update_own" ON public.song_assets
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = song_assets.song_id AND s.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = song_assets.song_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "song_assets_delete_own" ON public.song_assets
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = song_assets.song_id AND s.user_id = auth.uid()
        )
    );

-- ============================================================================
-- 3. POLÍTICAS RLS: sync_versions
-- ============================================================================
CREATE POLICY "sync_versions_select_own" ON public.sync_versions
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = sync_versions.song_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "sync_versions_insert_own" ON public.sync_versions
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = sync_versions.song_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "sync_versions_update_own" ON public.sync_versions
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = sync_versions.song_id AND s.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = sync_versions.song_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "sync_versions_delete_own" ON public.sync_versions
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.songs s
            WHERE s.id = sync_versions.song_id AND s.user_id = auth.uid()
        )
    );

-- ============================================================================
-- 4. POLÍTICAS RLS: measures
-- ============================================================================
CREATE POLICY "measures_select_own" ON public.measures
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.sync_versions sv
            JOIN public.songs s ON s.id = sv.song_id
            WHERE sv.id = measures.sync_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "measures_insert_own" ON public.measures
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.sync_versions sv
            JOIN public.songs s ON s.id = sv.song_id
            WHERE sv.id = measures.sync_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "measures_update_own" ON public.measures
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.sync_versions sv
            JOIN public.songs s ON s.id = sv.song_id
            WHERE sv.id = measures.sync_id AND s.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.sync_versions sv
            JOIN public.songs s ON s.id = sv.song_id
            WHERE sv.id = measures.sync_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "measures_delete_own" ON public.measures
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.sync_versions sv
            JOIN public.songs s ON s.id = sv.song_id
            WHERE sv.id = measures.sync_id AND s.user_id = auth.uid()
        )
    );

-- ============================================================================
-- 5. POLÍTICAS RLS: measure_regions
-- ============================================================================
CREATE POLICY "measure_regions_select_own" ON public.measure_regions
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.measures m
            JOIN public.sync_versions sv ON sv.id = m.sync_id
            JOIN public.songs s ON s.id = sv.song_id
            WHERE m.id = measure_regions.measure_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "measure_regions_insert_own" ON public.measure_regions
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.measures m
            JOIN public.sync_versions sv ON sv.id = m.sync_id
            JOIN public.songs s ON s.id = sv.song_id
            WHERE m.id = measure_regions.measure_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "measure_regions_update_own" ON public.measure_regions
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.measures m
            JOIN public.sync_versions sv ON sv.id = m.sync_id
            JOIN public.songs s ON s.id = sv.song_id
            WHERE m.id = measure_regions.measure_id AND s.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.measures m
            JOIN public.sync_versions sv ON sv.id = m.sync_id
            JOIN public.songs s ON s.id = sv.song_id
            WHERE m.id = measure_regions.measure_id AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "measure_regions_delete_own" ON public.measure_regions
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.measures m
            JOIN public.sync_versions sv ON sv.id = m.sync_id
            JOIN public.songs s ON s.id = sv.song_id
            WHERE m.id = measure_regions.measure_id AND s.user_id = auth.uid()
        )
    );

