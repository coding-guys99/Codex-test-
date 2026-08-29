create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.companies (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  region text not null,
  website text,
  capabilities text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists public.opportunities (
  id text primary key,
  reference text,
  title text not null,
  buyer text not null,
  region text not null,
  country text not null,
  opportunity_type text not null,
  posted_date date,
  closing_date date,
  source_url text not null,
  source_type text not null default 'Official',
  industry text,
  created_at timestamptz not null default now()
);

create table if not exists public.pipeline_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  opportunity_id text references public.opportunities(id) on delete set null,
  stage text not null check(stage in ('new','interested','contacted','quoted','won','lost')),
  quoted_value numeric(14,2),
  deal_value numeric(14,2),
  currency text not null default 'MYR',
  verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.referrals (
  id uuid primary key default gen_random_uuid(),
  from_user_id uuid not null references auth.users(id) on delete cascade,
  to_company_id uuid references public.companies(id) on delete set null,
  opportunity_id text references public.opportunities(id) on delete set null,
  status text not null default 'introduced',
  deal_value numeric(14,2),
  verified boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.platform_metrics (
  singleton boolean primary key default true check(singleton),
  opportunities_tracked integer not null default 0 check(opportunities_tracked >= 0),
  companies_indexed integer not null default 0 check(companies_indexed >= 0),
  verified_deals integer not null default 0 check(verified_deals >= 0),
  verified_business_generated numeric(16,2) not null default 0 check(verified_business_generated >= 0),
  currency text not null default 'MYR',
  updated_at timestamptz not null default now()
);
insert into public.platform_metrics(singleton,opportunities_tracked,verified_deals,verified_business_generated)
values(true,100,0,0) on conflict (singleton) do nothing;

alter table public.profiles enable row level security;
alter table public.companies enable row level security;
alter table public.opportunities enable row level security;
alter table public.pipeline_items enable row level security;
alter table public.referrals enable row level security;
alter table public.platform_metrics enable row level security;

revoke all on table public.profiles, public.companies, public.opportunities, public.pipeline_items, public.referrals, public.platform_metrics from anon, authenticated;
grant select on table public.opportunities, public.platform_metrics to anon, authenticated;
grant select, insert, update on table public.profiles, public.companies, public.pipeline_items, public.referrals to authenticated;

create policy "public opportunities readable" on public.opportunities for select to anon, authenticated using (true);
create policy "public metrics readable" on public.platform_metrics for select to anon, authenticated using (true);
create policy "profile owner select" on public.profiles for select to authenticated using ((select auth.uid())=id);
create policy "profile owner insert" on public.profiles for insert to authenticated with check ((select auth.uid())=id);
create policy "profile owner update" on public.profiles for update to authenticated using ((select auth.uid())=id) with check ((select auth.uid())=id);
create policy "companies authenticated readable" on public.companies for select to authenticated using (true);
create policy "company owner insert" on public.companies for insert to authenticated with check ((select auth.uid())=owner_id);
create policy "company owner update" on public.companies for update to authenticated using ((select auth.uid())=owner_id) with check ((select auth.uid())=owner_id);
create policy "pipeline owner select" on public.pipeline_items for select to authenticated using ((select auth.uid())=user_id);
create policy "pipeline owner insert" on public.pipeline_items for insert to authenticated with check ((select auth.uid())=user_id);
create policy "pipeline owner update" on public.pipeline_items for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
create policy "referral sender select" on public.referrals for select to authenticated using ((select auth.uid())=from_user_id);
create policy "referral sender insert" on public.referrals for insert to authenticated with check ((select auth.uid())=from_user_id);
create policy "referral sender update" on public.referrals for update to authenticated using ((select auth.uid())=from_user_id) with check ((select auth.uid())=from_user_id);
