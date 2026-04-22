-- =================================================================================
-- E-Commerce Business Dashboard - Underlying SQL Queries
-- =================================================================================
-- These queries are designed to pull the insights needed for the Tableau/Power BI 
-- visualizations. They simulate how a data analyst would aggregate raw transaction 
-- data (customers, products, orders, order_items) into actionable clean tables.
-- =================================================================================

-- 1. OVERALL REVENUE TRENDS (Monthly)
-- Purpose: Track month-over-month revenue, total orders, and average order value (AOV).
-- Usable for: Line Chart showing Revenue over Time
SELECT 
    strftime('%Y-%m', o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.total_amount) AS total_revenue,
    SUM(oi.total_amount) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY order_month
ORDER BY order_month;


-- 2. PRODUCT LINE PERFORMANCE
-- Purpose: Analyze which categories and sub-categories are driving the most revenue and margin.
-- Usable for: Bar Chart / Treemap showing Sales by Category and Sub-category
SELECT 
    p.category,
    p.sub_category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.total_amount) AS total_revenue,
    SUM(oi.total_amount) - SUM(p.cost * oi.quantity) AS total_profit,
    (SUM(oi.total_amount) - SUM(p.cost * oi.quantity)) / NULLIF(SUM(oi.total_amount), 0) AS profit_margin
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY p.category, p.sub_category
ORDER BY total_revenue DESC;


-- 3. CUSTOMER COHORT ANALYSIS & LIFETIME VALUE
-- Purpose: Identify high-value customer segments and lifetime value.
-- Usable for: Pie Chart / Donut Chart for Customer segments and LTV metrics
SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(oi.total_amount) AS total_revenue,
    SUM(oi.total_amount) / COUNT(DISTINCT c.customer_id) AS revenue_per_customer
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY c.segment
ORDER BY total_revenue DESC;


-- 4. REGIONAL SALES BREAKDOWN
-- Purpose: Map out geographical revenue hotspots to support shipping & marketing decisions.
-- Usable for: Geolocation Map Visualization (Filterable by Region/State)
SELECT 
    c.region,
    c.state,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.total_amount) AS total_revenue,
    AVG(oi.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY c.region, c.state, c.city
ORDER BY total_revenue DESC;


-- 5. RETURN & CANCELATION RATES
-- Purpose: Track operational inefficiencies by category.
-- Usable for: KPI Cards / Warning Flags for high-return items
SELECT 
    p.category,
    COUNT(DISTINCT CASE WHEN o.order_status = 'Returned' THEN o.order_id END) AS returned_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    (CAST(COUNT(DISTINCT CASE WHEN o.order_status = 'Returned' THEN o.order_id END) AS FLOAT) / 
        COUNT(DISTINCT o.order_id)) * 100 AS return_rate_percent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;
