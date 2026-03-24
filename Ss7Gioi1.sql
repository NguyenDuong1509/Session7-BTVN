CREATE DATABASE Ss7Gioi1;
CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE post_like (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id)
);
--Yeu cau 1
CREATE INDEX idx_post_content_lower ON post (LOWER(content));

/*
Trước khi tạo: Hệ thống phải thực hiện Sequential Scan. Nếu bảng có hàng triệu dòng, tốc độ sẽ rất chậm vì phải chuyển đổi LOWER() cho từng dòng tại thời điểm chạy.

Sau khi tạo: Hệ thống sẽ thực hiện Index Scan. PostgreSQL sẽ tra cứu trực tiếp trên chỉ mục đã được tính toán sẵn, giúp giảm đáng kể thời gian truy vấn
*/
--Yeu cau 2
--a
CREATE INDEX idx_post_tags_gin ON post USING GIN (tags);
--b
EXPLAIN ANALYZE 
SELECT * FROM post WHERE tags @> ARRAY['travel'];
--Yeu cau 3
--a
CREATE INDEX idx_post_recent_public 
ON post(created_at DESC) 
WHERE is_public = TRUE;
--b
SELECT * FROM post 
WHERE is_public = TRUE AND created_at >= NOW() - INTERVAL '7 days';
--Yeu cau 4
--a
CREATE INDEX idx_user_created_at 
ON post (user_id, created_at DESC);
--b
SELECT * FROM post 
WHERE user_id IN (1, 2, 3) 
ORDER BY created_at DESC 
LIMIT 10;










