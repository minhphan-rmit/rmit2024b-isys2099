-- Create database and use it
CREATE DATABASE order_management_system;
USE order_management_system;

-- Create tables
CREATE TABLE products (
    product_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (product_id)
);

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    PRIMARY KEY (order_id)
);
-- note: order_status can be either 'new', 'cancelled', or 'completed'

CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert data into 'products'
INSERT INTO products (product_id, name, category, price) VALUES
(1, 'Apple iPhone 13', 'Electronics', 799.99),
(2, 'Samsung Galaxy S22', 'Electronics', 999.99),
(3, 'Sony Headphones', 'Accessories', 129.99),
(4, 'Dell XPS Laptop', 'Computers', 1200.00),
(5, 'Apple MacBook Air', 'Computers', 999.99),
(6, 'Canon EOS 1500D', 'Electronics', 550.00),
(7, 'Logitech Mouse', 'Accessories', 24.99);

-- Insert data into 'orders'
INSERT INTO orders (order_id, order_date, customer_name, order_status) VALUES
(1, '2024-08-01', 'John Doe', 'new'),
(2, '2024-08-02', 'Jane Smith', 'completed'),
(3, '2024-08-03', 'Alice Johnson', 'cancelled'),
(4, '2024-08-04', 'Phan Nhat Minh', 'completed');
-- Use your real full name for order #4.

-- Insert data into 'order_details'
INSERT INTO order_details (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(2, 4, 3),
(2, 5, 4),
(3, 6, 2),
(3, 7, 2),
(4, 1, 1),
(4, 3, 2),
(4, 6, 4);

-- Problem 1: Create indexes to optimize the query
CREATE INDEX idx_orders_order_id ON orders(order_id);
CREATE INDEX idx_order_details_order_id ON order_details(order_id);
CREATE INDEX idx_order_details_product_id ON order_details(product_id);
CREATE INDEX idx_products_product_id ON products(product_id);

-- Explain the optimized query
EXPLAIN
SELECT 
    o.order_date, 
    o.customer_name, 
    p.name AS product_name, 
    p.price AS product_price, 
    od.quantity, 
    (p.price * od.quantity) AS amount
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    products p ON od.product_id = p.product_id
ORDER BY 
    o.order_date, o.customer_name;

-- Drop indexes after explanation
DROP INDEX idx_orders_order_id ON orders;
DROP INDEX idx_order_details_order_id ON order_details;
DROP INDEX idx_order_details_product_id ON order_details;
DROP INDEX idx_products_product_id ON products;

-- Problem 2: Partition the 'products' table
-- Add an integer price column, copy data, and drop the original column
ALTER TABLE products ADD price_int INT;
UPDATE products SET price_int = CAST(price AS UNSIGNED);
ALTER TABLE products DROP COLUMN price;
ALTER TABLE products CHANGE price_int price INT;

-- Apply the partitioning
ALTER TABLE products
PARTITION BY RANGE (price) (
    PARTITION cheap VALUES LESS THAN (500),
    PARTITION medium VALUES LESS THAN (1000),
    PARTITION expensive VALUES LESS THAN MAXVALUE
);

-- Explain the query to show only needed partitions are used
EXPLAIN
SELECT 
    p.name, 
    SUM(od.quantity) AS total_sales
FROM 
    products p
JOIN 
    order_details od ON p.product_id = od.product_id
JOIN 
    orders o ON od.order_id = o.order_id
WHERE 
    p.price <= 800 AND o.order_status = 'completed'
GROUP BY 
    p.name;

-- Problem 3: Explain the query for completed orders
EXPLAIN
SELECT 
    o.order_id, 
    o.order_date, 
    o.customer_name, 
    SUM(od.quantity) AS total_purchased_items
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
WHERE 
    o.order_status = 'completed'
GROUP BY 
    o.order_id;
