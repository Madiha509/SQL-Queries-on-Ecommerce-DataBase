-- Create a new database
CREATE DATABASE ecommerce_db;

-- Switch to the new database
USE ecommerce_db;

-- Create Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100)
);

-- Create Categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50)
);

-- Create Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Create Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Customers
INSERT INTO customers (customer_name, city, email) VALUES
('Amit Sharma', 'Delhi', 'amit@example.com'),
('Riya Patel', 'Mumbai', 'riya@example.com'),
('John Doe', 'Chennai', 'john@example.com'),
('Sneha Singh', 'Bangalore', 'sneha@example.com'),
('Ali Khan', 'Hyderabad', 'ali@example.com');

-- Insert Categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

-- Insert Products
INSERT INTO products (product_name, category_id, price) VALUES
('Smartphone', 1, 15000.00),
('Laptop', 1, 55000.00),
('T-Shirt', 2, 500.00),
('Jeans', 2, 1200.00),
('Novel', 3, 300.00),
('Textbook', 3, 800.00);

-- Insert Orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-08-01', 15000.00),
(2, '2025-08-02', 1700.00),
(3, '2025-08-03', 300.00),
(4, '2025-08-04', 800.00),
(1, '2025-08-05', 55000.00);

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(2, 3, 2),
(2, 4, 1),
(3, 5, 1),
(4, 6, 1),
(5, 2, 1); 


-- Query 1: Show all customers from Mumbai
SELECT customer_name, city
FROM customers
WHERE city = 'Mumbai';

-- Query 2: List all products, sorted by price (highest to lowest)
SELECT product_name, price
FROM products
ORDER BY price DESC;

-- Query 3: Count the number of orders placed by each customer
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- Query 4: Show order details with customer names (INNER JOIN)
SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Query 5: List all products and their categories (INNER JOIN)
SELECT p.product_name, c.category_name, p.price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- Query 6: Get order items with product names and quantities (JOIN across 3 tables)
SELECT oi.order_id, p.product_name, oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id;

-- Query 7: Show total revenue per product
SELECT p.product_name, SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Query 8: Get customers who have placed more than 1 order (using subquery)
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

-- Query 9: Create a view for simplified order summary
DROP VIEW IF EXISTS order_summary;

CREATE VIEW order_summary AS
SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

CREATE INDEX idx_customer_city ON customers(city);

SELECT customer_id, customer_name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
);













 

