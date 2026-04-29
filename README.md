# Data Analytics Portfolio

A comprehensive collection of projects demonstrating data analysis, SQL, and business intelligence skills.

## 🎯 Project 1: E-Commerce Real-Time Sales Dashboard

**Status**: Ready to Build | **Difficulty**: Mid-level | **Timeline**: 6 weeks | **Skills**: SQL + Tableau/Power BI

### Overview
Build a professional real-time dashboard for an e-commerce company that provides executives with instant visibility into key business metrics (revenue, orders, AOV, customer count). Replace slow PDF reports with interactive visualizations enabling data-driven decisions in minutes, not weeks.

### Quick Start

1. **Read the Specification**
   - Start with: [PROJECT_1_DASHBOARD_SPECIFICATION.md](PROJECT_1_DASHBOARD_SPECIFICATION.md)
   - Understand the business problem and requirements

2. **Follow the Step-by-Step Guide**
   - [STEP_BY_STEP_EXECUTION.md](STEP_BY_STEP_EXECUTION.md)
   - Detailed week-by-week breakdown with specific tasks

3. **Explore Project Files**
   - [project-1-dashboard/README.md](project-1-dashboard/README.md) - Project overview
   - [project-1-dashboard/sql/](project-1-dashboard/sql/) - Database schema & queries
   - [project-1-dashboard/docs/](project-1-dashboard/docs/) - Design brief & data dictionary

### Key Deliverables

| Deliverable | Status | Location |
|-------------|--------|----------|
| Database Schema | ✓ Created | [00_schema.sql](project-1-dashboard/sql/00_schema.sql) |
| 5 SQL Queries | ✓ Created | [01_queries.sql](project-1-dashboard/sql/01_queries.sql) |
| Sample Data Generator | ✓ Created | [generate_synthetic_data.py](project-1-dashboard/generate_synthetic_data.py) |
| Project Documentation | ✓ Created | [README.md](project-1-dashboard/README.md) |
| Design Specifications | ✓ Created | [DESIGN_BRIEF.md](project-1-dashboard/docs/DESIGN_BRIEF.md) |
| Data Dictionary | ✓ Created | [DATA_DICTIONARY.md](project-1-dashboard/docs/DATA_DICTIONARY.md) |
| Execution Guide | ✓ Created | [STEP_BY_STEP_EXECUTION.md](STEP_BY_STEP_EXECUTION.md) |
| Dashboard (Tableau/Power BI) | ⏳ To Build | See step-by-step guide Week 3-4 |
| Published Dashboard Link | ⏳ To Add | After Week 6 |

### Dashboard Features

**4 KPI Cards:**
- Total Revenue (YTD) with trend
- Total Orders with trend
- Average Order Value with trend
- Customer Count with trend

**4 Main Visualizations:**
- Revenue Trend (90-day line chart)
- Revenue by Region (bar chart)
- Top 10 Products (ranked chart)
- Order Status Distribution (pie chart)

**4 Interactive Filters:**
- Date Range (with presets)
- Region (multi-select)
- Product Category (multi-select)
- Order Status (checkboxes)

### Project Structure

```
data-analytics-portfolio/
├── README.md (this file)
├── PROJECT_1_DASHBOARD_SPECIFICATION.md (full specification)
├── STEP_BY_STEP_EXECUTION.md (execution guide)
└── project-1-dashboard/
    ├── README.md (project overview)
    ├── generate_synthetic_data.py (sample data generator)
    ├── sql/
    │   ├── 00_schema.sql (database schema)
    │   └── 01_queries.sql (5 dashboard queries)
    └── docs/
        ├── DESIGN_BRIEF.md (visualization specifications)
        └── DATA_DICTIONARY.md (column definitions)
```

### Data Architecture

**Database Tables:**
- `customers` - Customer information (10K records)
- `orders` - Order transactions (50K+ records)
- `order_items` - Line items per order
- `products` - Product catalog (500 products)
- `categories` - Product categories (5 categories)

**Data Coverage:**
- 24 months of historical data
- 4 geographic regions (North, South, East, West)
- 5 product categories (Electronics, Clothing, Home, Sports, Books)
- 4 order statuses (Completed, Pending, Cancelled, Returned)

### Getting Started

**Step 1: Understand the Project** (1-2 hours)
```
Read PROJECT_1_DASHBOARD_SPECIFICATION.md
↓
Review STEP_BY_STEP_EXECUTION.md
↓
Understand your role as Data Analyst
```

**Step 2: Set Up Database** (1-2 hours)
```
Option A: Use existing database
Option B: Generate sample data using Python
Option C: Import Kaggle dataset
↓
Run schema.sql
↓
Load data into database
```

**Step 3: Develop SQL Queries** (8-10 hours)
```
Write 5 queries (one per visualization)
Test each query independently
Verify output matches specifications
Document results
```

**Step 4: Build Visualizations** (12 hours)
```
Choose: Tableau or Power BI
Create 4 KPI cards
Create 4 main charts
Test all visualizations
```

**Step 5: Add Interactivity** (6 hours)
```
Add date range filter
Add region filter
Add category filter
Add status filter
Test all combinations
```

**Step 6: Polish & Document** (4-8 hours)
```
Apply color scheme
Format numbers consistently
Add professional branding
Document everything
Publish dashboard
```

### Estimated Effort

| Phase | Hours |
|-------|-------|
| Planning & Setup | 2-4 |
| SQL Development | 10 |
| Database Setup | 4 |
| Dashboard Build | 12 |
| Filters & Polish | 8 |
| Documentation | 4 |
| **TOTAL** | **40-44** |

### Success Criteria

✓ **Technical:**
- Database schema created with 5 tables
- 5 SQL queries written and tested
- All KPI calculations correct
- All visualizations render
- All filters functional
- Dashboard auto-refreshes daily

✓ **Business:**
- Executives can find top performers in <2 minutes
- Regional drill-down works with single click
- All metrics validated against source
- Professional, polished design

✓ **Documentation:**
- README explains purpose to non-technical users
- All SQL queries documented
- Design decisions explained
- Data dictionary complete
- GitHub repository organized

### Tools Required

- **Database**: MySQL, SQL Server, PostgreSQL, or equivalent
  - MySQL Workbench (free)
  - SQL Server Management Studio (free)
  - pgAdmin (free)

- **BI Tool**: 
  - Tableau Public (free) - https://public.tableau.com/
  - Power BI Desktop (free) - https://powerbi.microsoft.com/

- **Python** (for sample data):
  - Python 3.7+
  - pandas library (`pip install pandas`)

### Learning Outcomes

By completing this project, you'll learn:
- Database design for analytics
- Complex SQL with aggregations and window functions
- Data visualization best practices
- Dashboard interactivity and filters
- Professional documentation
- Portfolio presentation

### Interview Talking Points

After completing this project, you can discuss:
- "I built a real-time dashboard that reduced report generation from 10 days to real-time"
- "I designed a database schema with 5 tables optimized for analytics"
- "I wrote 5 SQL queries handling edge cases like seasonal trends and regional variations"
- "I implemented interactive filters enabling users to drill down without requesting custom reports"
- "I followed design best practices including color theory, typography, and responsive layout"

### Files to Read First

1. **[PROJECT_1_DASHBOARD_SPECIFICATION.md](PROJECT_1_DASHBOARD_SPECIFICATION.md)** - Complete project specification
2. **[STEP_BY_STEP_EXECUTION.md](STEP_BY_STEP_EXECUTION.md)** - Week-by-week execution plan
3. **[project-1-dashboard/README.md](project-1-dashboard/README.md)** - Project overview

### Next Steps

1. ✓ Read the full specification
2. ✓ Follow the step-by-step guide
3. ✓ Build the dashboard
4. ✓ Document your work
5. ✓ Publish to portfolio
6. ✓ Share on LinkedIn/GitHub

### Contact & Support

Questions?
- Review the documentation files
- Check the troubleshooting section in STEP_BY_STEP_EXECUTION.md
- Refer to DATA_DICTIONARY.md for column definitions
- Review DESIGN_BRIEF.md for visualization specifications

---

## 📊 Future Projects

This is **Project 1** of a multi-project portfolio. Future projects will include:
- Project 2: Customer Segmentation Analysis
- Project 3: Sales Forecasting Model
- Project 4: Marketing Attribution Analysis
- Project 5: Product Performance Deep Dive

---

**Last Updated**: April 25, 2026

**Ready to build? Start with [PROJECT_1_DASHBOARD_SPECIFICATION.md](PROJECT_1_DASHBOARD_SPECIFICATION.md)!**
