CREATE DATABASE Ss7Gioi2;
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    region VARCHAR(50)
);
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);
CREATE TABLE order_detail (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT
);
INSERT INTO customer (full_name, region) VALUES 
('Nguyễn Văn An', 'Miền Bắc'),
('Trần Thị Bình', 'Miền Trung'),
('Lê Hoàng Nam', 'Miền Nam');
INSERT INTO product (name, price, category) VALUES 
('Laptop Dell XPS', 25000000.00, 'Điện tử'),
('Chuột Logitech', 500000.00, 'Phụ kiện'),
('Bàn phím cơ AKKO', 1200000.00, 'Phụ kiện');
INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES 
(1, 25500000.00, '2026-03-20', 'Completed'),
(1, 1200000.00, '2026-03-21', 'Pending'),
(2, 500000.00, '2026-03-22', 'Shipped'),
(3, 26200000.00, '2026-03-23', 'Completed');
INSERT INTO order_detail (order_id, product_id, quantity) VALUES 
(1, 1, 1), 
(1, 2, 1), 
(2, 3, 1), 
(3, 2, 1), 
(4, 1, 1); 
--Yeu cau 1
CREATE VIEW v_revenue_by_region AS
SELECT c.region, SUM(o.total_amount) AS total_revenue
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

SELECT * FROM v_revenue_by_region
ORDER BY total_revenue DESC
LIMIT 3;
--Yeu cau 2
--a
CREATE VIEW v_pending_orders AS
SELECT order_id, customer_id, total_amount, status
FROM orders
WHERE status = 'Pending'
WITH CHECK OPTION;

UPDATE v_pending_orders
SET status = 'Shipped'
WHERE order_id = 1;
--b
/*
Nếu bạn cố tình cập nhật dữ liệu khiến dòng đó không còn thỏa mãn điều kiện của View hệ thống sẽ báo lỗi.
*/
--Yeu cau 3
--a
CREATE VIEW v_revenue_above_avg AS
SELECT region, total_revenue
FROM v_revenue_by_region
WHERE total_revenue > (SELECT AVG(total_revenue) FROM v_revenue_by_region);
--b