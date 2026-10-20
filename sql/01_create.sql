-- ML3: สร้าง 2 ตาราง (หมวด 1 → เมนูหลายรายการ)
create table public.categories (
  id bigint generated always as identity primary key,
  name text not null unique
);

create table public.menus (
  id bigint generated always as identity primary key,
  name text not null,
  price integer not null check (price > 0),
  spicy boolean not null default false,
  emoji text not null default '🍽️',
  category_id bigint not null references public.categories (id),
  created_at timestamptz not null default now()
);
