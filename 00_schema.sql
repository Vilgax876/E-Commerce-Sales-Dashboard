-- =============================================================
-- E-COMMERCE DATABASE SCHEMA
-- =============================================================
-- Database setup for ecommerce analytics dashboard
-- Created for Power BI/Tableau dashboard project

-- Create Tables

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    registration_date DATE,
    region TEXT,
    country TEXT
);

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER NOT NULL,
    price DECIMAL(10, 2),
    supplier_id INTEGER,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(12, 2),
    status TEXT CHECK(status IN ('Completed', 'Pending', 'Cancelled', 'Returned')),
    region TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =============================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_region ON orders(region);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category_id);

-- =============================================================
-- VIEWS FOR DASHBOARD
-- =============================================================

-- KPI Summary View
CREATE VIEW kpi_summary AS
SELECT 
    SUM(CASE WHEN status = 'Completed' THEN order_amount ELSE 0 END) as ytd_revenue,
    COUNT(DISTINCT CASE WHEN status = 'Completed' THEN order_id END) as ytd_orders,
    ROUND(SUM(CASE WHEN status = 'Completed' THEN order_amount ELSE 0 END) / 
          COUNT(DISTINCT CASE WHEN status = 'Completed' THEN order_id END), 2) as ytd_aov,
    COUNT(DISTINCT customer_id) as ytd_customer_count
FROM orders
WHERE YEAR(order_date) = YEAR(GETDATE());

-- Daily Revenue Trend
CREATE VIEW daily_revenue_trend AS
SELECT 
    CAST(order_date AS DATE) as date,
    SUM(order_amount) as daily_revenue,
    CASE WHEN DATEPART(dw, order_date) IN (1, 7) THEN 'Yes' ELSE 'No' END as is_weekend
FROM orders
WHERE status = 'Completed'
GROUP BY CAST(order_date AS DATE), DATEPART(dw, order_date)
ORDER BY date;

-- Revenue by Region
CREATE VIEW revenue_by_region AS
SELECT 
    region,
    SUM(order_amount) as total_revenue,
    COUNT(order_id) as order_count,
    ROUND(AVG(order_amount), 2) as avg_order_value
FROM orders
WHERE status = 'Completed'
GROUP BY region
ORDER BY total_revenue DESC;

-- Revenue by Category
CREATE VIEW revenue_by_category AS
SELECT 
    c.category_name,
    SUM(o.order_amount) as category_revenue,
    COUNT(o.order_id) as order_count,
    ROUND(AVG(o.order_amount), 2) as avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status = 'Completed'
GROUP BY c.category_name
ORDER BY category_revenue DESC;

-- Top 10 Products by Revenue
CREATE VIEW top_products_by_revenue AS
SELECT TOP 10
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(o.order_amount) as product_revenue,
    SUM(oi.quantity) as units_sold,
    COUNT(DISTINCT o.order_id) as order_count,
    ROUND(SUM(o.order_amount) / NULLIF(SUM(oi.quantity), 0), 2) as avg_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY product_revenue DESC;

-- Order Status Distribution
CREATE VIEW order_status_distribution AS
SELECT 
    status as order_status,
    COUNT(order_id) as order_count,
    SUM(order_amount) as revenue_by_status,
    ROUND(COUNT(order_id) * 100.0 / (SELECT COUNT(*) FROM orders), 2) as percentage_of_total
FROM orders
GROUP BY status;

-- Customer Summary
CREATE VIEW customer_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    COUNT(o.order_id) as lifetime_orders,
    SUM(o.order_amount) as lifetime_value,
    MAX(o.order_date) as last_order_date,
    COUNT(DISTINCT YEAR(o.order_date)) as active_years
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.region;

-- Product Popularity
CREATE VIEW product_popularity AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    COUNT(DISTINCT o.order_id) as times_ordered,
    SUM(oi.quantity) as total_units_sold,
    ROUND(AVG(o.order_amount), 2) as avg_order_value
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY times_ordered DESC;

-- =============================================================
-- END OF SCHEMA
-- =============================================================
