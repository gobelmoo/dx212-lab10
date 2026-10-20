-- ตามไม่ทัน: รันไฟล์นี้ครั้งเดียวในโปรเจกต์ใหม่ = ได้ผลเท่ากับจบ ML7
-- (ถ้าเคยรันบางส่วนแล้ว จะเจอ error "already exists" — ให้รันไฟล์ 01–05 ทีละไฟล์แทน)

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

-- ML4-A: ใส่หมวดก่อน (เพราะเมนูต้องอ้างถึงหมวด)
insert into public.categories (name)
values ('ข้าว'), ('เส้น'), ('จานเดียว'), ('เครื่องดื่ม');

select * from public.categories;

-- ML4-B: ใส่เมนู — category_id ต้องตรงกับ id ในตาราง categories
insert into public.menus (name, price, spicy, emoji, category_id)
values
  ('ข้าวมันไก่', 45, false, '🍗', 1),
  ('ก๋วยเตี๋ยวต้มยำ', 50, true, '🍜', 2),
  ('กะเพราหมูกรอบ', 60, true, '🌶️', 1),
  ('สเต๊กหมู', 89, false, '🥩', 3),
  ('ชาไทย', 25, false, '🧋', 4);

select * from public.menus;

-- ML6: view = SELECT ที่ตั้งชื่อไว้ แอปเรียกใช้เหมือนตาราง
create view public.menu_list
with (security_invoker = true) as
select m.id, m.name, m.price, c.name as category, m.spicy, m.emoji
from public.menus m
join public.categories c on c.id = m.category_id;

select * from public.menu_list order by price;

-- ML7-B: เปิด RLS (ตรวจสิทธิ์ทีละแถว) — ทำก่อน GRANT เสมอ
alter table public.categories enable row level security;
alter table public.menus enable row level security;

-- ML7-C: GRANT = อนุญาตให้ role แตะตาราง/view ผ่าน API
grant select on public.categories, public.menus, public.menu_list
  to anon, authenticated;

-- ML7-D: POLICY = กฎว่าแถวไหนอ่านได้ (true = ทุกแถว)
create policy "ทุกคนอ่านหมวดได้" on public.categories
  for select to anon, authenticated using (true);

create policy "ทุกคนอ่านเมนูได้" on public.menus
  for select to anon, authenticated using (true);
