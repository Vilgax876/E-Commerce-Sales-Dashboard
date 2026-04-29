# PROJECT 1: REAL-TIME BUSINESS DASHBOARD
## Problem Statement & Task Breakdown

**Timeline:** 6 weeks | **Skill Level:** Mid-level | **Tools:** Tableau/Power BI + SQL

---

## BUSINESS PROBLEM

### Scenario
You are hired as a Business Analyst for an **E-Commerce Company** (or SaaS, Retail - pick your theme). The executive leadership team and regional managers need **real-time visibility** into business performance across multiple dimensions. Currently, they receive monthly PDF reports that arrive 10 days into the next month, making it impossible to react quickly to trends.

### The Challenge
- **Problem**: Decision-makers lack real-time insights into key business metrics
- **Impact**: Late interventions, missed opportunities, slow response to performance dips
- **Opportunity**: Build an interactive dashboard that enables data-driven decisions within minutes, not weeks

### Success Metrics
- Dashboard available 24/7 with auto-refresh capability
- Executive can identify top/bottom performers within 2 minutes
- Drill-down capability enables root cause analysis without requesting custom reports
- Mobile-friendly design for on-the-go access

---

## YOUR ROLE
You are the Data Analyst responsible for:
1. Understanding what metrics matter most to the business
2. Extracting and transforming data via SQL
3. Designing an intuitive, professional dashboard
4. Documenting the solution for stakeholders

---

## TECHNICAL REQUIREMENTS

### Data Source
**Option A (Recommended):** E-Commerce Database
- **Tables:** customers, orders, order_items, products, categories
- **Time Period:** Last 24 months of data
- **Volume:** 50K+ orders, 10K+ customers

**Option B:** Use Kaggle Datasets
- Brazilian E-Commerce (olist): https://www.kaggle.com/olistbr/brazilian-ecommerce
- Online Retail: https://www.kaggle.com/jihyeseo/online-retail-data
- SuperStore Sales: https://www.kaggle.com/rohitsahoo/sales-forecasting

**Option C:** Generate Sample Data
- Use SQL to CREATE and INSERT sample data matching business logic
- Minimum 50K transactions over 24 months
- Include realistic patterns (seasonality, regional variation)

### Database Setup
```sql
-- Minimum schema required
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(255),
    registration_date DATE,
    region VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    status VARCHAR(50),
    region VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category_id INT,
    price DECIMAL(10,2),
    supplier_id INT
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);
```

---

## DASHBOARD SPECIFICATIONS

### Page Layout: Single-Page Dashboard (5 Visualizations Minimum)

**KPI Cards (Top Row - 4 Cards)**
1. **Total Revenue (YTD)** - Large number with trend indicator (↑/↓ % vs last period)
2. **Total Orders (YTD)** - Large number with trend indicator
3. **Average Order Value (AOV)** - Large number, trend indicator
4. **Customer Count** - Active customers, trend indicator

**Main Visualizations (Second Row - 2 Charts)**
5. **Revenue Trend** - Line chart showing daily/weekly revenue over last 90 days
   - X-axis: Date
   - Y-axis: Revenue
   - Color: Distinguish weekends vs weekdays
   - Interactivity: Hover to see exact values

6. **Sales by Region** - Horizontal bar chart
   - Bars: Regions (North, South, East, West, etc.)
   - Values: Total revenue per region
   - Color gradient: Higher revenue = darker color
   - Interactivity: Click to filter entire dashboard

**Secondary Visualizations (Third Row - 2 Charts)**
7. **Top 10 Products by Revenue** - Vertical bar chart or sorted table
   - Products on Y-axis
   - Revenue on X-axis
   - Sorted descending

8. **Order Status Distribution** - Pie/Donut chart
   - Categories: Completed, Pending, Cancelled, Returned
   - Show count and percentage
   - Color code by status (Green=Completed, Yellow=Pending, Red=Cancelled)

**Interactive Filters (Left Sidebar or Top)**
- **Date Range Selector** - From/To date picker (default: Last 90 days)
- **Region Filter** - Multi-select dropdown (all regions enabled by default)
- **Product Category Filter** - Multi-select dropdown
- **Status Filter** - Checkboxes for order status

---

## SPECIFIC TASKS TO COMPLETE

### TASK 1: Data Extraction via SQL (Week 1-2)
**Objective:** Write 5 SQL queries that power your dashboard visualizations

**Query 1: KPI Summary Query**
```
Write a query that returns:
- Total revenue (YTD)
- Total orders (YTD)
- Average order value
- Unique customer count
- Revenue last period (previous year or month)
- Orders last period
- AOV last period
- Customer count last period

Purpose: Powers 4 KPI cards with trend calculations
Expected output: 1 row with 8 columns
```

**Query 2: Daily Revenue Trend (Last 90 Days)**
```
Write a query that returns:
- Order_date
- Total revenue for that date
- Is_weekend (yes/no flag)
- Running total (cumulative revenue)

Purpose: Powers revenue trend line chart
Expected output: ~90 rows
Sorting: By date ascending
```

**Query 3: Revenue by Region**
```
Write a query that returns:
- Region name
- Total revenue
- Order count
- Average order value

Purpose: Powers region bar chart and allows filtering
Expected output: 4-8 rows (one per region)
Sorting: Revenue descending
```

**Query 4: Top 10 Products**
```
Write a query that returns:
- Product ID
- Product name
- Category
- Total revenue
- Units sold
- Rank

Purpose: Powers top products chart
Expected output: Top 10 rows
Sorting: Revenue descending
```

**Query 5: Order Status Distribution**
```
Write a query that returns:
- Order status
- Count of orders
- Percentage of total
- Revenue by status

Purpose: Powers status pie chart
Expected output: 4 rows (Completed, Pending, Cancelled, Returned)
```

**Deliverable:** `/project-1-dashboard/queries.sql` file with all 5 queries documented

---

### TASK 2: Data Connection & Refresh Strategy (Week 2)

**Objective:** Connect dashboard to live data with automated refresh

**Subtask 2A: Connect Data Source**
- If using Tableau:
  - Create new data source → Database connection (SQL Server/MySQL/PostgreSQL)
  - Enter database credentials
  - Select tables for import
  - Test connection (verify data loads)

- If using Power BI:
  - Get Data → SQL Server/MySQL/Other database
  - Enter query directly (paste from queries.sql)
  - Set refresh schedule (hourly/daily)
  - Test refresh

**Subtask 2B: Data Transformation**
- Create calculated fields for:
  - Day of week (for weekend flag)
  - Month (for period-over-period)
  - Quarter (for YTD calculations)
  - Revenue category (Low/Medium/High based on AOV)

**Subtask 2C: Refresh Configuration**
- Set automatic refresh schedule: **Daily at 2 AM** (or your preference)
- Test manual refresh works
- Document refresh SLA in README

**Deliverable:** Dashboard connected to live data with refresh schedule documented

---

### TASK 3: Design & Build Dashboard Visualizations (Week 3-4)

**Objective:** Create 8 professional, interactive visualizations

**Visualization 1: Revenue KPI Card**
- Display: Large font (24px+)
- Format: Currency ($2.5M)
- Trend: Show % change vs previous period + arrow
- Color: Green if up, Red if down
- Tooltip: Show exact YTD and previous period values

**Visualization 2: Orders KPI Card**
- Display: Large font (24px+)
- Format: Number with thousands separator (125,430)
- Trend: % change vs previous period
- Color: Green if up, Red if down

**Visualization 3: AOV KPI Card**
- Display: Large font (24px+)
- Format: Currency ($125.50)
- Trend: % change vs previous period
- Color: Green if up, Red if down

**Visualization 4: Customer Count KPI Card**
- Display: Large font (24px+)
- Format: Number (28,450)
- Trend: % change vs previous period
- Color: Green if up, Red if down

**Visualization 5: Revenue Trend Line Chart**
- X-axis: Date (auto-formatted)
- Y-axis: Revenue
- Line color: Solid blue or brand color
- Weekend shading: Light gray background for weekends
- Interactivity: Hover to show exact date and revenue
- Tooltip format: "Monday, Feb 15: $125,430"
- Allow zoom/pan (last 7 days, 30 days, 90 days)

**Visualization 6: Revenue by Region Bar Chart**
- Orientation: Horizontal bars (easier to read region names)
- Colors: Gradient from light to dark (ascending by revenue)
- Data labels: Show revenue amount on each bar
- Interactivity: **Click bar to filter all other charts by that region**
- Sort: Revenue descending
- Include legend showing scale

**Visualization 7: Top 10 Products Chart**
- Type: Sorted bar chart (vertical or horizontal)
- Colors: Color by category (different color per category)
- Data labels: Show revenue amount on each bar
- Interactivity: Hover to see units sold and AOV
- Include rank (1-10) as label
- Tooltip format: "Product: [Name] | Revenue: $X | Units: Y"

**Visualization 8: Order Status Distribution Pie Chart**
- Colors: 
  - Completed = Green (#2DA65C)
  - Pending = Yellow (#F5A623)
  - Cancelled = Red (#D0021B)
  - Returned = Gray (#999999)
- Show percentage labels on slices
- Show count in legend
- Interactivity: Click to highlight that status
- Tooltip: "Status: [Name] | Count: X | % of Total: Y%"

---

### TASK 4: Filters & Interactivity (Week 4)

**Objective:** Enable users to drill down and explore data dynamically

**Filter 1: Date Range Selector**
- Type: Date picker (From/To)
- Default: Last 90 days
- Apply to: All visualizations
- Interaction: When changed, all charts update immediately
- Allow preset buttons: "Last 7 Days", "Last 30 Days", "Last 90 Days", "YTD", "Custom"

**Filter 2: Region Filter**
- Type: Multi-select dropdown or checkbox list
- Options: North, South, East, West
- Default: All regions selected
- Apply to: All visualizations except Product chart
- Interaction: Selecting a region filters all charts
- Show selected count badge

**Filter 3: Product Category Filter**
- Type: Multi-select dropdown
- Options: Electronics, Clothing, Home, Sports, Books (adjust to your data)
- Default: All categories
- Apply to: Revenue charts, Product chart
- Interaction: Filters relevant visualizations
- Show selected count

**Filter 4: Order Status Filter**
- Type: Checkboxes
- Options: Completed, Pending, Cancelled, Returned
- Default: All selected
- Apply to: All visualizations
- Interaction: Unchecking a status removes those orders from calculations
- Shows count per status

**Filter Reset Button**
- Clears all filters to default state
- One-click action

---

### TASK 5: Visual Design & Polish (Week 5)

**Objective:** Create a professional, brand-aligned dashboard

**Design Guidelines:**
- **Color Palette:** 
  - Primary: Your brand color (or use professional blue #1f77b4)
  - Accent: Orange or teal for highlights
  - Neutral: Light gray for backgrounds, dark gray for text
  - Avoid: Rainbow colors, neon, more than 5 colors total

- **Typography:**
  - Headers: Bold, 18px+
  - KPI values: Bold, 24px+
  - Axis labels: Regular, 12px
  - Tooltips: Regular, 11px

- **Layout:**
  - Balanced: Equal whitespace between visualizations
  - Grid alignment: All charts aligned to invisible grid
  - Consistent sizing: Similar charts have similar dimensions
  - Top to bottom: Most important metrics at top

- **Formatting:**
  - All currency: Use $ and 2 decimals ($1,234.56)
  - All percentages: Show one decimal (15.2%)
  - All counts: Use thousands separator (1,234)
  - All dates: Consistent format (MMM DD, YYYY)

**Branding:**
- Add company logo in top-left corner
- Add dashboard title: "[Company Name] - Sales Performance Dashboard"
- Add last refresh timestamp
- Add data source attribution

---

### TASK 6: Documentation & Publishing (Week 6)

**Objective:** Document and publish for production use

**Documentation to Create:**

**File 1: README.md**
```
# E-Commerce Sales Dashboard

## Overview
Real-time dashboard providing visibility into sales performance, customer metrics, and regional trends.

## Purpose
Enable executives and regional managers to:
- Monitor revenue and order trends
- Identify top-performing regions and products
- Detect performance issues quickly
- Make data-driven decisions

## Key Metrics
- **Total Revenue (YTD):** Year-to-date sales across all regions
- **Total Orders:** Order count with trend vs previous period
- **AOV:** Average order value (revenue / orders)
- **Customer Count:** Active unique customers

## Visualizations
1. Revenue Trend (90-day line chart)
2. Revenue by Region (bar chart)
3. Top 10 Products (ranked bar chart)
4. Order Status Distribution (pie chart)

## Filters
- Date Range (date picker)
- Region (multi-select)
- Category (multi-select)
- Status (checkboxes)

## Data Source
Database: [Database name]
Refresh Schedule: Daily at 2:00 AM
Last Refresh: [Auto-populated timestamp]

## Access
- Tableau: [Public link]
- Power BI: [Workspace link]

## Support
For issues or feature requests, contact: [Your email]
```

**File 2: Design Brief**
```
## Design Decisions

### KPI Cards
- Placed at top for immediate visibility
- Large font emphasizes importance
- Trend indicators enable quick assessment

### Revenue Trend Chart
- Line chart shows temporal patterns
- 90-day window balances detail and trend visibility
- Weekend shading identifies weekly patterns

### Regional Breakdown
- Horizontal bar chart for easier region name reading
- Color gradient enables quick comparison
- Click-to-filter enables drill-down analysis

### Status Distribution
- Pie chart shows proportion of order states
- Color coding aligns with common UX conventions
- Helps identify process bottlenecks

### Filters
- Date range at top for chronological focus
- Region/category/status as secondary filters
- Multi-select enables complex analysis without dashboard redesign
```

**File 3: Data Dictionary**
```
| Column | Definition | Format | Source |
|--------|-----------|--------|--------|
| order_id | Unique identifier for order | Integer | Orders table |
| order_date | Date order was placed | YYYY-MM-DD | Orders table |
| order_amount | Total revenue from order | Currency | Orders table |
| region | Geographic region | Text | Orders table |
| status | Current order status | Text | Orders table |
| customer_id | Unique customer identifier | Integer | Customers table |
| product_id | Unique product identifier | Integer | Products table |
| category | Product category | Text | Categories table |
```

**Publishing Steps:**

If using Tableau Public:
1. Save workbook
2. Tableau menu → Server → Tableau Public → Save As
3. Sign into Tableau Public account
4. Choose visibility (public or private with link)
5. Copy public link
6. Add to GitHub README

If using Power BI:
1. File → Publish
2. Select workspace
3. Configure sharing settings
4. Copy report link
5. Add to GitHub README

---

## DELIVERABLES CHECKLIST

- [ ] SQL queries file (queries.sql) with all 5 queries documented
- [ ] Live dashboard link (Tableau Public or Power BI)
- [ ] README.md explaining dashboard purpose and usage
- [ ] Design Brief explaining visualization choices
- [ ] Data Dictionary documenting all columns
- [ ] Dashboard screenshot (PNG) for GitHub
- [ ] GitHub repo with all documentation

---

## SUCCESS CRITERIA

**Technical:**
- ✅ All 4 KPI cards display correct values with trends
- ✅ 4 main visualizations load without errors
- ✅ All 4 filters work independently and together
- ✅ Dashboard refreshes automatically daily
- ✅ Responsive design works on mobile/tablet

**Business:**
- ✅ Executives can identify top performers in <2 minutes
- ✅ Regional managers can drill down to their region in <1 click
- ✅ All metrics match source system (validated via spot-check)
- ✅ Design is professional and on-brand

**Documentation:**
- ✅ README explains purpose clearly to non-technical stakeholders
- ✅ All calculations documented in queries
- ✅ Refresh schedule and SLA documented
- ✅ Design decisions explained in Design Brief

---

## ESTIMATED EFFORT BREAKDOWN

| Task | Week(s) | Hours |
|------|---------|-------|
| SQL Query Development | 1-2 | 10 |
| Data Connection & Refresh | 2 | 4 |
| Visualization Design | 3-4 | 12 |
| Filters & Interactivity | 4 | 6 |
| Visual Polish & Branding | 5 | 8 |
| Documentation & Publishing | 6 | 4 |
| **TOTAL** | **6 weeks** | **44 hours** |

---

## TIPS FOR SUCCESS

1. **Start with SQL queries first** - Know your data before designing visualizations
2. **Use a sample region initially** - Build for one region, then scale to all
3. **Get feedback early** - Show prototype to friend/mentor before final polish
4. **Test filters thoroughly** - Click every combination to ensure no broken states
5. **Document as you go** - Don't leave documentation to the end
6. **Version your work** - Use GitHub commits to track progress

---

## Next Steps

1. **Week 1:** Set up database and write all 5 SQL queries
2. **Week 2:** Connect dashboard to data and test refresh
3. **Week 3-4:** Build visualizations following specifications
4. **Week 5:** Polish design and implement all filters
5. **Week 6:** Document everything and publish

**Ready to start? Choose Tableau or Power BI and begin with SQL queries!**
