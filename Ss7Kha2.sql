CREATE DATABASE Ss7Kha2;
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE
);
INSERT INTO customer (full_name, email, phone) VALUES
('Nguyen Van A', 'vana@gmail.com', '0912345678'),
('Tran Thi B', 'thib@yahoo.com', '0988777666'),
('Le Van C', 'vanc@outlook.com', '0905111222'),
('Pham Minh D', 'minhd@gmail.com', '0933444555'),
('Hoang Lan E', 'lane@gmail.com', '0977666555');
INSERT INTO orders (customer_id, total_amount, order_date) VALUES
(1, 500.00, '2024-03-01'),
(1, 120.50, '2024-03-05'),
(2, 2500.00, '2024-03-10'),
(3, 45.00, '2024-03-12'),
(4, 1000.00, '2024-03-15'),
(5, 75.25, '2024-03-18'),
(2, 300.00, '2024-03-20'),
(3, 150.00, '2024-03-21'),
(1, 99.99, '2024-03-22'),
(4, 550.00, '2024-03-23');
--Yeu cau 1
CREATE VIEW v_order_summary as
SELECT total_amount,full_name,order_date
FROM customer c
JOIN orders o ON o.customer_id = c.customer_id;
--Yeu cau 2
SELECT*FROM v_order_summary;
--Yeu cau 3
CREATE VIEW v_dh as
SELECT order_id,total_amount
FROM orders
WHERE total_amount >= 1000000;

UPDATE v_dh
SET total_amount = 3000000
WHERE order_id =  3;
--Yeu cau 4
CREATE VIEW v_monthly_sales_simple AS
SELECT 
    EXTRACT(YEAR FROM order_date) AS nam,
    EXTRACT(MONTH FROM order_date) AS thang,
    SUM(total_amount) AS tong_doanh_thu
FROM orders
GROUP BY nam, thang
ORDER BY nam DESC, thang DESC;
--Yeu cau 5
DROP VIEW v_order_summary;
/*
a. DROP VIEW dùng để xóa view thường. View chỉ là bảng ảo nên khi xóa chỉ mất định nghĩa, không ảnh hưởng dữ liệu gốc và thực hiện rất nhanh.

b. DROP MATERIALIZED VIEW dùng để xóa materialized view. Loại này có lưu dữ liệu thật nên khi xóa sẽ mất cả dữ liệu đã lưu, tốn tài nguyên hơn và không tự cập nhật như view thường.
*/