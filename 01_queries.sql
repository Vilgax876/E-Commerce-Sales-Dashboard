-- =============================================================
-- E-COMMERCE ANALYTICS QUERIES
-- =============================================================
-- Key queries for dashboard and business intelligence
-- Use these queries to create Power BI/Tableau datasets


-- ========================================
-- QUERY 1: KPI SUMMARY
-- ========================================
-- Key Performance Indicators for dashboard top cards
-- Metrics: Revenue YTD, Orders YTD, AOV, Customer Count

SELECT 
    CAST(SUM(CASE WHEN status = 'Completed' THEN order_amount ELSE 0 END) AS DECIMAL(12,2)) as ytd_revenue,
    COUNT(DISTINCT CASE WHEN status = 'Completed' THEN order_id END) as ytd_orders,
    CAST(SUM(CASE WHEN status = 'Completed' THEN order_amount ELSE 0 END) / 
         NULLIF(COUNT(DISTINCT CASE WHEN status = 'Completed' THEN order_id END), 0) AS DECIMAL(10,2)) as ytd_aov,
    COUNT(DISTINCT customer_id) as ytd_customer_count,
    -- Previous year comparison
    CAST(SUM(CASE WHEN status = 'Completed' AND YEAR(order_date) = YEAR(GETDATE())-1 THEN order_amount ELSE 0 END) AS DECIMAL(12,2)) as prev_year_revenue,
    COUNT(DISTINCT CASE WHEN status = 'Completed' AND YEAR(order_date) = YEAR(GETDATE())-1 THEN order_id END) as prev_year_orders
FROM orders
WHERE YEAR(order_date) = YEAR(GETDATE());


-- ========================================
-- QUERY 2: DAILY REVENUE TREND
-- ========================================
-- Last 90 days revenue trend with weekend flag
-- For line chart visualization

SELECT 
    CAST(order_date AS DATE) as date,
    YEAR(order_date) as year,
    MONTH(order_date) as month,
    DAY(order_date) as day,
    DATEPART(WEEKDAY, order_date) as day_of_week,
    CASE WHEN DATEPART(WEEKDAY, order_date) IN (1, 7) THEN 'Yes' ELSE 'No' END as is_weekend,
    SUM(order_amount) as daily_revenue,
    COUNT(order_id) as daily_orders,
    COUNT(DISTINCT customer_id) as daily_customers
FROM orders
WHERE status = 'Completed'
  AND order_date >= DATEADD(DAY, -90, CAST(GETDATE() AS DATE))
GROUP BY 
    CAST(order_date AS DATE),
    YEAR(order_date),
    MONTH(order_date),
    DAY(order_date),
    DATEPART(WEEKDAY, order_date)
ORDER BY date;


-- ========================================
-- QUERY 3: REVENUE BY REGION
-- ========================================
-- Regional performance breakdown
-- For horizontal bar chart

SELECT 
    region,
    CAST(SUM(order_amount) AS DECIMAL(12,2)) as total_revenue,
    COUNT(order_id) as order_count,
    COUNT(DISTINCT customer_id) as unique_customers,
    CAST(AVG(order_amount) AS DECIMAL(10,2)) as average_order_value,
    CAST(SUM(order_amount) / COUNT(order_id) AS DECIMAL(10,2)) as revenue_per_order
FROM orders
WHERE status = 'Completed'
GROUP BY region
ORDER BY total_revenue DESC;


-- ========================================
-- QUERY 4: REVENUE BY CATEGORY
-- ========================================
-- Product category performance
-- For bar chart visualization

SELECT 
    c.category_name,
    CAST(SUM(o.order_amount) AS DECIMAL(12,2)) as category_revenue,
    COUNT(DISTINCT o.order_id) as order_count,
    COUNT(DISTINCT oi.product_id) as product_count,
    SUM(oi.quantity) as total_units_sold,
    CAST(AVG(o.order_amount) AS DECIMAL(10,2)) as avg_order_value,
    CAST(SUM(o.order_amount) / COUNT(DISTINCT oi.product_id) AS DECIMAL(12,2)) as revenue_per_product
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE o.status = 'Completed'
GROUP BY c.category_name
ORDER BY category_revenue DESC;


-- ========================================
-- QUERY 5: TOP 10 PRODUCTS BY REVENUE
-- ========================================
-- Best performing products
-- For dashboard visualization

SELECT TOP 10
    p.product_id,
    p.product_name,
    c.category_name,
    CAST(SUM(o.order_amount) AS DECIMAL(12,2)) as product_revenue,
    COUNT(DISTINCT o.order_id) as times_ordered,
    SUM(oi.quantity) as units_sold,
    CAST(AVG(o.order_amount) AS DECIMAL(10,2)) as avg_order_value,
    CAST(COUNT(DISTINCT o.order_id) / CAST((SELECT COUNT(DISTINCT order_id) FROM orders WHERE status = 'Completed') AS FLOAT) * 100 AS DECIMAL(5,2)) as pct_of_orders,
    CAST(SUM(o.order_amount) / CAST((SELECT SUM(order_amount) FROM orders WHERE status = 'Completed') AS FLOAT) * 100 AS DECIMAL(5,2)) as pct_of_revenue
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY product_revenue DESC;


-- ========================================
-- QUERY 6: ORDER STATUS DISTRIBUTION
-- ========================================
-- Status breakdown of all orders
-- For pie/donut chart

SELECT 
    status as order_status,
    COUNT(order_id) as order_count,
    CAST(SUM(order_amount) AS DECIMAL(12,2)) as revenue_by_status,
    CAST(COUNT(order_id) * 100.0 / (SELECT COUNT(*) FROM orders) AS DECIMAL(5,2)) as percentage_of_total,
    CAST(SUM(order_amount) * 100.0 / (SELECT SUM(order_amount) FROM orders) AS DECIMAL(5,2)) as pct_of_revenue
FROM orders
GROUP BY status
ORDER BY order_count DESC;


-- ========================================
-- QUERY 7: CUSTOMER METRICS BY REGION
-- ========================================
-- Regional customer analysis
-- For dashboard slicing

SELECT 
    o.region,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    COUNT(DISTINCT o.order_id) as total_orders,
    CAST(SUM(o.order_amount) AS DECIMAL(12,2)) as total_revenue,
    CAST(AVG(o.order_amount) AS DECIMAL(10,2)) as avg_order_value,
    CAST(SUM(o.order_amount) / COUNT(DISTINCT o.customer_id) AS DECIMAL(12,2)) as revenue_per_customer,
    MAX(o.order_date) as last_order_date,
    MIN(o.order_date) as first_order_date
FROM orders o
WHERE o.status = 'Completed'
GROUP BY o.region
ORDER BY total_revenue DESC;


-- ========================================
-- QUERY 8: MONTHLY TRENDS
-- ========================================
-- Month-over-month performance
-- For trend analysis

SELECT 
    YEAR(order_date) as year,
    MONTH(order_date) as month,
    CAST(DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS DATE) as month_start,
    COUNT(DISTINCT order_id) as monthly_orders,
    COUNT(DISTINCT customer_id) as monthly_customers,
    CAST(SUM(order_amount) AS DECIMAL(12,2)) as monthly_revenue,
    CAST(AVG(order_amount) AS DECIMAL(10,2)) as monthly_avg_order_value
FROM orders
WHERE status = 'Completed'
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year DESC, month DESC;


-- ========================================
-- QUERY 9: CUSTOMER LIFETIME VALUE
-- ========================================
-- RFM-style analysis
-- For customer segmentation

SELECT TOP 50
    c.customer_id,
    c.customer_name,
    c.region,
    CAST(SUM(o.order_amount) AS DECIMAL(12,2)) as lifetime_value,
    COUNT(DISTINCT o.order_id) as lifetime_orders,
    CAST(AVG(o.order_amount) AS DECIMAL(10,2)) as avg_order_value,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(DAY, MAX(o.order_date), GETDATE()) as days_since_last_order,
    CAST(MAX(o.order_date) AS DATE) as last_purchase_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.region
ORDER BY lifetime_value DESC;


-- ========================================
-- QUERY 10: PRODUCT PERFORMANCE MATRIX
-- ========================================
-- Products by popularity and profitability
-- For category analysis

SELECT 
    c.category_name,
    p.product_id,
    p.product_name,
    COUNT(DISTINCT oi.order_id) as times_ordered,
    SUM(oi.quantity) as total_units_sold,
    CAST(SUM(o.order_amount) AS DECIMAL(12,2)) as product_revenue,
    CAST(AVG(p.price) AS DECIMAL(10,2)) as avg_price,
    CAST(SUM(oi.quantity) * AVG(p.price) AS DECIMAL(12,2)) as implied_revenue,
    CAST(COUNT(DISTINCT oi.order_id) * 100.0 / (SELECT COUNT(DISTINCT order_id) FROM orders WHERE status = 'Completed') AS DECIMAL(5,2)) as popularity_pct
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE o.status = 'Completed'
GROUP BY c.category_name, p.product_id, p.product_name
ORDER BY product_revenue DESC;

-- =============================================================
-- END OF QUERIES
-- =============================================================
