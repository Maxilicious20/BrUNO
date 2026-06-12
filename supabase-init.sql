-- supabase-init.sql
-- Creates a `lobbies` table for BrUNO and a trigger to maintain updated_at.

BEGIN;

-- Rename any existing lowercase columns to camelCase if the table was created without quoted identifiers.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'hostid'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'hostId'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN hostid TO "hostId"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'lobbyid'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'lobbyId'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN lobbyid TO "lobbyId"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'discardpile'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'discardPile'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN discardpile TO "discardPile"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'activecolor'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'activeColor'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN activecolor TO "activeColor"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'activevalue'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'activeValue'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN activevalue TO "activeValue"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'currentplayerindex'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'currentPlayerIndex'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN currentplayerindex TO "currentPlayerIndex"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'playdirection'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'playDirection'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN playdirection TO "playDirection"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'accumulateddraws'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'accumulatedDraws'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN accumulateddraws TO "accumulatedDraws"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'hasdrawnthisturn'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'hasDrawnThisTurn'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN hasdrawnthisturn TO "hasDrawnThisTurn"';
  END IF;
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'gamelogs'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'lobbies' AND column_name = 'gameLogs'
  ) THEN
    EXECUTE 'ALTER TABLE public.lobbies RENAME COLUMN gamelogs TO "gameLogs"';
  END IF;
END;
$$;

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
