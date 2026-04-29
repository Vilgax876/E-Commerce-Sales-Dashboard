"""
Synthetic E-Commerce Data Generator
Generates realistic e-commerce data with seasonality and regional patterns
Output: CSV files for import into database
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import sqlite3

# Set random seed for reproducibility
np.random.seed(42)
random.seed(42)

# Configuration
NUM_CUSTOMERS = 5000
NUM_PRODUCTS = 500
DATE_START = "2024-01-01"
DATE_END = "2024-12-31"
NUM_ORDERS = 50000

# Product categories and their properties
CATEGORIES = {
    'Electronics': {'price_range': (50, 2000), 'count': 150, 'margin': 0.35},
    'Home': {'price_range': (20, 500), 'count': 100, 'margin': 0.40},
    'Sports': {'price_range': (15, 300), 'count': 80, 'margin': 0.45},
    'Clothing': {'price_range': (10, 150), 'count': 120, 'margin': 0.50},
    'Books': {'price_range': (5, 50), 'count': 50, 'margin': 0.25}
}

REGIONS = ['North', 'South', 'East', 'West']
ORDER_STATUSES = ['Completed', 'Pending', 'Cancelled', 'Returned']

def generate_customers():
    """Generate customer data"""
    print("Generating customers...")
    customer_ids = range(1, NUM_CUSTOMERS + 1)
    names = [f"Customer_{i}" for i in customer_ids]
    emails = [f"cust_{i}@email.com" for i in customer_ids]
    regions = np.random.choice(REGIONS, NUM_CUSTOMERS)
    registration_dates = pd.date_range(start="2023-01-01", end=DATE_START, periods=NUM_CUSTOMERS)
    
    df = pd.DataFrame({
        'customer_id': customer_ids,
        'customer_name': names,
        'email': emails,
        'registration_date': registration_dates,
        'region': regions,
        'country': 'USA'
    })
    return df

def generate_products():
    """Generate product data"""
    print("Generating products...")
    products = []
    product_id = 1
    
    for category, props in CATEGORIES.items():
        for i in range(props['count']):
            products.append({
                'product_id': product_id,
                'product_name': f"{category}_Product_{i+1}",
                'category_id': list(CATEGORIES.keys()).index(category) + 1,
                'category_name': category,
                'price': round(np.random.uniform(*props['price_range']), 2),
                'supplier_id': np.random.randint(1, 51)
            })
            product_id += 1
    
    return pd.DataFrame(products)

def generate_categories():
    """Generate category data"""
    print("Generating categories...")
    categories = list(CATEGORIES.keys())
    df = pd.DataFrame({
        'category_id': range(1, len(categories) + 1),
        'category_name': categories
    })
    return df

def generate_orders(customers_df, products_df):
    """Generate order data with realistic patterns"""
    print("Generating orders...")
    orders = []
    date_range = pd.date_range(start=DATE_START, end=DATE_END, freq='D')
    
    for order_id in range(1, NUM_ORDERS + 1):
        # Seasonal pattern: higher sales in Nov-Dec
        current_date = random.choice(date_range)
        month = current_date.month
        
        # Seasonality: 30% higher in Nov-Dec
        seasonal_boost = 1.3 if month in [11, 12] else 1.0
        
        # Determine order status (70% completed, 15% pending, 10% cancelled, 5% returned)
        status_rand = random.random()
        if status_rand < 0.70:
            status = 'Completed'
        elif status_rand < 0.85:
            status = 'Pending'
        elif status_rand < 0.95:
            status = 'Cancelled'
        else:
            status = 'Returned'
        
        customer = customers_df.sample(1).iloc[0]
        product = products_df.sample(1).iloc[0]
        
        # Weekend boost: 20% more orders on weekends
        is_weekend = current_date.dayofweek >= 5
        weekend_boost = 1.2 if is_weekend else 1.0
        
        quantity = max(1, int(np.random.exponential(1.5) * weekend_boost))
        unit_price = product['price']
        order_amount = quantity * unit_price * seasonal_boost
        
        orders.append({
            'order_id': order_id,
            'customer_id': customer['customer_id'],
            'order_date': current_date,
            'order_amount': round(order_amount, 2),
            'status': status,
            'region': customer['region']
        })
    
    return pd.DataFrame(orders)

def generate_order_items(orders_df, products_df):
    """Generate order items data"""
    print("Generating order items...")
    order_items = []
    
    for _, order in orders_df.iterrows():
        num_items = max(1, int(np.random.exponential(1.2)))
        items_in_order = products_df.sample(min(num_items, len(products_df)))
        
        item_id = 1
        for _, product in items_in_order.iterrows():
            quantity = max(1, int(np.random.exponential(1.5)))
            unit_price = product['price']
            
            order_items.append({
                'order_item_id': len(order_items) + 1,
                'order_id': order['order_id'],
                'product_id': product['product_id'],
                'quantity': quantity,
                'unit_price': round(unit_price, 2)
            })
    
    return pd.DataFrame(order_items)

def generate_kpi_summary(orders_df):
    """Generate KPI summary for dashboard"""
    print("Generating KPI summary...")
    
    completed_orders = orders_df[orders_df['status'] == 'Completed']
    total_revenue_ytd = completed_orders['order_amount'].sum()
    total_orders_ytd = len(completed_orders)
    aov_ytd = total_revenue_ytd / total_orders_ytd if total_orders_ytd > 0 else 0
    unique_customers = orders_df['customer_id'].nunique()
    
    # Previous year comparison (simulated)
    prev_year_revenue = total_revenue_ytd * 0.85
    prev_year_orders = int(total_orders_ytd * 0.85)
    prev_year_aov = prev_year_revenue / prev_year_orders if prev_year_orders > 0 else 0
    prev_year_customers = int(unique_customers * 0.80)
    
    df = pd.DataFrame({
        'ytd_revenue': [round(total_revenue_ytd, 2)],
        'ytd_orders': [total_orders_ytd],
        'ytd_aov': [round(aov_ytd, 2)],
        'ytd_customer_count': [unique_customers],
        'prev_year_revenue': [round(prev_year_revenue, 2)],
        'prev_year_orders': [prev_year_orders],
        'prev_year_aov': [round(prev_year_aov, 2)],
        'prev_year_customer_count': [prev_year_customers]
    })
    return df

def generate_daily_revenue_trend(orders_df):
    """Generate daily revenue trend for visualization"""
    print("Generating daily revenue trend...")
    
    completed_orders = orders_df[orders_df['status'] == 'Completed'].copy()
    completed_orders['order_date'] = pd.to_datetime(completed_orders['order_date'])
    completed_orders['is_weekend'] = completed_orders['order_date'].dt.dayofweek >= 5
    
    daily = completed_orders.groupby(['order_date', 'is_weekend']).agg({
        'order_amount': 'sum'
    }).reset_index()
    daily.columns = ['date', 'is_weekend', 'daily_revenue']
    daily['is_weekend'] = daily['is_weekend'].apply(lambda x: 'Yes' if x else 'No')
    
    return daily

def generate_revenue_by_region(orders_df, products_df):
    """Generate revenue aggregation by region"""
    print("Generating revenue by region...")
    
    merged = orders_df.merge(products_df[['product_id', 'category_name']], on='product_id', how='left')
    region_revenue = merged.groupby('region').agg({
        'order_amount': 'sum',
        'order_id': 'count'
    }).reset_index()
    region_revenue.columns = ['region', 'total_revenue', 'order_count']
    
    return region_revenue

def generate_order_status_distribution(orders_df):
    """Generate order status distribution"""
    print("Generating order status distribution...")
    
    status_dist = orders_df.groupby('status').agg({
        'order_id': 'count',
        'order_amount': 'sum'
    }).reset_index()
    status_dist.columns = ['order_status', 'order_count', 'revenue_by_status']
    status_dist['percentage_of_total'] = (status_dist['order_count'] / status_dist['order_count'].sum() * 100).round(2)
    
    return status_dist

def generate_product_category_analysis(orders_df, products_df):
    """Generate product category analysis"""
    print("Generating product category analysis...")
    
    merged = orders_df.merge(products_df[['product_id', 'product_name', 'category_name', 'price']], on='product_id', how='left')
    category_analysis = merged.groupby(['product_name', 'category_name']).agg({
        'order_amount': 'sum',
        'quantity': lambda x: x.sum() if 'quantity' in merged.columns else 1,
        'order_id': 'count'
    }).reset_index()
    category_analysis.columns = ['product_name', 'category_name', 'product_revenue', 'units_sold', 'order_count']
    category_analysis = category_analysis.sort_values('product_revenue', ascending=False).head(10)
    
    return category_analysis

def save_to_csv(dfs_dict, output_dir='.'):
    """Save all dataframes to CSV"""
    print(f"\nSaving CSV files...")
    for name, df in dfs_dict.items():
        filename = f"{output_dir}/{name}.csv"
        df.to_csv(filename, index=False)
        print(f"  ✓ {filename} ({len(df)} rows)")

def save_to_sqlite(dfs_dict, db_name='ecommerce.db'):
    """Save all dataframes to SQLite"""
    print(f"\nSaving to SQLite: {db_name}")
    conn = sqlite3.connect(db_name)
    
    for name, df in dfs_dict.items():
        df.to_sql(name.lower().replace(' ', '_'), conn, if_exists='replace', index=False)
        print(f"  ✓ {name}")
    
    conn.close()

def main():
    print("=" * 60)
    print("E-COMMERCE SYNTHETIC DATA GENERATOR")
    print("=" * 60)
    
    # Generate all data
    customers = generate_customers()
    products = generate_products()
    categories = generate_categories()
    orders = generate_orders(customers, products)
    order_items = generate_order_items(orders, products)
    
    # Generate analytics/dashboard tables
    kpi_summary = generate_kpi_summary(orders)
    daily_revenue = generate_daily_revenue_trend(orders)
    revenue_region = generate_revenue_by_region(orders, products)
    order_status = generate_order_status_distribution(orders)
    product_analysis = generate_product_category_analysis(orders, products)
    
    # Prepare all dataframes
    all_data = {
        'customers': customers,
        'products': products,
        'categories': categories,
        'orders': orders,
        'order_items': order_items,
        'KPI SUMMARY': kpi_summary,
        'DAILY REVENUE TREND': daily_revenue,
        'REVENUE BY REGION': revenue_region,
        'ORDER STATUS DISTRIBUTION': order_status,
        'PRODUCT CATEGORY ANALYSIS': product_analysis
    }
    
    # Save to CSV
    save_to_csv(all_data)
    
    # Save to SQLite
    save_to_sqlite(all_data)
    
    print("\n" + "=" * 60)
    print("DATA GENERATION COMPLETE!")
    print("=" * 60)
    print(f"\nSummary:")
    print(f"  • Customers: {len(customers):,}")
    print(f"  • Products: {len(products):,}")
    print(f"  • Orders: {len(orders):,}")
    print(f"  • Order Items: {len(order_items):,}")
    print(f"  • Date Range: {DATE_START} to {DATE_END}")
    print(f"  • Total Revenue: ${orders['order_amount'].sum():,.2f}")

if __name__ == "__main__":
    main()
