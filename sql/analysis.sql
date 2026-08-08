--Топ 5 прибыльных продуктов
SELECT product_name, SUM(sales) AS total_sales, 
SUM(profit) AS total_profit
FROM fact_order fo INNER JOIN dim_product dp USING(product_id)
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 5;

--Общая сумма продаж и прибыли по категориям товаров
SELECT Category, SUM(quantity) AS total_quantity, SUM(sales) AS total_sales, 
SUM(profit) AS total_profit
FROM fact_order fo INNER JOIN dim_product dp USING(product_id)
GROUP BY Category
ORDER BY total_profit DESC;

--Динамика продаж по месяцам
SELECT DATE_TRUNC('month', order_date) AS month, SUM(quantity) AS month_quantity,
SUM(profit) AS month_profit
FROM fact_order
GROUP BY month
ORDER BY month;

--Сравнение продаж текущего месяца с предыдущим
SELECT DATE_TRUNC('month', order_date) AS cur_month, SUM(profit) AS cur_profit,
SUM(profit) - LAG(SUM(profit)) OVER (ORDER BY  DATE_TRUNC('month', order_date)) AS month_profit_diff
FROM fact_order
GROUP BY cur_month
ORDER BY cur_month;

--Прибыльность по регионам с расчётом маржи
SELECT region, ROUND(SUM(profit) * 100 / NULLIF(SUM(sales), 0), 2) AS margin
FROM fact_order INNER JOIN dim_customer USING(customer_id)
GROUP BY region
ORDER BY margin DESC;

--Топ-3 клиента по общей сумме покупок
SELECT customer_name, SUM(sales) AS customer_sales
FROM fact_order INNER JOIN dim_customer USING(customer_id)
GROUP BY customer_name
ORDER BY customer_sales DESC
LIMIT 3;

--Товары с отрицательной прибылью
SELECT product_name, SUM(profit) AS product_profit
FROM fact_order INNER JOIN dim_product USING(product_id)
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY product_profit;
