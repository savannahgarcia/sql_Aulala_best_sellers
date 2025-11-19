# Aulala Best Sellers

## 📘 Project Overview
This project analyzes sales data from Au La La Design to identify the boutique’s best-selling styles and sizes. By combining SQL for data cleaning and analysis with Tableau for visualization, it provides actionable insights to guide production planning, inventory management, and sales strategy.

Database: `Aulala_2025sales(in).csv`

---

## 🎯 Objectives

1. **Extract & Format Sales Data**: Generate Excel report from clover POS system. Remove unneccessary columns, identify and remove null values.
2. **Import into SQL & Clean Data**: Standardize categories, correct mislabeled items, and fix inconsistent naming conventions.
3. **Data/Business Analysis**: Perform data analysis using SQL to identify best selling styles and sizes.
4. **Display Findings**: Import cleaned and analyzed results into Tableau to generate visual dashboards.

## Project Structure

### 1. Extract & Format Sales Data

- **Clover**: Generate report and save as Excel file.
- **Excel Data Cleaning**: Format for SQL (delete intro info, remove category totals, fill empty spaces with category)
  - Problem: “uncategorized” contained mostly dresses and accessories. These items already have categories but it will take too long to sort individually
  - Table structure: location,	category_name,	item_name,	gross_sales,	net_sales,	amount_sold,	discounts,	avg_item_size

### 2. Import into SQL & Clean Data

- **Import into SQL**: Import wizard
- **Categorize dresses**: Find uncategorized dresses within table & move to accurate "dresses" category
    ```sql
    SELECT *
    FROM sales_table
    WHERE category_name = 'Uncategorized'
	    AND (
		    item_name LIKE '%Mini%'
		    OR item_name LIKE '%Midi%'
        OR item_name LIKE '%Maxi%'
        OR item_name LIKE '%Dress%'
      	);

    UPDATE sales_table
    SET category_name = 'Dresses'
    WHERE category_name = 'Uncategorized'
	    AND (
		    item_name LIKE '%Mini%'
		    OR item_name LIKE '%Midi%'
		    OR item_name LIKE '%Maxi%'
		    OR item_name LIKE '%Dress%'
      	);

- **Update typos/unstandardized names**

    ```sql
    SELECT * 
    FROM sales_table
    WHERE item_name
    LIKE '%Roselanh%';

    UPDATE sales_table
    SET item_name = REPLACE(item_name, 'Roselanh', 'Rosalanh');

    SELECT * 
    FROM sales_table
    WHERE item_name
    LIKE '%Solstice Two Peice%';

    UPDATE sales_table
    SET item_name = REPLACE(item_name, 'Solstice Two Peice', 'Solstice Two-Piece');

    SELECT * 
    FROM sales_table
    WHERE item_name
    LIKE '%Solstice Two Piece%';

    UPDATE sales_table
    SET item_name = REPLACE(item_name, 'Solstice Two Piece', 'Solstice Two-Piece');

## 3. Data/Business Analysis

1. **Find amount of items sold in each category**

  ```sql
  SELECT 
    category_name,
    SUM(amount_sold) AS total_sold
  FROM sales_table
  WHERE category_name IN ('dresses', 'bottoms', 'tops', 'jewelry', 'accessories')
  GROUP BY category_name;
  ```

2. **Find most to least sold dress designs**

  ```sql
  SELECT 
    SUBSTRING_INDEX(item_name, ' ', 2) AS style_name,
    SUM(amount_sold) AS total_sold,
    ROUND(SUM(net_sales), 2) AS total_sales
  FROM sales_table
  WHERE category_name = 'dresses'
  GROUP BY style_name
  ORDER BY total_sold DESC;
  ```

3. **Find the amount of dresses sold in each size**

  ```sql
  SELECT 
    REGEXP_SUBSTR(item_name, '[0-9]+') AS size,
    SUM(amount_sold) AS total_sold
  FROM sales_table
  WHERE category_name = 'dresses'
	  AND REGEXP_SUBSTR(item_name, '[0-9]+') IS NOT NULL
  GROUP BY size
  ORDER BY size + 0;
  ```

---
## Insights Summary
Analysis of Au La La Design’s sales data highlights a clear pattern in customer preferences. Maxi and midi dresses dominate both units sold and total revenue. Sizes 0–4 represent the bulk of demand, accounting for nearly two-thirds of total units sold, while sizes 6–8 contribute steadily and larger sizes 10–14 show limited sales.

## Findings
- **Top-Selling Styles**:
1. Valerie Maxi — 101 units sold, $20,361 in total sales
2. Val Midi — 72 units sold, $14,170 in total sales
3. Peony Mini — 59 units sold, $9,361 in total sales
4. Everly Mini — 51 units sold, $9,120 in total sales
5. Willow Maxi — 50 units sold, $10,671 in total sales
6. Morganite Maxi — 47 units sold, $9,850 in total sales
7. Sedona Midi — 43 units sold, $8,890 in total sales
8. Windellia Midi — 37 units sold, $7,815 in total sales
9. Lila Maxi — 36 units sold, $7,269 in total sales
10. Rosalanh Midi — 34 units sold, $6,989 in total sales

- **Sizes**:

	- **Strongest-Performing Sizes: 0-4.** Nearly two-thirds (63.5%) of all sales come from sizes 0–4. Sizes 0 (350 units), 2 (337 units), and 4 (345 units) are the top sellers.
	- **Mid-Tier Demand: Size 6–8.** About one-quarter (25.4%) of sales come from sizes 6–8.
	- **Tier 3: Extended Sizes (10–14).** Only ~11% of sales come from sizes 10–14.

## Visual Reporting
[Tableau Dashboard](https://public.tableau.com/views/AulalaBestSellers/Dashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Recommendations
- **Style production**: Create variations of the top-selling styles (new colors or limited edition prints) to capitalize on existing demand. Maxi and midi dresses drive the strongest overall performance and should remain the focus.
- **Size production**: Sizes 0–8 account for ~87% of all sales. Focus production on these sizes while producing fewer units in sizes 10–14 to better align with demand.
- **Sales**: Offer low-selling styles at a discount during Black Friday and other upcoming promotions. Use the Tableau dashboard to identify styles that sold fewer than 10 units for targeted sales efforts.
