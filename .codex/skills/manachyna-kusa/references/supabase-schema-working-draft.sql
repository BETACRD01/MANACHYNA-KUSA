-- ============================================================
-- MANACHYNA KUSA - SUPABASE DATABASE SCHEMA
-- Working draft only. This schema is expected to evolve.
-- Do not assume it is final or fully authoritative.
-- ============================================================

-- -----------------------------
-- EXTENSIONS
-- -----------------------------
create extension if not exists "pgcrypto";
create extension if not exists "uuid-ossp";

-- -----------------------------
-- ENUMS
-- -----------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'user_role') then
    create type public.user_role as enum ('client', 'provider', 'admin');
  end if;

  if not exists (select 1 from pg_type where typname = 'provider_status') then
    create type public.provider_status as enum ('pending', 'approved', 'rejected', 'suspended');
  end if;

  if not exists (select 1 from pg_type where typname = 'booking_status') then
    create type public.booking_status as enum (
      'pending',
      'confirmed',
      'in_progress',
      'completed',
      'cancelled',
      'rejected'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'payment_status') then
    create type public.payment_status as enum (
      'pending',
      'paid',
      'failed',
      'refunded',
      'cancelled'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'payment_method') then
    create type public.payment_method as enum (
      'cash',
      'transfer',
      'card',
      'online_banking'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'message_type') then
    create type public.message_type as enum (
      'text',
      'image',
      'audio',
      'location',
      'file'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'notification_type') then
    create type public.notification_type as enum (
      'booking',
      'payment',
      'chat',
      'system',
      'review'
    );
  end if;
end $$;

-- -----------------------------
-- HELPERS
-- -----------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- -----------------------------
-- USERS
-- -----------------------------
create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  uid uuid not null unique references auth.users(id) on delete cascade,

  email text not null,
  name text not null default '',
  full_name text,
  phone text default '',
  avatar_url text,

  role public.user_role not null default 'client',
  is_provider boolean not null default false,
  is_active boolean not null default true,

  address text,
  city text default 'Tena',
  province text default 'Napo',
  country text default 'Ecuador',
  latitude double precision,
  longitude double precision,

  fcm_token text,
  device_info jsonb not null default '{}'::jsonb,
  preferences jsonb not null default '{}'::jsonb,
  metadata jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists users_uid_idx on public.users(uid);
create index if not exists users_email_idx on public.users(email);
create index if not exists users_role_idx on public.users(role);
create index if not exists users_is_active_idx on public.users(is_active);

drop trigger if exists set_users_updated_at on public.users;
create trigger set_users_updated_at
before update on public.users
for each row execute function public.set_updated_at();

-- -----------------------------
-- ADMINS
-- -----------------------------
create table if not exists public.admins (
  id uuid primary key default gen_random_uuid(),
  uid uuid not null unique references auth.users(id) on delete cascade,

  email text not null,
  name text not null default '',
  permissions jsonb not null default '{}'::jsonb,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists admins_uid_idx on public.admins(uid);

drop trigger if exists set_admins_updated_at on public.admins;
create trigger set_admins_updated_at
before update on public.admins
for each row execute function public.set_updated_at();

-- -----------------------------
-- SERVICE CATEGORIES
-- -----------------------------
create table if not exists public.service_categories (
  id uuid primary key default gen_random_uuid(),

  name text not null unique,
  slug text not null unique,
  description text,
  icon text,
  color text,
  image_url text,

  sort_order integer not null default 0,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists service_categories_slug_idx on public.service_categories(slug);
create index if not exists service_categories_active_idx on public.service_categories(is_active);

drop trigger if exists set_service_categories_updated_at on public.service_categories;
create trigger set_service_categories_updated_at
before update on public.service_categories
for each row execute function public.set_updated_at();

-- -----------------------------
-- SERVICES
-- -----------------------------
create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),

  category_id uuid references public.service_categories(id) on delete set null,

  name text not null,
  slug text not null unique,
  description text,
  short_description text,
  icon text,
  image_url text,

  base_price numeric(12,2) not null default 0,
  price_unit text not null default 'hour',
  estimated_duration_minutes integer,

  is_active boolean not null default true,
  metadata jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists services_category_id_idx on public.services(category_id);
create index if not exists services_slug_idx on public.services(slug);
create index if not exists services_active_idx on public.services(is_active);

drop trigger if exists set_services_updated_at on public.services;
create trigger set_services_updated_at
before update on public.services
for each row execute function public.set_updated_at();

-- -----------------------------
-- PROVIDERS
-- -----------------------------
create table if not exists public.providers (
  id uuid primary key default gen_random_uuid(),
  uid uuid not null unique references auth.users(id) on delete cascade,

  email text not null,
  name text not null default '',
  full_name text,
  phone text default '',
  avatar_url text,

  bio text,
  status public.provider_status not null default 'pending',
  is_active boolean not null default true,
  is_available boolean not null default true,

  address text,
  city text default 'Tena',
  province text default 'Napo',
  country text default 'Ecuador',
  latitude double precision,
  longitude double precision,

  rating numeric(3,2) not null default 0,
  reviews_count integer not null default 0,
  completed_services_count integer not null default 0,

  hourly_rate numeric(12,2),
  service_radius_km numeric(8,2) default 10,

  documents jsonb not null default '[]'::jsonb,
  availability jsonb not null default '{}'::jsonb,
  metadata jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists providers_uid_idx on public.providers(uid);
create index if not exists providers_status_idx on public.providers(status);
create index if not exists providers_available_idx on public.providers(is_available);
create index if not exists providers_rating_idx on public.providers(rating);

drop trigger if exists set_providers_updated_at on public.providers;
create trigger set_providers_updated_at
before update on public.providers
for each row execute function public.set_updated_at();

-- -----------------------------
-- PROVIDER SERVICES
-- -----------------------------
create table if not exists public.provider_services (
  id uuid primary key default gen_random_uuid(),

  provider_id uuid not null references public.providers(id) on delete cascade,
  service_id uuid not null references public.services(id) on delete cascade,

  price numeric(12,2),
  price_unit text default 'hour',
  description text,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique(provider_id, service_id)
);

create index if not exists provider_services_provider_id_idx on public.provider_services(provider_id);
create index if not exists provider_services_service_id_idx on public.provider_services(service_id);
create index if not exists provider_services_active_idx on public.provider_services(is_active);

drop trigger if exists set_provider_services_updated_at on public.provider_services;
create trigger set_provider_services_updated_at
before update on public.provider_services
for each row execute function public.set_updated_at();

-- -----------------------------
-- BOOKINGS
-- -----------------------------
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),

  client_uid uuid not null references auth.users(id) on delete cascade,
  provider_uid uuid references auth.users(id) on delete set null,

  client_id uuid references public.users(id) on delete set null,
  provider_id uuid references public.providers(id) on delete set null,
  service_id uuid references public.services(id) on delete set null,

  service_name text not null default '',
  provider_name text,
  client_name text,

  status public.booking_status not null default 'pending',

  scheduled_date date,
  scheduled_time time,
  scheduled_at timestamptz,
  duration_quantity integer not null default 1,
  duration_type text not null default 'hours',

  address text,
  city text default 'Tena',
  province text default 'Napo',
  latitude double precision,
  longitude double precision,
  location_notes text,

  notes text,
  cancellation_reason text,
  rejection_reason text,

  subtotal numeric(12,2) not null default 0,
  platform_fee numeric(12,2) not null default 0,
  discount numeric(12,2) not null default 0,
  total_amount numeric(12,2) not null default 0,

  payment_method public.payment_method,
  payment_status public.payment_status not null default 'pending',

  metadata jsonb not null default '{}'::jsonb,

  confirmed_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  cancelled_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists bookings_client_uid_idx on public.bookings(client_uid);
create index if not exists bookings_provider_uid_idx on public.bookings(provider_uid);
create index if not exists bookings_service_id_idx on public.bookings(service_id);
create index if not exists bookings_status_idx on public.bookings(status);
create index if not exists bookings_scheduled_at_idx on public.bookings(scheduled_at);

drop trigger if exists set_bookings_updated_at on public.bookings;
create trigger set_bookings_updated_at
before update on public.bookings
for each row execute function public.set_updated_at();

-- -----------------------------
-- PAYMENTS
-- -----------------------------
create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),

  booking_id uuid not null references public.bookings(id) on delete cascade,
  payer_uid uuid not null references auth.users(id) on delete cascade,
  provider_uid uuid references auth.users(id) on delete set null,

  method public.payment_method not null default 'cash',
  status public.payment_status not null default 'pending',

  amount numeric(12,2) not null default 0,
  currency text not null default 'USD',

  transaction_reference text,
  provider_reference text,
  receipt_url text,

  metadata jsonb not null default '{}'::jsonb,

  paid_at timestamptz,
  failed_at timestamptz,
  refunded_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists payments_booking_id_idx on public.payments(booking_id);
create index if not exists payments_payer_uid_idx on public.payments(payer_uid);
create index if not exists payments_status_idx on public.payments(status);

drop trigger if exists set_payments_updated_at on public.payments;
create trigger set_payments_updated_at
before update on public.payments
for each row execute function public.set_updated_at();

-- -----------------------------
-- REVIEWS
-- -----------------------------
create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),

  booking_id uuid not null unique references public.bookings(id) on delete cascade,
  client_uid uuid not null references auth.users(id) on delete cascade,
  provider_uid uuid not null references auth.users(id) on delete cascade,

  rating integer not null check (rating between 1 and 5),
  comment text,
  provider_reply text,

  is_visible boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists reviews_provider_uid_idx on public.reviews(provider_uid);
create index if not exists reviews_client_uid_idx on public.reviews(client_uid);
create index if not exists reviews_rating_idx on public.reviews(rating);

drop trigger if exists set_reviews_updated_at on public.reviews;
create trigger set_reviews_updated_at
before update on public.reviews
for each row execute function public.set_updated_at();

-- -----------------------------
-- CHATS
-- -----------------------------
create table if not exists public.chats (
  id uuid primary key default gen_random_uuid(),

  participants uuid[] not null default array[]::uuid[],
  booking_id uuid references public.bookings(id) on delete set null,

  last_message text not null default '',
  last_message_time timestamptz not null default now(),
  last_message_sender_id uuid,

  unread_count jsonb not null default '{}'::jsonb,
  "unreadCount" jsonb not null default '{}'::jsonb,

  participant_names jsonb not null default '{}'::jsonb,
  "participantNames" jsonb not null default '{}'::jsonb,

  is_active boolean not null default true,
  is_archived boolean not null default false,
  archived_at timestamptz,

  visible_for uuid[] not null default array[]::uuid[],
  "visibleFor" uuid[] not null default array[]::uuid[],

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists chats_participants_gin_idx on public.chats using gin(participants);
create index if not exists chats_visible_for_gin_idx on public.chats using gin(visible_for);
create index if not exists chats_booking_id_idx on public.chats(booking_id);
create index if not exists chats_last_message_time_idx on public.chats(last_message_time desc);

drop trigger if exists set_chats_updated_at on public.chats;
create trigger set_chats_updated_at
before update on public.chats
for each row execute function public.set_updated_at();

create or replace function public.sync_chat_compat_columns()
returns trigger
language plpgsql
as $$
begin
  if new.unread_count is null then
    new.unread_count = '{}'::jsonb;
  end if;

  if new."unreadCount" is null or new."unreadCount" = '{}'::jsonb then
    new."unreadCount" = new.unread_count;
  end if;

  if new.unread_count = '{}'::jsonb and new."unreadCount" <> '{}'::jsonb then
    new.unread_count = new."unreadCount";
  end if;

  if new.participant_names is null then
    new.participant_names = '{}'::jsonb;
  end if;

  if new."participantNames" is null or new."participantNames" = '{}'::jsonb then
    new."participantNames" = new.participant_names;
  end if;

  if new.participant_names = '{}'::jsonb and new."participantNames" <> '{}'::jsonb then
    new.participant_names = new."participantNames";
  end if;

  if new.visible_for is null then
    new.visible_for = array[]::uuid[];
  end if;

  if new."visibleFor" is null or cardinality(new."visibleFor") = 0 then
    new."visibleFor" = new.visible_for;
  end if;

  if cardinality(new.visible_for) = 0 and cardinality(new."visibleFor") > 0 then
    new.visible_for = new."visibleFor";
  end if;

  return new;
end;
$$;

drop trigger if exists sync_chat_compat_columns_trigger on public.chats;
create trigger sync_chat_compat_columns_trigger
before insert or update on public.chats
for each row execute function public.sync_chat_compat_columns();

-- -----------------------------
-- MESSAGES
-- -----------------------------
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),

  "chatId" uuid not null references public.chats(id) on delete cascade,
  "senderId" uuid not null references auth.users(id) on delete cascade,
  "senderName" text not null default '',

  content text not null default '',
  type public.message_type not null default 'text',
  timestamp timestamptz not null default now(),
  "isRead" boolean not null default false,

  metadata jsonb,

  created_at timestamptz not null default now()
);

create index if not exists messages_chat_id_idx on public.messages("chatId");
create index if not exists messages_sender_id_idx on public.messages("senderId");
create index if not exists messages_timestamp_idx on public.messages(timestamp desc);
create index if not exists messages_type_idx on public.messages(type);

-- -----------------------------
-- USER BLOCKS
-- -----------------------------
create table if not exists public.user_blocks (
  id uuid primary key default gen_random_uuid(),

  blocker_id uuid not null references auth.users(id) on delete cascade,
  blocked_id uuid not null references auth.users(id) on delete cascade,

  created_at timestamptz not null default now(),

  unique(blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);

create index if not exists user_blocks_blocker_idx on public.user_blocks(blocker_id);
create index if not exists user_blocks_blocked_idx on public.user_blocks(blocked_id);

-- -----------------------------
-- NOTIFICATIONS
-- -----------------------------
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),

  user_uid uuid not null references auth.users(id) on delete cascade,
  title text not null,
  body text not null,
  type public.notification_type not null default 'system',

  data jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,

  read_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists notifications_user_uid_idx on public.notifications(user_uid);
create index if not exists notifications_is_read_idx on public.notifications(is_read);
create index if not exists notifications_created_at_idx on public.notifications(created_at desc);

-- -----------------------------
-- STORAGE BUCKETS
-- -----------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'chat-media',
    'chat-media',
    true,
    10485760,
    array[
      'image/jpeg',
      'image/png',
      'image/webp',
      'audio/mpeg',
      'audio/mp4',
      'audio/aac',
      'audio/wav',
      'application/pdf'
    ]
  )
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'profile-images',
    'profile-images',
    true,
    5242880,
    array[
      'image/jpeg',
      'image/png',
      'image/webp'
    ]
  )
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'service-images',
    'service-images',
    true,
    5242880,
    array[
      'image/jpeg',
      'image/png',
      'image/webp'
    ]
  )
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'provider-documents',
    'provider-documents',
    false,
    10485760,
    array[
      'image/jpeg',
      'image/png',
      'image/webp',
      'application/pdf'
    ]
  )
on conflict (id) do nothing;

-- -----------------------------
-- RLS ENABLE
-- -----------------------------
alter table public.users enable row level security;
alter table public.admins enable row level security;
alter table public.service_categories enable row level security;
alter table public.services enable row level security;
alter table public.providers enable row level security;
alter table public.provider_services enable row level security;
alter table public.bookings enable row level security;
alter table public.payments enable row level security;
alter table public.reviews enable row level security;
alter table public.chats enable row level security;
alter table public.messages enable row level security;
alter table public.user_blocks enable row level security;
alter table public.notifications enable row level security;

-- -----------------------------
-- RLS HELPER FUNCTIONS
-- -----------------------------
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admins a
    where a.uid = auth.uid()
      and a.is_active = true
  )
  or exists (
    select 1
    from public.users u
    where u.uid = auth.uid()
      and u.role = 'admin'
      and u.is_active = true
  );
$$;

create or replace function public.is_provider()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.providers p
    where p.uid = auth.uid()
      and p.is_active = true
  );
$$;

-- -----------------------------
-- RLS POLICIES: USERS
-- -----------------------------
drop policy if exists "users_select_own_or_admin" on public.users;
create policy "users_select_own_or_admin"
on public.users
for select
to authenticated
using (uid = auth.uid() or public.is_admin());

drop policy if exists "users_insert_own" on public.users;
create policy "users_insert_own"
on public.users
for insert
to authenticated
with check (uid = auth.uid());

drop policy if exists "users_update_own_or_admin" on public.users;
create policy "users_update_own_or_admin"
on public.users
for update
to authenticated
using (uid = auth.uid() or public.is_admin())
with check (uid = auth.uid() or public.is_admin());

-- -----------------------------
-- RLS POLICIES: ADMINS
-- -----------------------------
drop policy if exists "admins_select_admins" on public.admins;
create policy "admins_select_admins"
on public.admins
for select
to authenticated
using (public.is_admin());

drop policy if exists "admins_manage_admins" on public.admins;
create policy "admins_manage_admins"
on public.admins
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- -----------------------------
-- RLS POLICIES: CATEGORIES / SERVICES
-- -----------------------------
drop policy if exists "categories_public_read" on public.service_categories;
create policy "categories_public_read"
on public.service_categories
for select
to authenticated
using (is_active = true or public.is_admin());

drop policy if exists "categories_admin_manage" on public.service_categories;
create policy "categories_admin_manage"
on public.service_categories
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "services_public_read" on public.services;
create policy "services_public_read"
on public.services
for select
to authenticated
using (is_active = true or public.is_admin());

drop policy if exists "services_admin_manage" on public.services;
create policy "services_admin_manage"
on public.services
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- -----------------------------
-- RLS POLICIES: PROVIDERS
-- -----------------------------
drop policy if exists "providers_public_read" on public.providers;
create policy "providers_public_read"
on public.providers
for select
to authenticated
using (is_active = true or uid = auth.uid() or public.is_admin());

drop policy if exists "providers_insert_own" on public.providers;
create policy "providers_insert_own"
on public.providers
for insert
to authenticated
with check (uid = auth.uid() or public.is_admin());

drop policy if exists "providers_update_own_or_admin" on public.providers;
create policy "providers_update_own_or_admin"
on public.providers
for update
to authenticated
using (uid = auth.uid() or public.is_admin())
with check (uid = auth.uid() or public.is_admin());

drop policy if exists "provider_services_public_read" on public.provider_services;
create policy "provider_services_public_read"
on public.provider_services
for select
to authenticated
using (is_active = true or public.is_admin());

drop policy if exists "provider_services_provider_manage" on public.provider_services;
create policy "provider_services_provider_manage"
on public.provider_services
for all
to authenticated
using (
  public.is_admin()
  or exists (
    select 1 from public.providers p
    where p.id = provider_services.provider_id
      and p.uid = auth.uid()
  )
)
with check (
  public.is_admin()
  or exists (
    select 1 from public.providers p
    where p.id = provider_services.provider_id
      and p.uid = auth.uid()
  )
);

-- -----------------------------
-- RLS POLICIES: BOOKINGS
-- -----------------------------
drop policy if exists "bookings_select_participants_or_admin" on public.bookings;
create policy "bookings_select_participants_or_admin"
on public.bookings
for select
to authenticated
using (
  client_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
);

drop policy if exists "bookings_insert_client" on public.bookings;
create policy "bookings_insert_client"
on public.bookings
for insert
to authenticated
with check (client_uid = auth.uid() or public.is_admin());

drop policy if exists "bookings_update_participants_or_admin" on public.bookings;
create policy "bookings_update_participants_or_admin"
on public.bookings
for update
to authenticated
using (
  client_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
)
with check (
  client_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
);

-- -----------------------------
-- RLS POLICIES: PAYMENTS
-- -----------------------------
drop policy if exists "payments_select_participants_or_admin" on public.payments;
create policy "payments_select_participants_or_admin"
on public.payments
for select
to authenticated
using (
  payer_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
);

drop policy if exists "payments_insert_payer" on public.payments;
create policy "payments_insert_payer"
on public.payments
for insert
to authenticated
with check (payer_uid = auth.uid() or public.is_admin());

drop policy if exists "payments_update_admin" on public.payments;
create policy "payments_update_admin"
on public.payments
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- -----------------------------
-- RLS POLICIES: REVIEWS
-- -----------------------------
drop policy if exists "reviews_select_visible" on public.reviews;
create policy "reviews_select_visible"
on public.reviews
for select
to authenticated
using (
  is_visible = true
  or client_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
);

drop policy if exists "reviews_insert_client" on public.reviews;
create policy "reviews_insert_client"
on public.reviews
for insert
to authenticated
with check (client_uid = auth.uid() or public.is_admin());

drop policy if exists "reviews_update_owner_provider_or_admin" on public.reviews;
create policy "reviews_update_owner_provider_or_admin"
on public.reviews
for update
to authenticated
using (
  client_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
)
with check (
  client_uid = auth.uid()
  or provider_uid = auth.uid()
  or public.is_admin()
);

-- -----------------------------
-- RLS POLICIES: CHATS
-- -----------------------------
drop policy if exists "chats_select_participants" on public.chats;
create policy "chats_select_participants"
on public.chats
for select
to authenticated
using (
  auth.uid() = any(participants)
  or public.is_admin()
);

drop policy if exists "chats_insert_participants" on public.chats;
create policy "chats_insert_participants"
on public.chats
for insert
to authenticated
with check (
  auth.uid() = any(participants)
  or public.is_admin()
);

drop policy if exists "chats_update_participants" on public.chats;
create policy "chats_update_participants"
on public.chats
for update
to authenticated
using (
  auth.uid() = any(participants)
  or public.is_admin()
)
with check (
  auth.uid() = any(participants)
  or public.is_admin()
);

drop policy if exists "chats_delete_participants" on public.chats;
create policy "chats_delete_participants"
on public.chats
for delete
to authenticated
using (
  auth.uid() = any(participants)
  or public.is_admin()
);

-- -----------------------------
-- RLS POLICIES: MESSAGES
-- -----------------------------
drop policy if exists "messages_select_chat_participants" on public.messages;
create policy "messages_select_chat_participants"
on public.messages
for select
to authenticated
using (
  exists (
    select 1 from public.chats c
    where c.id = messages."chatId"
      and auth.uid() = any(c.participants)
  )
  or public.is_admin()
);

drop policy if exists "messages_insert_chat_participants" on public.messages;
create policy "messages_insert_chat_participants"
on public.messages
for insert
to authenticated
with check (
  "senderId" = auth.uid()
  and exists (
    select 1 from public.chats c
    where c.id = messages."chatId"
      and auth.uid() = any(c.participants)
  )
);

drop policy if exists "messages_delete_sender_or_admin" on public.messages;
create policy "messages_delete_sender_or_admin"
on public.messages
for delete
to authenticated
using (
  "senderId" = auth.uid()
  or public.is_admin()
);

-- -----------------------------
-- RLS POLICIES: USER BLOCKS
-- -----------------------------
drop policy if exists "blocks_select_own" on public.user_blocks;
create policy "blocks_select_own"
on public.user_blocks
for select
to authenticated
using (blocker_id = auth.uid() or public.is_admin());

drop policy if exists "blocks_insert_own" on public.user_blocks;
create policy "blocks_insert_own"
on public.user_blocks
for insert
to authenticated
with check (blocker_id = auth.uid());

drop policy if exists "blocks_delete_own" on public.user_blocks;
create policy "blocks_delete_own"
on public.user_blocks
for delete
to authenticated
using (blocker_id = auth.uid() or public.is_admin());

-- -----------------------------
-- RLS POLICIES: NOTIFICATIONS
-- -----------------------------
drop policy if exists "notifications_select_own" on public.notifications;
create policy "notifications_select_own"
on public.notifications
for select
to authenticated
using (user_uid = auth.uid() or public.is_admin());

drop policy if exists "notifications_update_own" on public.notifications;
create policy "notifications_update_own"
on public.notifications
for update
to authenticated
using (user_uid = auth.uid() or public.is_admin())
with check (user_uid = auth.uid() or public.is_admin());

drop policy if exists "notifications_admin_insert" on public.notifications;
create policy "notifications_admin_insert"
on public.notifications
for insert
to authenticated
with check (public.is_admin());

-- -----------------------------
-- STORAGE POLICIES
-- -----------------------------
drop policy if exists "chat_media_read_participants" on storage.objects;
create policy "chat_media_read_participants"
on storage.objects
for select
to authenticated
using (bucket_id = 'chat-media');

drop policy if exists "chat_media_upload_authenticated" on storage.objects;
create policy "chat_media_upload_authenticated"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'chat-media');

drop policy if exists "chat_media_delete_owner_or_admin" on storage.objects;
create policy "chat_media_delete_owner_or_admin"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'chat-media'
  and (
    owner = auth.uid()
    or public.is_admin()
  )
);

drop policy if exists "profile_images_public_read" on storage.objects;
create policy "profile_images_public_read"
on storage.objects
for select
to authenticated
using (bucket_id = 'profile-images');

drop policy if exists "profile_images_upload_authenticated" on storage.objects;
create policy "profile_images_upload_authenticated"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'profile-images');

drop policy if exists "service_images_public_read" on storage.objects;
create policy "service_images_public_read"
on storage.objects
for select
to authenticated
using (bucket_id = 'service-images');

drop policy if exists "service_images_admin_upload" on storage.objects;
create policy "service_images_admin_upload"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'service-images'
  and public.is_admin()
);

drop policy if exists "provider_documents_provider_read" on storage.objects;
create policy "provider_documents_provider_read"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'provider-documents'
  and (
    owner = auth.uid()
    or public.is_admin()
  )
);

drop policy if exists "provider_documents_provider_upload" on storage.objects;
create policy "provider_documents_provider_upload"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'provider-documents'
);

-- -----------------------------
-- SEED DATA
-- -----------------------------
insert into public.service_categories (name, slug, description, icon, color, sort_order)
values
  ('Limpieza', 'limpieza', 'Servicios de limpieza para hogares y oficinas', 'cleaning', '#1B7F5A', 1),
  ('Plomería', 'plomeria', 'Reparación e instalación de tuberías y grifería', 'plumbing', '#2563EB', 2),
  ('Electricidad', 'electricidad', 'Instalaciones y reparaciones eléctricas', 'electrical', '#F59E0B', 3),
  ('Pintura', 'pintura', 'Pintura interior y exterior', 'painting', '#8B5CF6', 4),
  ('Mantenimiento', 'mantenimiento', 'Mantenimiento general del hogar', 'maintenance', '#64748B', 5),
  ('Agronomía', 'agronomia', 'Servicios agrícolas y asesoría técnica', 'agronomy', '#16A34A', 6),
  ('Tecnología', 'tecnologia', 'Soporte técnico, redes y equipos', 'technology', '#0EA5E9', 7),
  ('Marketing', 'marketing', 'Publicidad digital para negocios locales', 'marketing', '#EC4899', 8)
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  icon = excluded.icon,
  color = excluded.color,
  sort_order = excluded.sort_order,
  updated_at = now();

insert into public.services (category_id, name, slug, description, short_description, icon, base_price, price_unit, estimated_duration_minutes)
select c.id, s.name, s.slug, s.description, s.short_description, s.icon, s.base_price, s.price_unit, s.estimated_duration_minutes
from (
  values
    ('limpieza', 'Limpieza del hogar', 'limpieza-hogar', 'Limpieza general para casas, departamentos y oficinas.', 'Casas y oficinas', 'cleaning', 15.00, 'hour', 180),
    ('plomeria', 'Plomería básica', 'plomeria-basica', 'Reparación de fugas, grifos, baños y tuberías.', 'Fugas e instalación', 'plumbing', 18.00, 'hour', 120),
    ('electricidad', 'Servicio eléctrico', 'servicio-electrico', 'Revisión, reparación e instalación eléctrica.', 'Revisión segura', 'electrical', 20.00, 'hour', 120),
    ('pintura', 'Pintura interior', 'pintura-interior', 'Pintura de habitaciones, oficinas y espacios interiores.', 'Paredes y acabados', 'painting', 25.00, 'hour', 240),
    ('mantenimiento', 'Mantenimiento general', 'mantenimiento-general', 'Reparaciones menores y mantenimiento de vivienda.', 'Reparaciones menores', 'maintenance', 20.00, 'hour', 180),
    ('agronomia', 'Asesoría agronómica', 'asesoria-agronomica', 'Asistencia técnica para cultivos y producción agrícola.', 'Asesoría local', 'agronomy', 25.00, 'hour', 120),
    ('tecnologia', 'Soporte técnico', 'soporte-tecnico', 'Soporte para computadores, redes, impresoras y equipos.', 'Redes y equipos', 'technology', 22.00, 'hour', 120),
    ('marketing', 'Publicidad digital', 'publicidad-digital', 'Servicios de marketing digital para negocios locales.', 'Negocios locales', 'marketing', 30.00, 'hour', 180)
) as s(category_slug, name, slug, description, short_description, icon, base_price, price_unit, estimated_duration_minutes)
join public.service_categories c on c.slug = s.category_slug
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  short_description = excluded.short_description,
  icon = excluded.icon,
  base_price = excluded.base_price,
  price_unit = excluded.price_unit,
  estimated_duration_minutes = excluded.estimated_duration_minutes,
  updated_at = now();
