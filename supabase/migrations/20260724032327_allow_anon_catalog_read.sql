do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'services'
      and policyname = 'services_anon_read_active'
  ) then
    create policy "services_anon_read_active"
    on public.services
    for select
    to anon
    using (is_active = true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'service_categories'
      and policyname = 'service_categories_anon_read_active'
  ) then
    create policy "service_categories_anon_read_active"
    on public.service_categories
    for select
    to anon
    using (is_active = true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'providers'
      and policyname = 'providers_anon_read_active'
  ) then
    create policy "providers_anon_read_active"
    on public.providers
    for select
    to anon
    using (is_active = true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'provider_services'
      and policyname = 'provider_services_anon_read_active'
  ) then
    create policy "provider_services_anon_read_active"
    on public.provider_services
    for select
    to anon
    using (
      is_active = true
      and exists (
        select 1
        from public.providers p
        where p.id = provider_services.provider_id
          and p.is_active = true
      )
      and exists (
        select 1
        from public.services s
        where s.id = provider_services.service_id
          and s.is_active = true
      )
    );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'reviews'
      and policyname = 'reviews_anon_read_visible'
  ) then
    create policy "reviews_anon_read_visible"
    on public.reviews
    for select
    to anon
    using (is_visible = true);
  end if;
end $$;
