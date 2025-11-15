USE aulala_sales;
# Table represents all sales from Jan 1 2025 - Oct 31 2025

# Find uncategorized dresses within table
SELECT *
FROM sales_table
WHERE category_name = 'Uncategorized'
	AND (
		item_name LIKE '%Mini%'
		OR item_name LIKE '%Midi%'
        OR item_name LIKE '%Maxi%'
        OR item_name LIKE '%Dress%'
	);

# Move uncategorized dresses to accurate "dresses" category
UPDATE sales_table
SET category_name = 'Dresses'
WHERE category_name = 'Uncategorized'
	AND (
		item_name LIKE '%Mini%'
		OR item_name LIKE '%Midi%'
		OR item_name LIKE '%Maxi%'
		OR item_name LIKE '%Dress%'
	);

# Update typos/unstandardized names
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

#1 Find amount of items sold in each category
SELECT 
    category_name,
    SUM(amount_sold) AS total_sold
FROM sales_table
WHERE category_name IN ('dresses', 'bottoms', 'tops', 'jewelry', 'accessories')
GROUP BY category_name;

#2 Find most to least sold dress designs
SELECT 
    SUBSTRING_INDEX(item_name, ' ', 2) AS style_name,
    SUM(amount_sold) AS total_sold,
    ROUND(SUM(net_sales), 2) AS total_sales
FROM sales_table
WHERE category_name = 'dresses'
GROUP BY style_name
ORDER BY total_sold DESC;

#3 Find the amount of dresses sold in each size
SELECT 
  REGEXP_SUBSTR(item_name, '[0-9]+') AS size,
  SUM(amount_sold) AS total_sold
FROM sales_table
WHERE category_name = 'dresses'
	AND REGEXP_SUBSTR(item_name, '[0-9]+') IS NOT NULL
GROUP BY size
ORDER BY size + 0;
