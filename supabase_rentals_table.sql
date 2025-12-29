-- Create rentals/bookings table
create table public.rentals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  bike_id uuid references public.bikes(id) on delete cascade not null,
  start_time timestamptz not null default now(),
  end_time timestamptz,
  duration_minutes integer not null,
  planned_end_time timestamptz not null,
  price_per_hour numeric(10, 2) not null default 5.00,
  total_cost numeric(10, 2),
  status text not null default 'active' check (status in ('active', 'completed', 'cancelled')),
  start_station_id uuid references public.stations(id),
  end_station_id uuid references public.stations(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Create indexes for better performance
create index idx_rentals_user_id on public.rentals(user_id);
create index idx_rentals_bike_id on public.rentals(bike_id);
create index idx_rentals_status on public.rentals(status);
create index idx_rentals_start_time on public.rentals(start_time);

-- Create trigger for updated_at
create trigger on_rentals_updated
  before update on public.rentals
  for each row
  execute function public.handle_updated_at();

-- Enable Row Level Security
alter table public.rentals enable row level security;

-- Create policies for rentals
create policy "Users can view their own rentals"
  on public.rentals for select
  using (auth.uid() = user_id);

create policy "Users can create their own rentals"
  on public.rentals for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own rentals"
  on public.rentals for update
  using (auth.uid() = user_id);

-- Function to calculate rental cost
create or replace function public.calculate_rental_cost(
  p_rental_id uuid
)
returns numeric
language plpgsql
as $$
declare
  v_duration_minutes integer;
  v_price_per_hour numeric;
  v_total_cost numeric;
begin
  select 
    duration_minutes,
    price_per_hour
  into 
    v_duration_minutes,
    v_price_per_hour
  from public.rentals
  where id = p_rental_id;
  
  -- Calculate cost: (duration in minutes / 60) * price per hour
  v_total_cost := (v_duration_minutes::numeric / 60) * v_price_per_hour;
  
  return v_total_cost;
end;
$$;

-- Function to complete rental
create or replace function public.complete_rental(
  p_rental_id uuid
)
returns void
language plpgsql
security definer
as $$
declare
  v_bike_id uuid;
  v_total_cost numeric;
  v_user_id uuid;
begin
  -- Get rental details
  select bike_id, user_id
  into v_bike_id, v_user_id
  from public.rentals
  where id = p_rental_id;
  
  -- Calculate total cost
  v_total_cost := public.calculate_rental_cost(p_rental_id);
  
  -- Update rental
  update public.rentals
  set 
    end_time = now(),
    total_cost = v_total_cost,
    status = 'completed',
    updated_at = now()
  where id = p_rental_id;
  
  -- Update bike status back to available
  update public.bikes
  set 
    status = 'available',
    updated_at = now()
  where id = v_bike_id;
  
  -- Update user's total rentals
  update public.profiles
  set 
    total_rentals = total_rentals + 1,
    balance = balance - v_total_cost
  where id = v_user_id;
end;
$$;

-- Function to start rental
create or replace function public.start_rental(
  p_user_id uuid,
  p_bike_id uuid,
  p_duration_minutes integer,
  p_price_per_hour numeric default 5.00
)
returns uuid
language plpgsql
security definer
as $$
declare
  v_rental_id uuid;
  v_planned_end_time timestamptz;
begin
  -- Calculate planned end time
  v_planned_end_time := now() + (p_duration_minutes || ' minutes')::interval;
  
  -- Create rental
  insert into public.rentals (
    user_id,
    bike_id,
    duration_minutes,
    planned_end_time,
    price_per_hour,
    status
  )
  values (
    p_user_id,
    p_bike_id,
    p_duration_minutes,
    v_planned_end_time,
    p_price_per_hour,
    'active'
  )
  returning id into v_rental_id;
  
  -- Update bike status to rented
  update public.bikes
  set 
    status = 'rented',
    updated_at = now()
  where id = p_bike_id;
  
  return v_rental_id;
end;
$$;
