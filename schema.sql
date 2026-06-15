-- Schema SQL untuk Platform Undangan Pernikahan
-- Jalankan kode ini di fitur SQL Editor pada Supabase Anda

-- 1. Buat Tabel Pengaturan Global (Settings)
CREATE TABLE IF NOT EXISTS settings (
    id SERIAL PRIMARY KEY,
    theme_color VARCHAR(50) DEFAULT '#7e57c2',
    bg_music_url TEXT,
    cover_image_url TEXT,
    event_date DATE
);

-- 2. Buat Tabel Mempelai (Couples)
CREATE TABLE IF NOT EXISTS couples (
    id SERIAL PRIMARY KEY,
    groom_name VARCHAR(255) NOT NULL,
    groom_parents TEXT,
    groom_photo_url TEXT,
    bride_name VARCHAR(255) NOT NULL,
    bride_parents TEXT,
    bride_photo_url TEXT
);

-- 3. Buat Tabel Acara (Events)
CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    event_date DATE,
    start_time TIME,
    end_time TIME,
    location_name TEXT,
    maps_url TEXT
);

-- 4. Buat Tabel Galeri (Gallery)
CREATE TABLE IF NOT EXISTS gallery (
    id SERIAL PRIMARY KEY,
    image_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Buat Tabel Ucapan (Wishes)
CREATE TABLE IF NOT EXISTS wishes (
    id SERIAL PRIMARY KEY,
    sender_name VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Buat Tabel Tamu/RSVP (RSVPs)
CREATE TABLE IF NOT EXISTS rsvps (
    id SERIAL PRIMARY KEY,
    guest_name VARCHAR(255) NOT NULL,
    guest_count INT DEFAULT 1,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Buat Tabel Love Story (Timeline Perjalanan Cinta)
CREATE TABLE IF NOT EXISTS love_story (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    story_date DATE,
    description TEXT,
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Buat Tabel Amplop Digital (Envelopes)
CREATE TABLE IF NOT EXISTS envelopes (
    id SERIAL PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(100) NOT NULL,
    account_name VARCHAR(255) NOT NULL,
    qris_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Buat Tabel Live Streaming
CREATE TABLE IF NOT EXISTS live_streams (
    id SERIAL PRIMARY KEY,
    platform VARCHAR(50) NOT NULL, -- e.g., 'YouTube', 'Zoom'
    stream_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Disable Row Level Security (RLS) sementara agar akses dari client JS (anon key) bebas membaca dan menulis data
ALTER TABLE settings DISABLE ROW LEVEL SECURITY;
ALTER TABLE couples DISABLE ROW LEVEL SECURITY;
ALTER TABLE events DISABLE ROW LEVEL SECURITY;
ALTER TABLE gallery DISABLE ROW LEVEL SECURITY;
ALTER TABLE wishes DISABLE ROW LEVEL SECURITY;
ALTER TABLE rsvps DISABLE ROW LEVEL SECURITY;
ALTER TABLE love_story DISABLE ROW LEVEL SECURITY;
ALTER TABLE envelopes DISABLE ROW LEVEL SECURITY;
ALTER TABLE live_streams DISABLE ROW LEVEL SECURITY;

-- Insert Default Data (Opsional jika tabel sudah berisi)
INSERT INTO settings (theme_color, event_date) 
SELECT '#7e57c2', '2026-12-31'
WHERE NOT EXISTS (SELECT 1 FROM settings);

INSERT INTO couples (groom_name, bride_name) 
SELECT 'Nama Pria', 'Nama Wanita'
WHERE NOT EXISTS (SELECT 1 FROM couples);

-- Konfigurasi Storage Bucket (Otomatis)
INSERT INTO storage.buckets (id, name, public) VALUES ('wedding-assets', 'wedding-assets', true)
ON CONFLICT (id) DO NOTHING;

-- Hapus policy yang mungkin sudah ada sebelum membuat baru (agar tidak error)
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
CREATE POLICY "Public Access" ON storage.objects FOR ALL USING (bucket_id = 'wedding-assets');
