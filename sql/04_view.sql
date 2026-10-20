-- ML6: view = SELECT ที่ตั้งชื่อไว้ แอปเรียกใช้เหมือนตาราง
create view public.menu_list
with (security_invoker = true) as
select m.id, m.name, m.price, c.name as category, m.spicy, m.emoji
from public.menus m
join public.categories c on c.id = m.category_id;

select * from public.menu_list order by price;
