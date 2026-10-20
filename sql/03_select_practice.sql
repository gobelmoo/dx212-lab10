-- ML4-C: ลองให้ฐานข้อมูลปฏิเสธ (รันทีละบรรทัด — ทุกบรรทัดต้อง error)
-- ไม่มีหมวด id 99
-- insert into public.menus (name, price, category_id) values ('ข้าวผัดอวกาศ', 99, 99);
-- ราคาติดลบ
-- insert into public.menus (name, price, category_id) values ('ข้าวฟรี', -5, 1);
-- ไม่ใส่ชื่อ
-- insert into public.menus (price, category_id) values (30, 1);
-- หมวดซ้ำ
-- insert into public.categories (name) values ('ข้าว');

-- ML5: logic.ts → SQL
-- filterByBudget(MENUS, 60)
select * from public.menus where price <= 60;

-- sortByPrice(...)
select * from public.menus where price <= 60 order by price;

-- searchByName(..., "ข้าว")
select * from public.menus where name ilike '%ข้าว%';

-- JOIN: เอาชื่อหมวดมาด้วย
select m.name, m.price, c.name as category
from public.menus m
join public.categories c on c.id = m.category_id
order by m.price;

-- GROUP BY: นับเมนูต่อหมวด
select c.name,
       count(*) as total,
       round(avg(m.price), 2) as avg_price
from public.menus m
join public.categories c on c.id = m.category_id
group by c.name
order by total desc;

-- ML5: ฝึกเขียนเอง (เฉลย)
-- 1) เมนูที่เผ็ดทั้งหมด
select * from public.menus where spicy = true;

-- 2) เมนูราคา 40–60 บาท เรียงแพง → ถูก
select * from public.menus where price between 40 and 60 order by price desc;

-- 3) เมนูที่แพงที่สุด 1 รายการ
select * from public.menus order by price desc limit 1;

-- 4) จำนวนเมนูเผ็ด
select count(*) from public.menus where spicy = true;
