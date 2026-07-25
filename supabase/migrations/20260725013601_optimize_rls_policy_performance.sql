begin;

-- Avoid per-row init plans in RLS by evaluating auth.uid() once per statement.

alter policy users_insert_own on public.users
  with check (uid = (select auth.uid()));

alter policy users_select_own_or_admin on public.users
  using ((uid = (select auth.uid())) or is_admin());

alter policy users_update_own_or_admin on public.users
  using ((uid = (select auth.uid())) or is_admin())
  with check ((uid = (select auth.uid())) or is_admin());

alter policy providers_insert_own on public.providers
  with check ((uid = (select auth.uid())) or is_admin());

alter policy providers_public_read on public.providers
  using ((is_active = true) or (uid = (select auth.uid())) or is_admin());

alter policy providers_update_own_or_admin on public.providers
  using ((uid = (select auth.uid())) or is_admin())
  with check ((uid = (select auth.uid())) or is_admin());

alter policy bookings_insert_client on public.bookings
  with check ((client_uid = (select auth.uid())) or is_admin());

alter policy bookings_select_participants_or_admin on public.bookings
  using (
    (client_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  );

alter policy bookings_update_participants_or_admin on public.bookings
  using (
    (client_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  )
  with check (
    (client_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  );

alter policy notifications_select_own on public.notifications
  using ((user_uid = (select auth.uid())) or is_admin());

alter policy notifications_update_own on public.notifications
  using ((user_uid = (select auth.uid())) or is_admin())
  with check ((user_uid = (select auth.uid())) or is_admin());

alter policy payments_insert_payer on public.payments
  with check ((payer_uid = (select auth.uid())) or is_admin());

alter policy payments_select_participants_or_admin on public.payments
  using (
    (payer_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  );

alter policy reviews_insert_client on public.reviews
  with check ((client_uid = (select auth.uid())) or is_admin());

alter policy reviews_select_visible on public.reviews
  using (
    (is_visible = true)
    or (client_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  );

alter policy reviews_update_owner_provider_or_admin on public.reviews
  using (
    (client_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  )
  with check (
    (client_uid = (select auth.uid()))
    or (provider_uid = (select auth.uid()))
    or is_admin()
  );

alter policy chats_delete_participants on public.chats
  using (((select auth.uid()) = any (participants)) or is_admin());

alter policy chats_insert_participants on public.chats
  with check (((select auth.uid()) = any (participants)) or is_admin());

alter policy chats_select_participants on public.chats
  using (((select auth.uid()) = any (participants)) or is_admin());

alter policy chats_update_participants on public.chats
  using (((select auth.uid()) = any (participants)) or is_admin())
  with check (((select auth.uid()) = any (participants)) or is_admin());

alter policy messages_delete_sender_or_admin on public.messages
  using (("senderId" = (select auth.uid())) or is_admin());

alter policy messages_insert_chat_participants on public.messages
  with check (
    ("senderId" = (select auth.uid()))
    and exists (
      select 1
      from public.chats c
      where c.id = messages."chatId"
        and (select auth.uid()) = any (c.participants)
    )
  );

alter policy messages_select_chat_participants on public.messages
  using (
    exists (
      select 1
      from public.chats c
      where c.id = messages."chatId"
        and (select auth.uid()) = any (c.participants)
    )
    or is_admin()
  );

alter policy blocks_delete_own on public.user_blocks
  using ((blocker_id = (select auth.uid())) or is_admin());

alter policy blocks_insert_own on public.user_blocks
  with check (blocker_id = (select auth.uid()));

alter policy blocks_select_own on public.user_blocks
  using ((blocker_id = (select auth.uid())) or is_admin());

-- Remove duplicate SELECT policies by splitting broad ALL policies into
-- non-SELECT policies while preserving the same non-read permissions.

drop policy if exists admins_manage_admins on public.admins;
drop policy if exists admins_insert_admins on public.admins;
drop policy if exists admins_update_admins on public.admins;
drop policy if exists admins_delete_admins on public.admins;

create policy admins_insert_admins on public.admins
  for insert to authenticated
  with check (is_admin());

create policy admins_update_admins on public.admins
  for update to authenticated
  using (is_admin())
  with check (is_admin());

create policy admins_delete_admins on public.admins
  for delete to authenticated
  using (is_admin());

alter policy provider_services_public_read on public.provider_services
  using (
    (is_active = true)
    or is_admin()
    or exists (
      select 1
      from public.providers p
      where p.id = provider_services.provider_id
        and p.uid = (select auth.uid())
    )
  );

drop policy if exists provider_services_provider_manage on public.provider_services;
drop policy if exists provider_services_insert_provider on public.provider_services;
drop policy if exists provider_services_update_provider on public.provider_services;
drop policy if exists provider_services_delete_provider on public.provider_services;

create policy provider_services_insert_provider on public.provider_services
  for insert to authenticated
  with check (
    is_admin()
    or exists (
      select 1
      from public.providers p
      where p.id = provider_services.provider_id
        and p.uid = (select auth.uid())
    )
  );

create policy provider_services_update_provider on public.provider_services
  for update to authenticated
  using (
    is_admin()
    or exists (
      select 1
      from public.providers p
      where p.id = provider_services.provider_id
        and p.uid = (select auth.uid())
    )
  )
  with check (
    is_admin()
    or exists (
      select 1
      from public.providers p
      where p.id = provider_services.provider_id
        and p.uid = (select auth.uid())
    )
  );

create policy provider_services_delete_provider on public.provider_services
  for delete to authenticated
  using (
    is_admin()
    or exists (
      select 1
      from public.providers p
      where p.id = provider_services.provider_id
        and p.uid = (select auth.uid())
    )
  );

drop policy if exists categories_admin_manage on public.service_categories;
drop policy if exists categories_insert_admin on public.service_categories;
drop policy if exists categories_update_admin on public.service_categories;
drop policy if exists categories_delete_admin on public.service_categories;

create policy categories_insert_admin on public.service_categories
  for insert to authenticated
  with check (is_admin());

create policy categories_update_admin on public.service_categories
  for update to authenticated
  using (is_admin())
  with check (is_admin());

create policy categories_delete_admin on public.service_categories
  for delete to authenticated
  using (is_admin());

drop policy if exists services_admin_manage on public.services;
drop policy if exists services_insert_admin on public.services;
drop policy if exists services_update_admin on public.services;
drop policy if exists services_delete_admin on public.services;

create policy services_insert_admin on public.services
  for insert to authenticated
  with check (is_admin());

create policy services_update_admin on public.services
  for update to authenticated
  using (is_admin())
  with check (is_admin());

create policy services_delete_admin on public.services
  for delete to authenticated
  using (is_admin());

commit;
