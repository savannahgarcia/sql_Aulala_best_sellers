# Aulala Best Sellers

## 📘 Project Overview
This project utilizes SQL and Tableau to analyze sales data to identify the best-selling styles and sizes at our boutique business. Data is pulled from the Clover POS system to help guide production, inventory planning, and sales decisions.

---

## 🎯 Objectives

1. **Extract & Clean Sales Data**: Generate Excel report from clover POS system.
2. **Import into SQL & Further Data Cleaning**: Remove unneccessary columns, identify and remove null values.
3. **Data/Business Analysis**: Perform data analysis using SQL to identify best selling styles and sizes.
4. **Display Findings**: Import cleaned and analyzed results into Tableau to generate visual dashboards.

## Project Structure

### 1. Extract & Clean Sales Data

- **Clover**: Generate report and save as Excel file.
- **Excel Data Cleaning**: Format for SQL (delete intro info, remove category totals, fill empty spaces with category)
  - Problem: “uncategorized” contained mostly dresses and accessories. These items already have categories but it will take too long to sort individually
  - Table structure: location,	category_name,	item_name,	gross_sales,	net_sales,	amount_sold,	discounts,	avg_item_size

### 2. Import into SQL & Further Data Cleaning

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

## Findings & Reporting
[Tableau Dashboard](https://public.tableau.com/views/AulalaBestSellers/Dashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Conclusion

---
