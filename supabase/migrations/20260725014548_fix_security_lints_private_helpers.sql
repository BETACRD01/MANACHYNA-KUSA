begin;

-- Fix mutable search_path warnings on trigger functions.
alter function public.set_updated_at()
  set search_path = pg_catalog, public;

alter function public.sync_chat_compat_columns()
  set search_path = pg_catalog, public;

-- Move SECURITY DEFINER authorization helpers out of the exposed public API
-- schema. RLS policies call private.* helpers, while public RPC execution is
-- revoked from anon/authenticated users.
create schema if not exists private;

revoke all on schema private from public;
grant usage on schema private to authenticated, service_role;

create or replace function private.is_admin()
returns boolean
language sql
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.admins a
    where a.uid = (select auth.uid())
      and a.is_active = true
  )
  or exists (
    select 1
    from public.users u
    where u.uid = (select auth.uid())
      and u.role = 'admin'
      and u.is_active = true
  );
$$;

create or replace function private.is_provider()
returns boolean
language sql
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.providers p
    where p.uid = (select auth.uid())
      and p.is_active = true
  );
$$;

revoke all on function private.is_admin() from public;
revoke all on function private.is_provider() from public;
grant execute on function private.is_admin() to authenticated, service_role;
grant execute on function private.is_provider() to authenticated, service_role;

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
    using_expr := replace(replace(policy_row.qual, 'is_admin()', 'private.is_admin()'), 'is_provider()', 'private.is_provider()');
    check_expr := replace(replace(policy_row.with_check, 'is_admin()', 'private.is_admin()'), 'is_provider()', 'private.is_provider()');

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

revoke all on function public.is_admin() from public;
revoke all on function public.is_admin() from anon;
revoke all on function public.is_admin() from authenticated;

revoke all on function public.is_provider() from public;
revoke all on function public.is_provider() from anon;
revoke all on function public.is_provider() from authenticated;

revoke all on function public.rls_auto_enable() from public;
revoke all on function public.rls_auto_enable() from anon;
revoke all on function public.rls_auto_enable() from authenticated;

-- Public buckets can serve objects by public URL without broad SELECT policies
-- that allow listing every object in the bucket.
drop policy if exists chat_media_read_participants on storage.objects;
drop policy if exists service_images_public_read on storage.objects;

drop policy if exists profile_images_public_read on storage.objects;
create policy profile_images_public_read on storage.objects
  for select to authenticated
  using (
    bucket_id = 'profile-images'
    and (
      (storage.foldername(name))[1] = (select auth.uid())::text
      or private.is_admin()
    )
  );

alter policy chat_media_delete_owner_or_admin on storage.objects
  using (
    bucket_id = 'chat-media'
    and (
      owner = (select auth.uid())
      or private.is_admin()
    )
  );

alter policy provider_documents_provider_read on storage.objects
  using (
    bucket_id = 'provider-documents'
    and (
      owner = (select auth.uid())
      or private.is_admin()
    )
  );

commit;
