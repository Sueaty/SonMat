-- ============================================================
-- SonMat — Migration 002: Row Level Security policies
-- Run AFTER 001_create_tables.sql
-- ============================================================

-- Enable RLS on both tables
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE steps   ENABLE ROW LEVEL SECURITY;

-- ── recipes policies ─────────────────────────────────────────

-- Anyone (including anon key) can read all recipes
CREATE POLICY "recipes: public read"
    ON recipes FOR SELECT
    USING (true);

-- Only authenticated users (the admin) can insert
CREATE POLICY "recipes: authenticated insert"
    ON recipes FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

-- Only authenticated users can update
CREATE POLICY "recipes: authenticated update"
    ON recipes FOR UPDATE
    USING (auth.uid() IS NOT NULL)
    WITH CHECK (auth.uid() IS NOT NULL);

-- Only authenticated users can delete
CREATE POLICY "recipes: authenticated delete"
    ON recipes FOR DELETE
    USING (auth.uid() IS NOT NULL);

-- ── steps policies ───────────────────────────────────────────

-- Anyone (including anon key) can read all steps
CREATE POLICY "steps: public read"
    ON steps FOR SELECT
    USING (true);

-- Only authenticated users can insert
CREATE POLICY "steps: authenticated insert"
    ON steps FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

-- Only authenticated users can update
CREATE POLICY "steps: authenticated update"
    ON steps FOR UPDATE
    USING (auth.uid() IS NOT NULL)
    WITH CHECK (auth.uid() IS NOT NULL);

-- Only authenticated users can delete
CREATE POLICY "steps: authenticated delete"
    ON steps FOR DELETE
    USING (auth.uid() IS NOT NULL);
