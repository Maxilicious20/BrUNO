-- supabase-init.sql
-- Creates a `lobbies` table for BrUNO and a trigger to maintain updated_at.

BEGIN;

-- Create lobbies table (exact camelCase column names quoted for Supabase/PostgREST compatibility)
CREATE TABLE IF NOT EXISTS public.lobbies (
  "lobbyId" text PRIMARY KEY,
  "hostId" text NOT NULL,
  "status" text NOT NULL DEFAULT 'waiting',
  "players" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "deck" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "discardPile" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "activeColor" text DEFAULT 'Rot',
  "activeValue" text DEFAULT '',
  "currentPlayerIndex" integer DEFAULT 0,
  "playDirection" integer DEFAULT 1,
  "accumulatedDraws" integer DEFAULT 0,
  "hasDrawnThisTurn" boolean DEFAULT false,
  "winners" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "chat" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "gameLogs" jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Index for quick lookups by hostId
CREATE INDEX IF NOT EXISTS idx_lobbies_hostId ON public.lobbies ("hostId");

-- Trigger function to auto-update updated_at
CREATE OR REPLACE FUNCTION public.trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger to lobbies
DROP TRIGGER IF EXISTS set_timestamp ON public.lobbies;
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public.lobbies
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

COMMIT;

-- OPTIONAL: example insert (uncomment to test)
-- INSERT INTO public.lobbies (lobbyId, hostId, players, gameLogs)
-- VALUES ('AB12', 'u_examplehost', '[{"id":"u_examplehost","name":"Host","cards":[],"isReady":true}]', '["Lobby wurde erstellt"]');
