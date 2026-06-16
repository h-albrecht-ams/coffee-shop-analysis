/*
====================================
Coffee Shop Analysis
Exploratory Data Analysis (EDA)
Author: Hendrik Albrecht
====================================
*/


/*

====================================

DATA QUALITY CHECKS

====================================

*/

SELECT
	column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'coffee_shop_sales';

/*

====================================

TRANSACTIONS BY STORE

====================================

*/

SELECT
	store_location,
	COUNT(*) AS transactions
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY transactions DESC;


/*

====================================

UNITS SOLD BY CATEGORY

====================================

*/

SELECT
    product_category,
    SUM(transaction_qty) AS units_sold
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY units_sold DESC;

/*

====================================

REVENUE BY CATEGORY

====================================

*/

SELECT
    product_category,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY revenue DESC;


/*

====================================

AVERAGE REVENUE BY UNIT

====================================

*/

SELECT
	product_category,
	round(
		sum(transaction_qty * unit_price) / sum(transaction_qty), 2) AS avg_revenue_per_unit
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY AVG_REVENUE_PER_UNIT DESC;


/*

====================================

REVENUE BY MONTH

====================================

*/

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
FROM coffee_shop_sales
GROUP BY month
ORDER BY month;


/*

====================================

REVENUE BY HOUR

====================================

*/

SELECT
    EXTRACT(HOUR FROM transaction_time) AS hour,
    COUNT(*) AS transactions
FROM coffee_shop_sales
GROUP BY hour
ORDER BY hour;


/*

====================================

REVENUE BY STORE

====================================

*/

SELECT
    store_location,
    ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY revenue DESC;


/*

====================================

CHANGES AND CORRECTIONS

====================================

*/


SELECT unit_price
FROM coffee_shop_sales
LIMIT 10;

ALTER TABLE coffee_shop_sales
ALTER COLUMN unit_price TYPE numeric
USING REPLACE(unit_price, ',', '.')::numeric;


ALTER TABLE coffee_shop_sales
ALTER COLUMN transaction_time TYPE time
USING transaction_time::time;


