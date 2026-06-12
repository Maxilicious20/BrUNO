BrUNO — Local setup and Supabase migration

What changed
- Replaced Firebase with Supabase for realtime lobby management.
- Added `supabase-config.js` (dev) and `supabase-init.sql` migration for the `lobbies` table.

Quick start (local)
1. Fill `supabase-config.js` with your Supabase project values (supabaseUrl and supabaseAnonKey).
2. Create the `lobbies` table in your Supabase project using `supabase-init.sql` (SQL Editor -> New Query -> Run).
3. Serve the project locally:

```bash
npx http-server -c-1 -p 8080
# or
python -m http.server 8080
```
Open http://localhost:8080

Notes
- The project uses a simple local identity stored in `localStorage` (key: `bruno_user_id`) as an app-level UID. This avoids needing server-side auth for anonymous play.
- The Supabase table `lobbies` must allow the `upsert` operation (primary key on `lobbyId` recommended).
- If you deploy to a static host, inject `window.__supabase_config` before the module script instead of committing keys.

Files added/changed
- `supabase-config.js` — runtime config (dev)
- `supabase-init.sql` — SQL migration for `lobbies` table
- `index.html` — migrated to Supabase client and wrappers

If you want, I can:
- Generate the exact `psql` command to run the SQL locally, or
- Create a Git-ignored `env` loader for production injection, or
- Harden the realtime subscriptions to only listen for specific events.
