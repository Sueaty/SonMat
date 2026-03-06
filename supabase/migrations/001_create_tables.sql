-- ============================================================
-- SonMat — Migration 001: Create recipes and steps tables
-- Run in the Supabase SQL Editor (Dashboard → SQL Editor → New query)
-- ============================================================

-- recipes -------------------------------------------------------
CREATE TABLE recipes (
    id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    title         TEXT         NOT NULL,
    description   TEXT         NOT NULL DEFAULT '',
    image_url     TEXT,
    thumbnail_url TEXT,
    category      TEXT         NOT NULL DEFAULT '',
    prep_time     INTEGER      NOT NULL DEFAULT 0,
    cook_time     INTEGER      NOT NULL DEFAULT 0,
    servings      INTEGER      NOT NULL DEFAULT 1,
    ingredients   TEXT[]       NOT NULL DEFAULT '{}',
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- steps ---------------------------------------------------------
CREATE TABLE steps (
    id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_id   UUID         NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    step_number INTEGER      NOT NULL,
    image_url   TEXT,
    instruction TEXT         NOT NULL DEFAULT '',
    UNIQUE (recipe_id, step_number)
);

-- Index for the most common query: fetch all steps for a recipe
CREATE INDEX idx_steps_recipe_id ON steps (recipe_id);

-- Trigger: keep updated_at current on every UPDATE of a recipe row
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_recipes_updated_at
    BEFORE UPDATE ON recipes
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();
