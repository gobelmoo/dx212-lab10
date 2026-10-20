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
