# Dashboard Build Guide: Step-by-Step Instructions

## Overview
This guide walks you through building each of the 8 visualizations in your real-time business dashboard. Follow these steps in order for Tableau or Power BI.

---

# SECTION 1: KPI CARDS (Top Row - 4 Visualizations)

## Visualization 1: Total Revenue (YTD) Card

### Visual Type
- **Tableau:** Number with trend indicator (Big Number card)
- **Power BI:** Card or Multi-row Card visual

### Fields to Add

| Field | Role | Source Query |
|-------|------|--------------|
| `total_revenue_ytd` | Value/Display | Query 1: KPI Summary |
| `total_revenue_previous_period` | For calculation | Query 1: KPI Summary |
| `revenue_trend_percent` | Indicator | Calculated field |

### Step-by-Step Instructions

#### For Tableau:

1. **Create data source** from Query 1 (KPI Summary query)
2. **Drag to canvas:**
   - Right-click → Create calculated field → Name: `Revenue Trend %`
   - Formula: `(([total_revenue_ytd] - [total_revenue_previous_period]) / [total_revenue_previous_period]) * 100`
3. **Build the card:**
   - Drag `total_revenue_ytd` to the canvas
   - Change to "Big Number" view
   - Add `Revenue Trend %` as a secondary value
   - Format numbers: 
     - Currency with 2 decimals: `$2.5M` or `$2,543,210`
     - Trend: Show % with arrow (↑/↓)
4. **Color conditional formatting:**
   - Right-click field → Format
   - Set color to Green if trend > 0, Red if < 0
5. **Add title:** "Total Revenue (YTD)"

#### For Power BI:

1. **Create measure:**
   ```DAX
   Total Revenue YTD = SUM([order_amount])
   
   Revenue Trend % = 
   VAR CurrentYTD = [Total Revenue YTD]
   VAR PreviousPeriod = CALCULATE([Total Revenue YTD], DATEADD(DATES[Date], -12, MONTH))
   RETURN ((CurrentYTD - PreviousPeriod) / PreviousPeriod) * 100
   ```

2. **Add Card visual:**
   - Drag `Total Revenue YTD` measure to the canvas
   - Right-click → Change visual type → Card
   - Set data label to currency format
   - Set size: Large

3. **Add trend indicator:**
   - Add `Revenue Trend %` as KPI indicator
   - Set good direction to "Up"
   - Format as percentage

4. **Card settings:**
   - Title: "Total Revenue (YTD)"
   - Category labels: On

---

## Visualization 2: Total Orders (YTD) Card

### Visual Type
- **Tableau:** Big Number card with trend
- **Power BI:** Card visual with indicator

### Fields to Add

| Field | Role |
|-------|------|
| `total_orders_ytd` | Value |
| `total_orders_previous_period` | For trend calculation |
| `orders_trend_percent` | Indicator |

### Step-by-Step Instructions

#### For Tableau:

1. **Create calculated field:**
   ```
   Orders Trend % = 
   (([total_orders_ytd] - [total_orders_previous_period]) / [total_orders_previous_period]) * 100
   ```

2. **Drag to canvas:**
   - `total_orders_ytd` as Big Number
   - Add `Orders Trend %` as secondary value

3. **Format:**
   - Number format: `125,430` (thousands separator)
   - Color: Green if up, Red if down
   - Title: "Total Orders (YTD)"

#### For Power BI:

1. **Create measures:**
   ```DAX
   Total Orders YTD = DISTINCTCOUNT([order_id])
   
   Orders Trend % = 
   VAR CurrentOrders = [Total Orders YTD]
   VAR PreviousOrders = CALCULATE([Total Orders YTD], DATEADD(DATES[Date], -12, MONTH))
   RETURN ((CurrentOrders - PreviousOrders) / PreviousOrders) * 100
   ```

2. **Add Card visual:**
   - Drag `Total Orders YTD` to canvas
   - Format as number (no decimals)
   - Add trend KPI
   - Title: "Total Orders (YTD)"

---

## Visualization 3: Average Order Value (AOV) Card

### Visual Type
- **Tableau:** Big Number card
- **Power BI:** Card visual

### Fields to Add

| Field | Role |
|-------|------|
| `aov_ytd` | Value |
| `aov_previous_period` | For trend |
| `aov_trend_percent` | Indicator |

### Step-by-Step Instructions

#### For Tableau:

1. **Create calculated field:**
   ```
   AOV YTD = [total_revenue_ytd] / [total_orders_ytd]
   AOV Trend % = (([aov_ytd] - [aov_previous_period]) / [aov_previous_period]) * 100
   ```

2. **Add to canvas:**
   - Drag `AOV YTD` as Big Number
   - Add trend % as secondary display

3. **Format:**
   - Currency format: `$125.50`
   - 2 decimal places
   - Color: Green up, Red down
   - Title: "Average Order Value"

#### For Power BI:

1. **Create measures:**
   ```DAX
   AOV YTD = DIVIDE([Total Revenue YTD], [Total Orders YTD], 0)
   
   AOV Trend % = 
   VAR CurrentAOV = [AOV YTD]
   VAR PreviousAOV = CALCULATE([AOV YTD], DATEADD(DATES[Date], -12, MONTH))
   RETURN DIVIDE(CurrentAOV - PreviousAOV, PreviousAOV, 0) * 100
   ```

2. **Add Card visual:**
   - Drag `AOV YTD` to canvas
   - Format as currency ($)
   - Add trend KPI
   - Title: "Average Order Value"

---

## Visualization 4: Customer Count Card

### Visual Type
- **Tableau:** Big Number card
- **Power BI:** Card visual

### Fields to Add

| Field | Role |
|-------|------|
| `unique_customer_count` | Value |
| `unique_customers_previous` | For trend |
| `customer_trend_percent` | Indicator |

### Step-by-Step Instructions

#### For Tableau:

1. **Create calculated fields:**
   ```
   Unique Customers YTD = COUNTDISTINCT([customer_id])
   Customer Trend % = (([unique_customers_ytd] - [unique_customers_previous]) / [unique_customers_previous]) * 100
   ```

2. **Add to canvas:**
   - Drag `Unique Customers YTD` as Big Number
   - Add trend % indicator

3. **Format:**
   - Number format with thousands separator: `28,450`
   - Color: Green up, Red down
   - Title: "Active Customers"

#### For Power BI:

1. **Create measures:**
   ```DAX
   Unique Customers = DISTINCTCOUNT([customer_id])
   
   Customer Trend % = 
   VAR CurrentCustomers = [Unique Customers]
   VAR PreviousCustomers = CALCULATE([Unique Customers], DATEADD(DATES[Date], -12, MONTH))
   RETURN DIVIDE(CurrentCustomers - PreviousCustomers, PreviousCustomers, 0) * 100
   ```

2. **Add Card visual:**
   - Drag `Unique Customers` to canvas
   - Format as number
   - Add trend KPI
   - Title: "Active Customers"

---

# SECTION 2: MAIN VISUALIZATIONS (Middle Row - 2 Charts)

## Visualization 5: Revenue Trend Line Chart

### Visual Type
- **Tableau:** Line chart (dual axis option)
- **Power BI:** Line & Stacked Column Chart

### Fields to Add

| Field | Role | Placement |
|-------|------|-----------|
| `order_date` | X-axis | Columns |
| `total_revenue` | Y-axis (Line) | Values |
| `is_weekend` | Background shading | Detail/Shape |
| Running total revenue | Secondary Y-axis (Optional) | Values |

### Step-by-Step Instructions

#### For Tableau:

1. **Create data source** from Query 2: Daily Revenue Trend

2. **Build the chart:**
   - Drag `order_date` to Columns shelf → Change to "Continuous Date"
   - Drag `total_revenue` to Rows shelf → Change to "Line" chart type
   - Drag `is_weekend` to Details

3. **Add running total (optional):**
   - Create calculated field:
     ```
     Running Revenue = RUNNING_SUM(SUM([total_revenue]))
     ```
   - Drag to Rows as secondary line
   - Right-click → Dual Axis

4. **Format:**
   - **Line color:** Solid blue (#1f77b4) or brand color
   - **Weekend shading:** 
     - Create calculated field: `Weekend = IF([is_weekend] = 'Yes' THEN 1 ELSE 0 END`
     - Add to Background color
     - Set light gray for weekends
   - **Tooltips:**
     - Right-click → Edit tooltip
     - Include: `Date: <order_date> | Revenue: <total_revenue>`
     - Remove "SUM" labels if showing
   - **Axis labels:**
     - X-axis: Date format (Jan 01, Jan 02...)
     - Y-axis: Currency ($0K, $100K, $200K...)
   - **Title:** "Daily Revenue Trend (Last 90 Days)"

5. **Add zoom/filter:**
   - Right-click date axis → Add date filter
   - Create filter buttons: "Last 7 Days", "Last 30 Days", "Last 90 Days"

#### For Power BI:

1. **Prepare data:**
   - Ensure your data has a Date table with is_weekend flag
   - Create measures:
   ```DAX
   Daily Revenue = SUM([order_amount])
   
   Running Revenue = 
   CALCULATE(
     [Daily Revenue],
     FILTER(
       ALL(Dates[Date]),
       Dates[Date] <= MAX(Dates[Date])
     )
   )
   ```

2. **Add Line Chart visual:**
   - Drag `Date` (continuous) to X-axis
   - Drag `Daily Revenue` to Y-values
   - Drag `is_weekend` to Data color
   - Add `Running Revenue` as secondary axis (optional)

3. **Format:**
   - **Data labels:** On (show revenue values)
   - **Legend:** Show weekend colors
   - **Tooltip:**
     - Show all fields
     - Add custom formatting
   - **X-axis:**
     - Format: Date (Jan 1, Jan 2...)
     - Title: "Date"
   - **Y-axis:**
     - Format: Currency
     - Title: "Revenue"
   - **Title:** "Daily Revenue Trend (Last 90 Days)"

4. **Colors:**
   - Weekend (is_weekend = Yes) → Light gray (#F0F0F0)
   - Weekday (is_weekend = No) → Transparent

---

## Visualization 6: Revenue by Region Bar Chart

### Visual Type
- **Tableau:** Horizontal bar chart (sorted)
- **Power BI:** Horizontal Bar Chart

### Fields to Add

| Field | Role | Placement |
|-------|------|-----------|
| `region` | Y-axis | Rows |
| `total_revenue` | X-axis | Values |
| `order_count` | Size/tooltip | Tooltip |
| `average_order_value` | Tooltip | Tooltip |

### Step-by-Step Instructions

#### For Tableau:

1. **Create data source** from Query 3: Revenue by Region

2. **Build the chart:**
   - Drag `region` to Rows shelf
   - Drag `total_revenue` to Columns shelf
   - Change to "Horizontal Bar" chart (automatic)
   - Sort descending by revenue:
     - Click the sort button or right-click `region` → Sort → Descending by Revenue

3. **Add color gradient:**
   - Drag `total_revenue` to Color shelf
   - Right-click → Edit Colors
   - Choose gradient: Light (low revenue) → Dark (high revenue)
   - Palette: Blue or your brand color

4. **Add data labels:**
   - Right-click Columns shelf → Show data labels
   - Format as currency: `$2.5M`

5. **Add tooltips:**
   - Double-click the chart to edit tooltip
   - Include fields:
     ```
     Region: <region>
     Revenue: <total_revenue>
     Orders: <order_count>
     AOV: <average_order_value>
     ```

6. **Add interactivity (Click to filter):**
   - Create action: Dashboard → New action → Filter
   - Source: This chart, Target: All other charts
   - Select on click

7. **Format:**
   - Remove gridlines or make light
   - Add legend showing color scale
   - Title: "Revenue by Region"

#### For Power BI:

1. **Prepare measures:**
   ```DAX
   Total Revenue by Region = SUM([order_amount])
   Order Count = DISTINCTCOUNT([order_id])
   Average Order Value = DIVIDE([Total Revenue by Region], [Order Count], 0)
   ```

2. **Add Horizontal Bar Chart:**
   - Drag `region` to Y-axis
   - Drag `total_revenue` to X-values
   - Drag `total_revenue` to Data color (for gradient)

3. **Format:**
   - **Sorting:** Sort by X-axis values descending
   - **Data labels:** On, show values as currency
   - **Legend:** Off
   - **Color saturation:** Gradient from light to dark
   - **Tooltip:**
     - Add `order_count`
     - Add `average_order_value`
     - Format values appropriately
   - **Title:** "Revenue by Region"

4. **Add drill-through (Click to filter):**
   - Select the chart
   - Turn on "Drill through" page
   - Set field: `region`
   - Link to detail page showing regional data

---

# SECTION 3: SECONDARY VISUALIZATIONS (Bottom Row - 2 Charts)

## Visualization 7: Top 10 Products by Revenue Chart

### Visual Type
- **Tableau:** Horizontal or vertical bar chart (ranked)
- **Power BI:** Horizontal Bar Chart with ranking

### Fields to Add

| Field | Role | Placement |
|-------|------|-----------|
| `product_name` | Y-axis | Rows |
| `total_revenue` | X-axis | Values |
| `category` | Color | Color shelf |
| `units_sold` | Size/Tooltip | Tooltip |
| `rank` | Label | Text |

### Step-by-Step Instructions

#### For Tableau:

1. **Create data source** from Query 4: Top 10 Products

2. **Build the chart:**
   - Drag `product_name` to Rows shelf
   - Drag `total_revenue` to Columns shelf
   - Add filter: Keep only top 10 rows
     - Drag `product_name` to Filters shelf → Select top 10 by revenue

3. **Add category colors:**
   - Drag `category` to Color shelf
   - Choose distinct colors for each category (max 5-6)

4. **Add ranking:**
   - Create calculated field:
     ```
     Rank = RANK(SUM([total_revenue]))
     ```
   - Drag to Rows (before `product_name`)
   - Hide axis

5. **Format:**
   - **Data labels:** Show revenue amounts ($X format)
   - **Tooltip:**
     ```
     Rank: <rank>
     Product: <product_name>
     Category: <category>
     Revenue: <total_revenue>
     Units Sold: <units_sold>
     ```
   - **Sort:** Descending by revenue
   - **Title:** "Top 10 Products by Revenue"

6. **Color legend:**
   - Show legend for category colors
   - Position: Bottom or right side

#### For Power BI:

1. **Prepare data:**
   - Use Query 4 results or filter to top 10
   - Create rank measure:
   ```DAX
   Product Rank = RANKX(
     ALL(Products[product_name]),
     [Total Revenue],
     ,
     DESC
   )
   ```

2. **Add Horizontal Bar Chart:**
   - Drag `product_name` to Y-axis
   - Drag `total_revenue` to X-values
   - Drag `category` to Data color

3. **Add rank label:**
   - Add `rank` to Data labels
   - Show label value before product name

4. **Format:**
   - **Data labels:** On, show currency values
   - **Sorting:** By X-axis descending
   - **Color:** One color per category
   - **Tooltip:**
     - Include `category`
     - Include `units_sold`
     - Include `rank`
   - **Title:** "Top 10 Products by Revenue"

5. **Filter to top 10:**
   - Visual level filter on `rank` ≤ 10

---

## Visualization 8: Order Status Distribution Pie Chart

### Visual Type
- **Tableau:** Pie chart (donut style)
- **Power BI:** Pie or Donut Chart

### Fields to Add

| Field | Role | Placement |
|-------|------|-----------|
| `order_status` | Slices | Rows |
| `order_count` | Size | Values |
| `revenue_by_status` | Optional secondary | Tooltip |
| `status_percent` | Label | Tooltip/Label |

### Step-by-Step Instructions

#### For Tableau:

1. **Create data source** from Query 5: Order Status Distribution

2. **Build the chart:**
   - Drag `order_status` to Rows shelf
   - Drag `order_count` to Values shelf
   - Change to "Pie" chart type (automatic)
   - Optional: Convert to Donut style
     - Format: Pie properties → Donut hole

3. **Add custom colors by status:**
   - Drag `order_status` to Color shelf
   - Right-click → Edit colors → Choose specific colors:
     - Completed = Green (#2DA65C)
     - Pending = Yellow (#F5A623)
     - Cancelled = Red (#D0021B)
     - Returned = Gray (#999999)

4. **Add percentage labels:**
   - Create calculated field:
     ```
     Status Percent = 
     SUM([order_count]) / TOTAL(SUM([order_count])) * 100
     ```
   - Drag to Label shelf
   - Format: "15.2%"

5. **Format:**
   - **Labels on slices:** Show percentage (15.2%)
   - **Legend:** Show with count numbers
     - Format: "Status: Count (N orders)"
   - **Tooltip:**
     ```
     Status: <order_status>
     Orders: <order_count>
     Percentage: <status_percent>%
     Revenue: <revenue_by_status>
     ```
   - **Title:** "Order Status Distribution"

6. **Add interactivity:**
   - Click on slice to highlight that status
   - Optional: Create dashboard action to filter other charts

#### For Power BI:

1. **Prepare measures:**
   ```DAX
   Status Order Count = DISTINCTCOUNT([order_id])
   
   Status Percent = 
   DIVIDE(
     [Status Order Count],
     CALCULATE([Status Order Count], ALL(Orders[order_status])),
     0
   ) * 100
   
   Revenue by Status = SUM([order_amount])
   ```

2. **Add Pie Chart visual:**
   - Drag `order_status` to Legend
   - Drag `order_count` to Values

3. **Format:**
   - **Chart type:** Pie or Donut
   - **Legend:** Show with positioning
   - **Data labels:** On
     - Show category: On
     - Show percentage: On
     - Show total: Off
   - **Tooltip:**
     - Show `status_percent`
     - Show `revenue_by_status`

4. **Colors:**
   - Completed → Green (#2DA65C)
   - Pending → Yellow (#F5A623)
   - Cancelled → Red (#D0021B)
   - Returned → Gray (#999999)
   - Right-click chart → Conditional formatting → Data colors

5. **Title:** "Order Status Distribution"

---

# SECTION 4: FILTERS & INTERACTIVITY

## Filter 1: Date Range Selector

### For Tableau:

1. **Create filter:**
   - Right-click `order_date` → Create filter → Date range
   - Add to filters shelf

2. **Configure:**
   - Type: Range of dates
   - Default: Last 90 days
   - Add preset buttons:
     - Right-click filter → Quick filters options
     - Create quick dates: "Last 7 Days", "Last 30 Days", "Last 90 Days", "Year to Date"

3. **Apply to all sheets:**
   - Drag filter to Dashboard
   - Select "Apply to all sheets using this data source"

### For Power BI:

1. **Create date slicer:**
   - Insert → Slicer → Date
   - Set field: `order_date`

2. **Configure:**
   - Style: Dropdown or range
   - Set default range: Last 90 days
   - Position: Top center or left sidebar

3. **Connect to visuals:**
   - Select slicer → Apply to all pages
   - All visuals should respond to date changes

---

## Filter 2: Region Filter

### For Tableau:

1. **Create filter:**
   - Right-click `region` → Create filter

2. **Configure:**
   - Type: List (checkboxes)
   - Default: All regions selected
   - Add to filters shelf

3. **Apply across dashboard:**
   - Drag to Dashboard
   - Select "Apply to all sheets"

4. **Count badge (optional):**
   - Add text object showing selected count
   - Update manually or create calculated field

### For Power BI:

1. **Create region slicer:**
   - Insert → Slicer → Field: `region`

2. **Configure:**
   - Style: Dropdown or buttons
   - Default: All regions
   - Enable "Select all" option

3. **Placement:** Left sidebar or top area

---

## Filter 3: Product Category Filter

### For Tableau:

1. **Create filter:**
   - Right-click `category` → Create filter

2. **Configure:**
   - Type: List (checkboxes)
   - Default: All categories
   - Add to filters shelf

3. **Apply to specific sheets:**
   - Add only to Revenue and Product charts
   - Don't apply to Region chart

### For Power BI:

1. **Create category slicer:**
   - Insert → Slicer → Field: `category`

2. **Configure:**
   - Style: List or dropdown
   - Default: All selected

3. **Apply selectively:**
   - Connect only to relevant visuals (Revenue, Products)

---

## Filter 4: Order Status Filter

### For Tableau:

1. **Create filter:**
   - Right-click `order_status` → Create filter

2. **Configure:**
   - Type: List (checkboxes)
   - Default: All statuses selected
   - Custom list order: Completed, Pending, Cancelled, Returned

3. **Apply to dashboard:**
   - Drag to Dashboard
   - Select all applicable sheets

### For Power BI:

1. **Create status slicer:**
   - Insert → Slicer → Field: `order_status`

2. **Configure:**
   - Style: Buttons or checkboxes
   - Default: All selected
   - Custom sort: Completed, Pending, Cancelled, Returned

---

## Filter Reset Button

### For Tableau:

1. **Create blank action:**
   - Dashboard → New action → Highlight
   - Source: Button
   - Target: All applicable filters
   - Action: Deselect all (then reset to defaults)

2. **Add button to dashboard:**
   - Insert → Button object
   - Label: "Reset All Filters"
   - Action: Clear all filter values

### For Power BI:

1. **Create reset button:**
   - Insert → Button
   - Set action: Bookmark
   - Create bookmark of default filter state

2. **Link button to reset:**
   - Click the button
   - Action → Bookmark → Select "Reset" bookmark
   - Label: "Reset All Filters"

---

# SECTION 5: DASHBOARD LAYOUT & ASSEMBLY

## Layout Grid

```
┌─────────────────────────────────────────────────────────────┐
│                    DASHBOARD TITLE                           │
│                                                              │
├──────────────┬──────────────┬──────────────┬────────────────┤
│ Revenue KPI  │  Orders KPI  │   AOV KPI    │  Customer KPI  │
│   $2.5M ↑    │  125K ↑      │  $125.50 ↓   │   28K ↑        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│           Revenue Trend (Line Chart)                        │
│           ┌─────────────────────────────┐                   │
│           │                             │                   │
│           │                             │                   │
│           └─────────────────────────────┘                   │
│                                                              │
├──────────────────────────┬──────────────────────────────────┤
│  Revenue by Region       │  Top 10 Products                 │
│  ┌────────────────────┐  │  ┌────────────────────────────┐ │
│  │                    │  │  │                            │ │
│  │    [Bar Chart]     │  │  │    [Bar Chart]             │ │
│  │                    │  │  │                            │ │
│  └────────────────────┘  │  └────────────────────────────┘ │
├──────────────────────────┼──────────────────────────────────┤
│  Order Status Dist.      │  Filters                         │
│  ┌────────────────────┐  │  ┌────────────────────────────┐ │
│  │   [Pie Chart]      │  │  │ Date Range: [▼ Selector]   │ │
│  │                    │  │  │ Region: [☐ Multi-select]   │ │
│  └────────────────────┘  │  │ Category: [☐ Multi-select] │ │
│                          │  │ Status: [☐ Checkboxes]     │ │
│                          │  │ [Reset All Filters]        │ │
│                          │  └────────────────────────────┘ │
└──────────────────────────┴──────────────────────────────────┘
```

## Implementation Order

### Phase 1: Build KPI Cards (30 minutes)
1. Add Revenue KPI card
2. Add Orders KPI card
3. Add AOV KPI card
4. Add Customer Count card
5. Position in top row

### Phase 2: Build Main Charts (2 hours)
1. Add Revenue Trend line chart
2. Add Revenue by Region bar chart
3. Test click-to-filter interaction

### Phase 3: Add Secondary Charts (1.5 hours)
1. Add Top 10 Products bar chart
2. Add Order Status Pie chart
3. Arrange in grid

### Phase 4: Add Filters (1 hour)
1. Add date range filter
2. Add region filter
3. Add category filter
4. Add status filter
5. Add reset button
6. Test all interactions

### Phase 5: Polish & Format (1 hour)
1. Adjust colors to brand palette
2. Format all numbers consistently
3. Add titles and descriptions
4. Fix alignment and spacing
5. Add logo and last refresh timestamp

---

# SECTION 6: FIELD MAPPING QUICK REFERENCE

## Database Fields → Dashboard Fields

| Chart | Field | Data Type | SQL Query | Format |
|-------|-------|-----------|-----------|--------|
| Revenue KPI | total_revenue_ytd | Decimal | Query 1 | $2,543,210 |
| Revenue KPI | revenue_trend_percent | Percent | Calculated | 15.2% |
| Orders KPI | total_orders_ytd | Integer | Query 1 | 125,430 |
| Orders KPI | orders_trend_percent | Percent | Calculated | 8.5% |
| AOV KPI | aov_ytd | Decimal | Query 1 | $125.50 |
| AOV KPI | aov_trend_percent | Percent | Calculated | 12.3% |
| Customer KPI | unique_customers_ytd | Integer | Query 1 | 28,450 |
| Customer KPI | customer_trend_percent | Percent | Calculated | 6.2% |
| Revenue Trend | order_date | Date | Query 2 | Jan 01, 2026 |
| Revenue Trend | total_revenue | Decimal | Query 2 | $125,430 |
| Revenue Trend | is_weekend | Text | Query 2 | Yes/No |
| Revenue by Region | region | Text | Query 3 | North, South, East, West |
| Revenue by Region | total_revenue | Decimal | Query 3 | $2.5M |
| Revenue by Region | order_count | Integer | Query 3 | 12,450 |
| Top Products | product_name | Text | Query 4 | Product Name |
| Top Products | total_revenue | Decimal | Query 4 | $542,100 |
| Top Products | category | Text | Query 4 | Electronics |
| Top Products | units_sold | Integer | Query 4 | 2,345 |
| Status Distribution | order_status | Text | Query 5 | Completed |
| Status Distribution | order_count | Integer | Query 5 | 85,400 |

---

# TROUBLESHOOTING COMMON ISSUES

## Problem: Charts show wrong data

**Solution:**
- Verify correct query is connected
- Check date filter isn't excluding data
- Verify field aggregation (SUM vs COUNT vs DISTINCT COUNT)
- Check for null values in source data

## Problem: Filters don't work

**Solution:**
- Ensure all charts use same data source
- Check filter is added to all applicable sheets
- Verify filter field name matches across all tables
- Test each filter independently first

## Problem: Numbers format incorrectly

**Solution:**
- Right-click field → Format cells
- Set number format (Currency, Number, Percent)
- Set decimal places (2 for currency, 0 for counts)
- Check regional settings

## Problem: Colors aren't showing

**Solution:**
- Verify field is dragged to Color shelf
- Check color palette is selected
- Ensure at least one data value exists
- Reset color scheme if corrupted

## Problem: Performance is slow

**Solution:**
- Reduce data volume by filtering dates
- Remove unnecessary fields from view
- Use aggregated data instead of row-level
- Check for cross-filters on large datasets

---

# QUICK CHECKLIST

**Before Publishing Dashboard:**

- [ ] All 4 KPI cards display correct values
- [ ] Revenue Trend shows 90 days of data
- [ ] Region chart shows all 4 regions
- [ ] Product chart shows top 10 products
- [ ] Status chart shows all 4 statuses
- [ ] Date filter works on all charts
- [ ] Region filter works on all applicable charts
- [ ] Category filter works on product charts
- [ ] Status filter works on all charts
- [ ] Reset button clears all filters
- [ ] All numbers formatted consistently
- [ ] All colors match brand palette
- [ ] Tooltips show all relevant fields
- [ ] Dashboard title is visible
- [ ] Last refresh timestamp is visible
- [ ] Mobile responsive layout confirmed
- [ ] No broken drill-through actions
- [ ] Print layout tested

