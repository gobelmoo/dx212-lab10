-- ML10: แก้ข้อมูลในฐานข้อมูล แล้วกดโหลดใหม่ในแอป
update public.menus set price = 55 where name = 'ก๋วยเตี๋ยวต้มยำ';

insert into public.menus (name, price, spicy, emoji, category_id)
values ('ผัดซีอิ๊ว', 50, false, '🥡', 2);
