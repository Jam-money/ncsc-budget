-- Run this in Supabase SQL Editor
-- Creates an expenses table + basic RLS policies for "shared login" usage.

create extension if not exists pgcrypto;

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  object_of_expenditure text not null default '',
  province text not null default '',
  budget_code text not null default '',
  proposed_amount numeric not null default 0,
  expense_amount numeric not null default 0
);

create table if not exists public.budget_inputs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  object_of_expenditure text not null default '',
  province text not null default '',
  budget_code text not null default '',
  proposed_amount numeric not null default 0,
  constraint budget_inputs_unique unique (object_of_expenditure, province, budget_code)
);

create table if not exists public.budget_master (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  object_of_expenditure text not null default '',
  province text not null default '',
  budget_code text not null default '',
  allocated_amount numeric not null default 0,
  constraint budget_master_unique unique (object_of_expenditure, province, budget_code)
);

create table if not exists public.budget_input_entries (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  object_of_expenditure text not null default '',
  province text not null default '',
  budget_code text not null default '',
  amount_added numeric not null default 0,
  notes text,
  user_email text
);

create table if not exists public.budget_transfers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  from_object text not null default '',
  from_province text not null default '',
  from_budget text not null default '',
  to_object text not null default '',
  to_province text not null default '',
  to_budget text not null default '',
  amount numeric not null default 0,
  reason text,
  user_email text
);

alter table public.expenses enable row level security;

alter table public.budget_inputs enable row level security;

alter table public.budget_master enable row level security;

alter table public.budget_input_entries enable row level security;

alter table public.budget_transfers enable row level security;

-- Allow any authenticated user to read
drop policy if exists "expenses_select_authenticated" on public.expenses;
create policy "expenses_select_authenticated"
on public.expenses
for select
to authenticated
using (true);

-- Allow any authenticated user to insert
drop policy if exists "expenses_insert_authenticated" on public.expenses;
create policy "expenses_insert_authenticated"
on public.expenses
for insert
to authenticated
with check (true);

-- Allow any authenticated user to update
drop policy if exists "expenses_update_authenticated" on public.expenses;
create policy "expenses_update_authenticated"
on public.expenses
for update
to authenticated
using (true)
with check (true);

-- Allow any authenticated user to delete
drop policy if exists "expenses_delete_authenticated" on public.expenses;
create policy "expenses_delete_authenticated"
on public.expenses
for delete
to authenticated
using (true);

drop policy if exists "budget_inputs_select_authenticated" on public.budget_inputs;
create policy "budget_inputs_select_authenticated"
on public.budget_inputs
for select
to authenticated
using (true);

drop policy if exists "budget_inputs_insert_authenticated" on public.budget_inputs;
create policy "budget_inputs_insert_authenticated"
on public.budget_inputs
for insert
to authenticated
with check (true);

drop policy if exists "budget_inputs_update_authenticated" on public.budget_inputs;
create policy "budget_inputs_update_authenticated"
on public.budget_inputs
for update
to authenticated
using (true)
with check (true);

drop policy if exists "budget_inputs_delete_authenticated" on public.budget_inputs;
create policy "budget_inputs_delete_authenticated"
on public.budget_inputs
for delete
to authenticated
using (true);

drop policy if exists "budget_master_select_authenticated" on public.budget_master;
create policy "budget_master_select_authenticated"
on public.budget_master
for select
to authenticated
using (true);

drop policy if exists "budget_master_insert_authenticated" on public.budget_master;
create policy "budget_master_insert_authenticated"
on public.budget_master
for insert
to authenticated
with check (true);

drop policy if exists "budget_master_update_authenticated" on public.budget_master;
create policy "budget_master_update_authenticated"
on public.budget_master
for update
to authenticated
using (true)
with check (true);

drop policy if exists "budget_master_delete_authenticated" on public.budget_master;
create policy "budget_master_delete_authenticated"
on public.budget_master
for delete
to authenticated
using (true);

drop policy if exists "budget_input_entries_insert_authenticated" on public.budget_input_entries;
create policy "budget_input_entries_insert_authenticated"
on public.budget_input_entries
for insert
to authenticated
with check (true);

drop policy if exists "budget_transfers_select_authenticated" on public.budget_transfers;
create policy "budget_transfers_select_authenticated"
on public.budget_transfers
for select
to authenticated
using (true);

drop policy if exists "budget_transfers_insert_authenticated" on public.budget_transfers;
create policy "budget_transfers_insert_authenticated"
on public.budget_transfers
for insert
to authenticated
with check (true);

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.expenses to authenticated;
grant select, insert, update, delete on public.budget_inputs to authenticated;
grant select, insert, update, delete on public.budget_master to authenticated;
grant insert on public.budget_input_entries to authenticated;
grant select, insert on public.budget_transfers to authenticated;
