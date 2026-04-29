# E-Commerce Sales Dashboard

## 📊 Project Overview

A comprehensive 6-week project to build a **real-time business dashboard** for an e-commerce company using **Tableau** or **Power BI**. This dashboard provides executives and regional managers with instant visibility into key business metrics, enabling data-driven decisions.

## 🎯 Business Objectives

- **Eliminate reporting delays**: Replace 10-day delayed PDF reports with real-time dashboards
- **Enable quick analysis**: Executives identify top/bottom performers in <2 minutes
- **Support drill-down**: Regional managers can analyze their specific regions with one click
- **Mobile accessibility**: Dashboard accessible 24/7 on any device

## 📈 Key Metrics

| Metric | Description | Formula |
|--------|-------------|---------|
| **Total Revenue (YTD)** | Year-to-date sales across all regions | SUM(order_amount) |
| **Total Orders (YTD)** | Count of completed orders | COUNT(order_id) |
| **Average Order Value (AOV)** | Average revenue per order | Revenue ÷ Order Count |
| **Customer Count** | Active unique customers | COUNT(DISTINCT customer_id) |

## 🎨 Dashboard Layout

### KPI Cards (Top Row)
- Total Revenue (YTD) with trend vs previous year
- Total Orders (YTD) with trend
- Average Order Value with trend
- Customer Count with trend

### Main Visualizations (Middle Row)
- **Revenue Trend**: Line chart showing daily revenue over last 90 days with weekend highlighting
- **Revenue by Region**: Horizontal bar chart comparing regional performance

### Secondary Visualizations (Bottom Row)
- **Top 10 Products**: Ranked bar chart of products by revenue
- **Order Status Distribution**: Pie chart showing completed/pending/cancelled/returned orders

## 🔍 Interactive Filters

All filters update all visualizations in real-time:

- **Date Range Selector**: Pick custom dates or use presets (Last 7/30/90 days, YTD)
- **Region Filter**: Multi-select to focus on specific regions
- **Category Filter**: Multi-select products by category
- **Status Filter**: Toggle which order statuses to include

## � Dashboard Preview

![Ecommerce Performance Dashboard](dashbordN.pdf)

**Current Dashboard Status**: ✅ Complete
- All 8 visualizations implemented and interactive
- Real-time data filtering across all regions and categories
- Mobile-responsive design for executive accessibility

### Dashboard Highlights
- **Top Performers**: North region leads with $15.9M revenue
- **Product Mix**: Electronics dominates at $31M (highest revenue category)
- **Order Health**: 69.97% orders completed, 15.06% pending, 10.05% cancelled
- **Revenue Trend**: Consistent daily performance with weekend patterns visible

---

## �🗄️ Data Architecture

### Database Schema
```
customers
├── customer_id (PK)
├── customer_name
├── email
├── registration_date
├── region
└── country

orders
├── order_id (PK)
├── customer_id (FK)
├── order_date
├── order_amount
├── status (Completed/Pending/Cancelled/Returned)
└── region

order_items
├── order_item_id (PK)
├── order_id (FK)
├── product_id (FK)
├── quantity
└── unit_price

products
├── product_id (PK)
├── product_name
├── category_id (FK)
├── price
└── supplier_id

categories
├── category_id (PK)
└── category_name
```

### Data Source Options

**Option A: Real Database** (Recommended for learning)
- Connect to existing SQL Server/MySQL/PostgreSQL
- Modify schema to match your database

**Option B: Generated Sample Data**
- Run `generate_synthetic_data.py` to create 50K+ realistic orders
- Includes seasonality and regional patterns
- Import CSV files into database

**Option C: Kaggle Datasets**
- Brazilian E-Commerce: https://www.kaggle.com/olistbr/brazilian-ecommerce
- Online Retail: https://www.kaggle.com/jihyeseo/online-retail-data
- SuperStore Sales: https://www.kaggle.com/rohitsahoo/sales-forecasting

## 📋 Project Tasks

### Week 1-2: SQL Query Development
Write and test 5 SQL queries that power dashboard visualizations:
1. **KPI Summary** - YTD metrics with trend calculations
2. **Daily Revenue Trend** - 90-day trend with weekend flags
3. **Revenue by Region** - Regional performance comparison
4. **Top 10 Products** - Product ranking by revenue
5. **Order Status Distribution** - Status breakdown

See `sql/01_queries.sql` for complete implementation.

### Week 2: Data Connection & Refresh
- Connect dashboard to live database
- Set automatic refresh: Daily at 2:00 AM
- Configure data transformations (day of week, fiscal periods)
- Test refresh schedule

### Week 3-4: Dashboard Visualizations
Build 8 interactive visualizations following design specifications:
- 4 KPI cards with trend indicators
- 4 main charts (trend, regional, products, status)
- Professional formatting and color scheme

### Week 4: Filters & Interactivity
- Date range selector with presets
- Region/Category/Status multi-select filters
- Dashboard-wide filter application
- Filter reset button

### Week 5: Visual Polish
- Professional color palette (5 colors max)
- Consistent typography and spacing
- Brand alignment with company logo
- Mobile responsiveness

### Week 6: Documentation & Publishing
- Complete README and design documentation
- Publish to Tableau Public or Power BI workspace
- Share live links for stakeholder access

## 🚀 Getting Started

### Prerequisites
- SQL knowledge (basic to intermediate)
- Tableau Public (free) or Power BI Desktop (free or license)
- Database with sample data (or run data generator)

### Step 1: Prepare Database
```bash
# Option A: Use existing database
# Modify sql/00_schema.sql to match your schema

# Option B: Generate sample data
python generate_synthetic_data.py
# Then import CSV files into database
```

### Step 2: Set Up Database Connection
**Tableau:**
1. New Data Source → Database → [Your DB Type]
2. Enter connection details
3. Select tables (orders, customers, products, etc.)
4. Test connection

**Power BI:**
1. Get Data → SQL Server (or appropriate database)
2. Enter server and database name
3. Paste queries from `sql/01_queries.sql`
4. Click Load

### Step 3: Create Visualizations
Follow design specifications in `DESIGN_BRIEF.md` for each chart

### Step 4: Add Filters
Implement 4 main filters with multi-select capability

### Step 5: Polish & Publish
- Format colors, fonts, spacing
- Test all filter combinations
- Publish to Tableau Public or Power BI workspace
- Share links

## 📊 Sample Queries

### KPI Summary (1 row)
```sql
SELECT
    SUM(...) AS ytd_revenue,
    COUNT(...) AS ytd_orders,
    ... AS ytd_aov,
    ... AS ytd_customer_count,
    -- Previous year metrics for trends
```

### Daily Revenue Trend (90 rows)
```sql
SELECT
    order_date,
    SUM(order_amount) AS daily_revenue,
    CASE WHEN DAYOFWEEK(order_date) IN (1,7) THEN 'Yes' ELSE 'No' END AS is_weekend,
    ...
FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
```

See `sql/01_queries.sql` for all 5 complete queries.

## 🎨 Design Standards

- **Color Palette**: Primary brand color + 4 supporting colors
- **KPI Font Size**: 24px+ bold
- **Chart Titles**: 16px bold
- **Axis Labels**: 12px regular
- **Number Format**: Currency ($1,234.56), Percentages (15.2%), Counts (1,234)
- **Date Format**: MMM DD, YYYY (e.g., Jan 15, 2024)

## ✅ Success Criteria

### Technical
- [ ] All 4 KPI cards display correct values
- [ ] 4 main visualizations render without errors
- [ ] All 4 filters work independently and together
- [ ] Dashboard refreshes automatically daily
- [ ] Design is responsive (works on mobile/tablet)

### Business
- [ ] Executives can find top performers in <2 minutes
- [ ] Regional drill-down works with single click
- [ ] All metrics validated against source system
- [ ] Professional, on-brand design

### Documentation
- [ ] README explains purpose to non-technical users
- [ ] All SQL queries documented
- [ ] Refresh schedule and SLA documented
- [ ] Design decisions explained

## 📁 Project Structure

```
project-1-dashboard/
├── README.md (this file)
├── DESIGN_BRIEF.md (visualization specifications)
├── DATA_DICTIONARY.md (column definitions)
├── generate_synthetic_data.py (sample data script)
├── sql/
│   ├── 00_schema.sql (database schema)
│   └── 01_queries.sql (dashboard queries)
└── docs/
    ├── IMPLEMENTATION_GUIDE.md
    └── TROUBLESHOOTING.md
```

## 🔧 Technical Stack

- **Database**: MySQL, SQL Server, PostgreSQL, or similar
- **BI Tool**: Tableau Public/Desktop or Power BI Desktop
- **Data Generation**: Python 3.7+
- **Version Control**: Git/GitHub

## 📞 Support & Troubleshooting

**Data Connection Issues?**
- Verify database credentials
- Check firewall/network settings
- Ensure correct database/schema selected
- Review `docs/TROUBLESHOOTING.md`

**Query Problems?**
- Test queries directly in database
- Check date formats (should be YYYY-MM-DD)
- Verify table names match schema
- Review `sql/01_queries.sql` comments

**Dashboard Design Questions?**
- See `DESIGN_BRIEF.md` for visualization specs
- Reference `DATA_DICTIONARY.md` for column definitions

## 📚 Learning Resources

- **Tableau Learning**: https://www.tableau.com/learn/training
- **Power BI Learning**: https://learn.microsoft.com/power-bi/
- **SQL Tutorial**: https://www.w3schools.com/sql/
- **Dashboard Design**: https://www.interaction-design.org/literature/article/information-dashboard-design

## 📅 Timeline

| Week | Task | Hours |
|------|------|-------|
| 1-2 | SQL Query Development | 10 |
| 2 | Data Connection | 4 |
| 3-4 | Visualizations | 12 |
| 4 | Filters & Interactivity | 6 |
| 5 | Visual Polish | 8 |
| 6 | Documentation | 4 |
| **Total** | | **44** |

## 🎓 Learning Outcomes

By completing this project, you'll learn:
- How to design databases for analytics
- Writing complex SQL queries with aggregations
- Data visualization best practices
- Dashboard interactivity and user experience
- Professional documentation
- Stakeholder communication

## 📝 License

This project specification is provided as educational material.

---

**Ready to build? Start with the data generation or database setup, then move to SQL queries!**

Questions? Refer to the documentation files or review the specifications in the PROJECT_1_DASHBOARD_SPECIFICATION.md file.
