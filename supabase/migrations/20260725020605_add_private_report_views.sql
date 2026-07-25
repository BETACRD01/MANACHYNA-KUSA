begin;

create schema if not exists private;
revoke all on schema private from public;

create or replace view private.report_overview as
select 10 as sort_order, 'Usuarios totales'::text as metric, count(*)::numeric as value
from public.users
union all
select 20, 'Usuarios activos', count(*)::numeric
from public.users
where is_active = true
union all
select 30, 'Proveedores totales', count(*)::numeric
from public.providers
union all
select 40, 'Proveedores activos', count(*)::numeric
from public.providers
where is_active = true
union all
select 50, 'Proveedores disponibles', count(*)::numeric
from public.providers
where is_available = true
union all
select 60, 'Servicios activos', count(*)::numeric
from public.services
where is_active = true
union all
select 70, 'Reservas totales', count(*)::numeric
from public.bookings
union all
select 80, 'Reservas pendientes', count(*)::numeric
from public.bookings
where status::text in ('pending', 'requested')
union all
select 90, 'Reservas confirmadas', count(*)::numeric
from public.bookings
where status::text = 'confirmed'
union all
select 100, 'Reservas completadas', count(*)::numeric
from public.bookings
where status::text = 'completed'
union all
select 110, 'Reservas canceladas', count(*)::numeric
from public.bookings
where status::text = 'cancelled'
union all
select 120, 'Ingresos por reservas completadas', coalesce(sum(total_amount), 0)::numeric
from public.bookings
where status::text = 'completed'
union all
select 130, 'Pagos registrados', coalesce(sum(amount), 0)::numeric
from public.payments
union all
select 140, 'Calificacion promedio visible', coalesce(round(avg(rating)::numeric, 2), 0)::numeric
from public.reviews
where is_visible = true
union all
select 150, 'Mensajes enviados', count(*)::numeric
from public.messages;

create or replace view private.report_daily_activity as
with days as (
  select generate_series(
    current_date - interval '29 days',
    current_date,
    interval '1 day'
  )::date as day
)
select
  d.day,
  coalesce(u.new_users, 0)::integer as new_users,
  coalesce(p.new_providers, 0)::integer as new_providers,
  coalesce(b.bookings_created, 0)::integer as bookings_created,
  coalesce(b.bookings_completed, 0)::integer as bookings_completed,
  coalesce(b.booking_amount, 0)::numeric as booking_amount,
  coalesce(pay.payments_amount, 0)::numeric as payments_amount,
  coalesce(m.messages_sent, 0)::integer as messages_sent
from days d
left join (
  select created_at::date as day, count(*) as new_users
  from public.users
  where created_at >= current_date - interval '29 days'
  group by created_at::date
) u on u.day = d.day
left join (
  select created_at::date as day, count(*) as new_providers
  from public.providers
  where created_at >= current_date - interval '29 days'
  group by created_at::date
) p on p.day = d.day
left join (
  select
    created_at::date as day,
    count(*) as bookings_created,
    count(*) filter (where status::text = 'completed') as bookings_completed,
    coalesce(sum(total_amount) filter (where status::text = 'completed'), 0) as booking_amount
  from public.bookings
  where created_at >= current_date - interval '29 days'
  group by created_at::date
) b on b.day = d.day
left join (
  select created_at::date as day, coalesce(sum(amount), 0) as payments_amount
  from public.payments
  where created_at >= current_date - interval '29 days'
    and status::text in ('paid', 'completed', 'succeeded')
  group by created_at::date
) pay on pay.day = d.day
left join (
  select created_at::date as day, count(*) as messages_sent
  from public.messages
  where created_at >= current_date - interval '29 days'
  group by created_at::date
) m on m.day = d.day
order by d.day;

create or replace view private.report_booking_status as
select
  status::text as status,
  count(*)::integer as bookings,
  coalesce(sum(total_amount), 0)::numeric as total_amount
from public.bookings
group by status::text
order by bookings desc, status;

revoke all on private.report_overview from public;
revoke all on private.report_daily_activity from public;
revoke all on private.report_booking_status from public;

commit;
