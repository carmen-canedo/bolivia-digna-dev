-- Security Audit: Status of RLS and Table Permissions
-- This is read-only, won't modify anything in the database
-- Meant to identify which public tables without RLS and what privileges anon and authorized users have

-- Baseline on 2026-10-21:

SELECT
    t.tablename,
    t.rowsecurity as rls_enabled,
    has_table_privilege('anon', format('%I.%I', t.schemaname, t.tablename), 'SELECT') as anon_select,
    has_table_privilege('anon', format('%I.%I', t.schemaname, t.tablename), 'INSERT') as anon_insert,
    has_table_privilege('anon', format('%I.%I', t.schemaname, t.tablename), 'UPDATE') as anon_update,
    has_table_privilege('anon', format('%I.%I', t.schemaname, t.tablename), 'DELETE') as anon_delete,
    has_table_privilege('authenticated', format('%I.%I', t.schemaname, t.tablename), 'SELECT') as authenticated_select
FROM pg_tables t
WHERE t.schemaname = 'public'
ORDER BY t.tablename;
