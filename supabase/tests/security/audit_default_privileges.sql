-- Security Audit: Verify new tables and sequences created by the postgres role in the public schema 
-- don't automatically grant privileges to anon or authenticated.

-- Read only; won't affect db permissions

-- Expected output = 0
-- Any returned rows indicate explicit default privileges that should be reviewed
SELECT
    CASE d.defaclobjtype
        WHEN 'r' THEN 'table'
        WHEN 'S' THEN 'sequence'
    END AS object_type,
    r.rolname AS grantee,
    e.privilege_type
FROM pg_default_acl d
JOIN pg_namespace n
    ON n.oid = d.defaclnamespace
CROSS JOIN LATERAL aclexplode(d.defaclacl) e
JOIN pg_roles r
    ON r.oid = e.grantee
WHERE pg_get_userbyid(d.defaclrole) = 'postgres'
    AND n.nspname = 'public'
    AND d.defaclobjtype IN ('r', 'S')
    AND r.rolname IN ('anon', 'authenticated')
ORDER BY object_type, grantee, privilege_type;