# Live Supabase Schema Snapshot

Snapshot seguro tomado el 2026-05-20 desde Supabase MCP.

No incluye datos privados. Solo contiene estructura, RLS, índices, buckets,
funciones, triggers y conteos aproximados reportados por Supabase.

## Project

- Name: `Mañachiy kan Kusata`
- Ref: `ikdcqxgecjzgjntejizu`
- Public URL: `https://ikdcqxgecjzgjntejizu.supabase.co`
- Region: `us-east-2`
- Status: `ACTIVE_HEALTHY`
- Postgres: `17.6.1.121`

## Tables

All public tables have RLS enabled.

| Table | Rows | Primary key | Notes |
| --- | ---: | --- | --- |
| `public.admins` | 0 | `id` | Admin profile records linked to `auth.users`. |
| `public.bookings` | 0 | `id` | Booking lifecycle, payment status, location and scheduling fields. |
| `public.chats` | 0 | `id` | Chat headers with compatibility camelCase/snake_case columns. |
| `public.messages` | 0 | `id` | Chat messages linked to `chats` and `auth.users`. |
| `public.notifications` | 0 | `id` | User notifications. |
| `public.payments` | 0 | `id` | Payment records linked to bookings. |
| `public.provider_services` | 0 | `id` | Provider to service join table. |
| `public.providers` | 0 | `id` | Provider profiles linked to `auth.users`. |
| `public.reviews` | 0 | `id` | One review per booking. |
| `public.service_categories` | 8 | `id` | Public catalog categories. |
| `public.services` | 8 | `id` | Public catalog services. |
| `public.user_blocks` | 0 | `id` | User block relationships. |
| `public.users` | 2 | `id` | Client/user profiles linked to `auth.users`; includes `fcm_token`. |

## Enums

```sql
booking_status = ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'rejected')
message_type = ('text', 'image', 'audio', 'location', 'file')
notification_type = ('booking', 'payment', 'chat', 'system', 'review')
payment_method = ('cash', 'transfer', 'card', 'online_banking')
payment_status = ('pending', 'paid', 'failed', 'refunded', 'cancelled')
provider_status = ('pending', 'approved', 'rejected', 'suspended')
user_role = ('client', 'provider', 'admin')
```

## Core Columns

### `public.users`

- `id uuid primary key default gen_random_uuid()`
- `uid uuid unique references auth.users(id)`
- `email text`
- `name text default ''`
- `full_name text null`
- `phone text null default ''`
- `avatar_url text null`
- `role user_role default 'client'`
- `is_provider boolean default false`
- `is_active boolean default true`
- `address text null`
- `city text null default 'Tena'`
- `province text null default 'Napo'`
- `country text null default 'Ecuador'`
- `latitude double precision null`
- `longitude double precision null`
- `fcm_token text null`
- `device_info jsonb default '{}'`
- `preferences jsonb default '{}'`
- `metadata jsonb default '{}'`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.admins`

- `id uuid primary key default gen_random_uuid()`
- `uid uuid unique references auth.users(id)`
- `email text`
- `name text default ''`
- `permissions jsonb default '{}'`
- `is_active boolean default true`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.service_categories`

- `id uuid primary key default gen_random_uuid()`
- `name text unique`
- `slug text unique`
- `description text null`
- `icon text null`
- `color text null`
- `image_url text null`
- `sort_order integer default 0`
- `is_active boolean default true`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.services`

- `id uuid primary key default gen_random_uuid()`
- `category_id uuid null references public.service_categories(id)`
- `name text`
- `slug text unique`
- `description text null`
- `short_description text null`
- `icon text null`
- `image_url text null`
- `base_price numeric default 0`
- `price_unit text default 'hour'`
- `estimated_duration_minutes integer null`
- `is_active boolean default true`
- `metadata jsonb default '{}'`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.providers`

- `id uuid primary key default gen_random_uuid()`
- `uid uuid unique references auth.users(id)`
- `email text`
- `name text default ''`
- `full_name text null`
- `phone text null default ''`
- `avatar_url text null`
- `bio text null`
- `status provider_status default 'pending'`
- `is_active boolean default true`
- `is_available boolean default true`
- `address text null`
- `city text null default 'Tena'`
- `province text null default 'Napo'`
- `country text null default 'Ecuador'`
- `latitude double precision null`
- `longitude double precision null`
- `rating numeric default 0`
- `reviews_count integer default 0`
- `completed_services_count integer default 0`
- `hourly_rate numeric null`
- `service_radius_km numeric null default 10`
- `documents jsonb default '[]'`
- `availability jsonb default '{}'`
- `metadata jsonb default '{}'`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.provider_services`

- `id uuid primary key default gen_random_uuid()`
- `provider_id uuid references public.providers(id)`
- `service_id uuid references public.services(id)`
- `price numeric null`
- `price_unit text null default 'hour'`
- `description text null`
- `is_active boolean default true`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`
- Unique: `(provider_id, service_id)`

### `public.bookings`

- `id uuid primary key default gen_random_uuid()`
- `client_uid uuid references auth.users(id)`
- `provider_uid uuid null references auth.users(id)`
- `client_id uuid null references public.users(id)`
- `provider_id uuid null references public.providers(id)`
- `service_id uuid null references public.services(id)`
- `service_name text default ''`
- `provider_name text null`
- `client_name text null`
- `status booking_status default 'pending'`
- `scheduled_date date null`
- `scheduled_time time null`
- `scheduled_at timestamptz null`
- `duration_quantity integer default 1`
- `duration_type text default 'hours'`
- `address text null`
- `city text null default 'Tena'`
- `province text null default 'Napo'`
- `latitude double precision null`
- `longitude double precision null`
- `location_notes text null`
- `notes text null`
- `cancellation_reason text null`
- `rejection_reason text null`
- `subtotal numeric default 0`
- `platform_fee numeric default 0`
- `discount numeric default 0`
- `total_amount numeric default 0`
- `payment_method payment_method null`
- `payment_status payment_status default 'pending'`
- `metadata jsonb default '{}'`
- `confirmed_at timestamptz null`
- `started_at timestamptz null`
- `completed_at timestamptz null`
- `cancelled_at timestamptz null`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.payments`

- `id uuid primary key default gen_random_uuid()`
- `booking_id uuid references public.bookings(id)`
- `payer_uid uuid references auth.users(id)`
- `provider_uid uuid null references auth.users(id)`
- `method payment_method default 'cash'`
- `status payment_status default 'pending'`
- `amount numeric default 0`
- `currency text default 'USD'`
- `transaction_reference text null`
- `provider_reference text null`
- `receipt_url text null`
- `metadata jsonb default '{}'`
- `paid_at timestamptz null`
- `failed_at timestamptz null`
- `refunded_at timestamptz null`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.reviews`

- `id uuid primary key default gen_random_uuid()`
- `booking_id uuid unique references public.bookings(id)`
- `client_uid uuid references auth.users(id)`
- `provider_uid uuid references auth.users(id)`
- `rating integer check (rating >= 1 and rating <= 5)`
- `comment text null`
- `provider_reply text null`
- `is_visible boolean default true`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.chats`

- `id uuid primary key default gen_random_uuid()`
- `participants uuid[] default array[]::uuid[]`
- `booking_id uuid null references public.bookings(id)`
- `last_message text default ''`
- `last_message_time timestamptz default now()`
- `last_message_sender_id uuid null`
- `unread_count jsonb default '{}'`
- `"unreadCount" jsonb default '{}'`
- `participant_names jsonb default '{}'`
- `"participantNames" jsonb default '{}'`
- `is_active boolean default true`
- `is_archived boolean default false`
- `archived_at timestamptz null`
- `visible_for uuid[] default array[]::uuid[]`
- `"visibleFor" uuid[] default array[]::uuid[]`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

### `public.messages`

- `id uuid primary key default gen_random_uuid()`
- `"chatId" uuid references public.chats(id)`
- `"senderId" uuid references auth.users(id)`
- `"senderName" text default ''`
- `content text default ''`
- `type message_type default 'text'`
- `timestamp timestamptz default now()`
- `"isRead" boolean default false`
- `metadata jsonb null`
- `created_at timestamptz default now()`

### `public.user_blocks`

- `id uuid primary key default gen_random_uuid()`
- `blocker_id uuid references auth.users(id)`
- `blocked_id uuid references auth.users(id)`
- `created_at timestamptz default now()`
- Unique: `(blocker_id, blocked_id)`

### `public.notifications`

- `id uuid primary key default gen_random_uuid()`
- `user_uid uuid references auth.users(id)`
- `title text`
- `body text`
- `type notification_type default 'system'`
- `data jsonb default '{}'`
- `is_read boolean default false`
- `read_at timestamptz null`
- `created_at timestamptz default now()`

## RLS Policy Summary

- Admin access is centralized through `is_admin()`.
- `users`: insert/update/select own row or admin.
- `admins`: only admins can select/manage.
- `service_categories` and `services`: authenticated users can read active rows; admins manage all.
- `providers`: authenticated users can read active providers; providers update own profile; admins manage.
- `provider_services`: providers manage their own service records; active rows are readable.
- `bookings`, `payments`, `reviews`: participants can read/update allowed rows; admins can manage.
- `chats` and `messages`: access is limited to participants or admins.
- `notifications`: users read/update own notifications; admins can insert.
- `user_blocks`: users manage/read their own block records.

## Functions

- `is_admin() returns boolean`
- `is_provider() returns boolean`
- `set_updated_at() returns trigger`
- `sync_chat_compat_columns() returns trigger`
- `rls_auto_enable() returns event_trigger`

## Triggers

- `set_updated_at()` runs before update on: `admins`, `bookings`, `chats`,
  `payments`, `provider_services`, `providers`, `reviews`,
  `service_categories`, `services`, `users`.
- `sync_chat_compat_columns()` runs before insert/update on `chats`.

## Storage Buckets

| Bucket | Public | Limit | MIME types |
| --- | --- | ---: | --- |
| `profile-images` | true | 5 MB | `image/jpeg`, `image/png`, `image/webp` |
| `service-images` | true | 5 MB | `image/jpeg`, `image/png`, `image/webp` |
| `provider-documents` | false | 10 MB | `image/jpeg`, `image/png`, `image/webp`, `application/pdf` |
| `chat-media` | true | 10 MB | `image/jpeg`, `image/png`, `image/webp`, `audio/mpeg`, `audio/mp4`, `audio/aac`, `audio/wav`, `application/pdf` |

## Important Indexes

- `users`: `uid`, `email`, `role`, `is_active`, `fcm_token`
- `admins`: `uid`
- `service_categories`: `slug`, `name`, `is_active`
- `services`: `slug`, `category_id`, `is_active`
- `providers`: `uid`, `status`, `is_available`, `rating`
- `provider_services`: `provider_id`, `service_id`, `(provider_id, service_id)`, `is_active`
- `bookings`: `client_uid`, `provider_uid`, `service_id`, `status`, `scheduled_at`
- `payments`: `booking_id`, `payer_uid`, `status`
- `reviews`: `booking_id`, `client_uid`, `provider_uid`, `rating`
- `chats`: `booking_id`, `participants gin`, `visible_for gin`, `last_message_time desc`
- `messages`: `"chatId"`, `"senderId"`, `"timestamp" desc`, `type`
- `notifications`: `user_uid`, `is_read`, `created_at desc`
- `user_blocks`: `blocker_id`, `blocked_id`, `(blocker_id, blocked_id)`

## Public Catalog Data

See `references/public-catalog-seed.json`.
