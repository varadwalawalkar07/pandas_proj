SELECT * FROM orders
/*Top 10 highest revenue generating products */
SELECT  product_id, sum(sale_price) AS sales
FROM orders 
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

/*Top 5 highest revenue generating products in each region */
with cte as(
SELECT  region,product_id, sum(sale_price) AS sales
FROM orders 
GROUP BY region,product_id)
SELECT * FROM (
SELECT *, row_number() OVER(PARTITION BY region
ORDER BY region,sales DESC) AS rn
FROM cte) AS rn
WHERE rn <=5

/* Monthly growth comparison for 2022 and 2023 sales */
with cte as(
SELECT DISTINCT YEAR(order_date) as order_year, MONTH(order_date) as order_month ,
sum(sale_price) AS sales
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
 )
SELECT order_month, 
sum(CASE WHEN order_year = 2022 THEN sales else 0 end) as sales_2022,
sum(CASE WHEN order_year = 2023 THEN sales else 0 end) as sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month