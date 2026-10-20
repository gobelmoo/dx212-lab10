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
