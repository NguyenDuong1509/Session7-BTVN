CREATE DATABASE Ss7Kha1;
CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(10,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--Yeu cau 1
SELECT * FROM book WHERE author ILIKE '%Rowling%';
SELECT * FROM book WHERE genre = 'Fantasy';

CREATE INDEX idx_book_genre ON book(genre);
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_book_author_trgm ON book USING gin (author gin_trgm_ops);
--Yeu cau 2
EXPLAIN ANALYZE SELECT * FROM book WHERE author ILIKE '%Rowling%';
EXPLAIN ANALYZE SELECT * FROM book WHERE genre = 'Fantasy';
--Yeu cau 3
CREATE INDEX idx_genre ON book (genre);
CREATE INDEX idx_fulltext ON book USING GIN (to_tsvector('english', title || ' ' || description));
--Yeu cau 4
CREATE INDEX idx_genre_cluster ON book (genre);
CLUSTER book USING idx_genre_cluster;
--Yeu cau 5
/*
a. Mỗi loại chỉ mục sẽ phù hợp với từng kiểu truy vấn khác nhau trong hệ thống cơ sở dữ liệu. Đối với các truy vấn so sánh chính xác như genre = 'Fantasy'chỉ mục B-tree là hiệu quả nhất vì tối ưu cho phép toán bằng và khoảng. Với các truy vấn tìm kiếm chuỗi có ký tự đại diện như ILIKE '%Rowling%'chỉ mục GIN kết hợp trigram giúp tăng tốc đáng kể.khi tìm kiếm nội dung dài trong title hoặc description chỉ mục GIN cho full-text search là lựa chọn tối ưu. Nhờ khả năng phân tích từ khóa, GIN giúp truy vấn nhanh và thông minh hơn so với LIKE thông thường. Vì chọn đúng loại index sẽ cải thiện hiệu năng rõ rệt.

b. Hash index không được khuyến khích sử dụng trong PostgreSQL trong nhiều trường hợp thực tế. Nguyên nhân là vì Hash chỉ hỗ trợ so sánh bằng (=) mà không dùng được cho các truy vấn phạm vi như <, >, BETWEEN.Hash index cũng không hỗ trợ sắp xếp dữ liệu (ORDER BY) nên kém linh hoạt hơn. Trong khi đó, B-tree có thể đáp ứng được hầu hết các loại truy vấn phổ biến. Vì vậy Hash index chỉ nên dùng trong trường hợp rất cụ thể khi chỉ cần so sánh bằng. Trong đa số tình huống, B-tree vẫn là lựa chọn tối ưu hơn.
*/

