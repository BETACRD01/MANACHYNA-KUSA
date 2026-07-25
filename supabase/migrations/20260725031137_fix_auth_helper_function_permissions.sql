begin;

-- The mobile app reads public tables through PostgREST. Some RLS policies call
-- the private authorization helpers, so authenticated users need schema usage
-- and execute permission on those helper functions.
create schema if not exists private;

grant usage on schema private to authenticated, service_role;

grant execute on function private.is_admin() to authenticated, service_role;
grant execute on function private.is_provider() to authenticated, service_role;

-- Older policies may still reference public.is_admin()/public.is_provider()
-- after the helpers were moved to the private schema. Rewrite any remaining
-- policy expression so authentication reads do not hit revoked public helpers.
do $$
declare
  policy_row record;
  using_expr text;
  check_expr text;
  sql text;
begin
  for policy_row in
    select schemaname, tablename, policyname, qual, with_check
    from pg_policies
    where schemaname in ('public', 'storage')
      and (
        qual like '%is_admin()%'
        or with_check like '%is_admin()%'
        or qual like '%is_provider()%'
        or with_check like '%is_provider()%'
      )
  loop
    using_expr := replace(
      replace(
        replace(
          replace(policy_row.qual, 'private.is_admin()', '__private_is_admin__'),
          'private.is_provider()',
          '__private_is_provider__'
        ),
        'is_admin()',
        'private.is_admin()'
      ),
      'is_provider()',
      'private.is_provider()'
    );
    using_expr := replace(
      replace(using_expr, '__private_is_admin__', 'private.is_admin()'),
      '__private_is_provider__',
      'private.is_provider()'
    );

    check_expr := replace(
      replace(
        replace(
          replace(policy_row.with_check, 'private.is_admin()', '__private_is_admin__'),
          'private.is_provider()',
          '__private_is_provider__'
        ),
        'is_admin()',
        'private.is_admin()'
      ),
      'is_provider()',
      'private.is_provider()'
    );
    check_expr := replace(
      replace(check_expr, '__private_is_admin__', 'private.is_admin()'),
      '__private_is_provider__',
      'private.is_provider()'
    );

    sql := format(
      'alter policy %I on %I.%I',
      policy_row.policyname,
      policy_row.schemaname,
      policy_row.tablename
    );

    if using_expr is not null then
      sql := sql || format(' using (%s)', using_expr);
    end if;

    if check_expr is not null then
      sql := sql || format(' with check (%s)', check_expr);
    end if;

    execute sql;
  end loop;
end;
$$;

commit;
