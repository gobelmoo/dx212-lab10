# dx212-lab10 — แอป "กินในงบ" + Supabase (จบคาบ 10)

โค้ดเฉลยฉบับสมบูรณ์ของ dX212 Mobile Programming คาบ 10 (Database Fundamentals) ใช้เป็นจุดเริ่มของ **Lab 11: API & Data Integration (CRUD + Auth)**

- Expo SDK 57 · Expo Router · TypeScript · `@supabase/supabase-js` v2
- เมนูโหลดจากฐานข้อมูล Supabase (view `menu_list`) — ไม่มี `data.ts` แล้ว
- หน้าแรกมีสถานะ **กำลังโหลด / ผิดพลาด (ลองใหม่) / ↻ โหลดใหม่**
- ฟอร์มเพิ่มเมนูยังเพิ่ม "แค่ในเครื่อง" → คาบ 11 เปลี่ยนเป็น `insert` ลงฐานข้อมูล

## 1) ตั้งฐานข้อมูล (ครั้งเดียว)

ใน Supabase → **SQL Editor** → รัน `sql/setup_all.sql` (หรือ `01` → `02` → `04` → `05` ทีละไฟล์)
ได้ตาราง `categories`, `menus`, view `menu_list` และสิทธิ์อ่านอย่างเดียว (GRANT + RLS + POLICY)

เช็คว่าใช้ได้ (ใส่ URL + publishable key ของโปรเจกต์ตัวเอง — Windows PowerShell ใช้ `curl.exe` และพิมพ์บรรทัดเดียว):

```bash
curl "https://<project-ref>.supabase.co/rest/v1/menu_list?select=*" -H "apikey: sb_publishable_xxxxxxxx"
```

ต้องได้ JSON 5 เมนู · ได้ `42501` = ยังไม่ GRANT · ได้ `[]` = ยังไม่มี policy

## 2) ติดตั้งและรันแอป

```bash
git clone https://github.com/gobelmoo/dx212-lab10.git dx212-lab10
cd dx212-lab10
npm install
cp .env.example .env.local      # Windows: copy .env.example .env.local
```

เปิด `.env.local` ใส่ค่าจริงจาก Supabase → ปุ่ม **Connect** (หรือ Project Settings → API Keys):

```
EXPO_PUBLIC_SUPABASE_URL=https://<project-ref>.supabase.co
EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

```bash
npx expo start        # กด w = เว็บ · a = Android Emulator · สแกน QR = Expo Go
```

> ใส่ได้เฉพาะ **publishable key** — ห้ามใช้ secret key (`sb_secret_...`) ในแอปเด็ดขาด
> `.env.local` ถูก `.gitignore` กันไว้ ไม่ขึ้น GitHub · แก้ไฟล์นี้แล้วต้องหยุด `expo start` (Ctrl+C) แล้วรันใหม่

## 3) เปิดเป็นเว็บบน Vercel (ไม่บังคับ)

repo นี้ตั้งค่าไว้แล้ว: `app.json` ใช้ `"web": { "output": "single" }` และมี `vercel.json` (build ด้วย `npx expo export -p web` → โฟลเดอร์ `dist`, ส่งทุก path ไปหน้าแอป จึงเปิด `/menu/3` ตรง ๆ ได้)

1. vercel.com → **Add New → Project** → Import repo นี้จาก GitHub (Framework Preset ปล่อยเป็น Other — ค่าอื่นอ่านจาก `vercel.json`)
2. **Environment Variables** ใส่ 2 ตัวเหมือน `.env.local`: `EXPO_PUBLIC_SUPABASE_URL` และ `EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY` (publishable key เท่านั้น)
3. กด **Deploy** → ได้ลิงก์ `https://<ชื่อโปรเจกต์>.vercel.app` · หลังจากนี้ทุกครั้งที่ `git push` Vercel จะ build ใหม่ให้เอง

> ค่า `EXPO_PUBLIC_` ถูกฝังตอน build → แก้ค่าใน Vercel แล้วต้องกด **Redeploy**

## โครงไฟล์ (ส่วนที่เปลี่ยนจาก lab9)

```
src/lib/
├── supabase.ts       ← ใหม่: createClient จาก .env.local
├── MenuContext.tsx   ← โหลด menu_list ด้วย useEffect + loading / error / reload
├── logic.ts          ← type Menu + filterByBudget, sortByPrice, searchByName
└── theme.ts
src/app/(tabs)/index.tsx   ← แสดงกำลังโหลด / กล่อง error / ปุ่มโหลดใหม่
src/app/menu/[id].tsx      ← หมุนรอระหว่างโหลด
sql/                       ← SQL ทุกขั้นของคาบ 10 (setup_all.sql = รวม)
```

## ปัญหาที่พบบ่อย

| อาการ | วิธีแก้ |
|---|---|
| `expo: command not found` / `Cannot find module` | ยังไม่ได้ `npm install` |
| `npm install` เตือน deprecated / vulnerabilities / install-scripts | ปกติ ใช้งานได้ — **ห้ามรัน `npm audit fix --force`** (จะเปลี่ยนเวอร์ชันจนไม่ตรง Expo SDK 57) |
| จอแดง `supabaseUrl is required.` | ไม่มี `.env.local` / ชื่อตัวแปรผิด / ยังไม่ restart `npx expo start` |
| กล่องแดง `permission denied ... (42501)` | ยังไม่ GRANT ให้ anon → รัน `sql/05_security.sql` |
| ขึ้น "ไม่พบเมนูตามเงื่อนไข" ทั้งที่ Table Editor มีข้อมูล | เปิด RLS แล้วแต่ยังไม่มี policy → รัน `sql/05_security.sql` |
| `relation "public.menu_list" does not exist` | ยังไม่สร้าง view → `sql/04_view.sql` หรือใช้ URL ผิดโปรเจกต์ |
| `Invalid API key` | copy key ไม่ครบ หรือเป็น key ของอีกโปรเจกต์ |
| `Failed to fetch` | URL ต้องขึ้นต้น `https://` · โปรเจกต์ถูก pause → Restore ใน Dashboard |
