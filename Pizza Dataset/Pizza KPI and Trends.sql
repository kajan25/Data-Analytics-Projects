SELECT*FROM Practice..PizzaSales 

ALTER TABLE Practice..PizzaSales
ALTER COLUMN order_date DATE

ALTER TABLE Practice..PizzaSales
ALTER COLUMN order_time time

-----Section A - KPI's
----Total Revenue
SELECT ROUND(SUM(total_price),2) as Total_Revenue
FROM Practice..PizzaSales


----Average Order Value
SELECT SUM(total_price)/COUNT(DISTINCT Order_id) as "Avg. Order Value"
FROM Practice..PizzaSales

----Total Pizzas Sold
SELECT COUNT(quantity) as "Total Pizzas Sold"
FROM Practice..PizzaSales

----Total Orders
SELECT COUNT(DISTINCT Order_id) AS " Total Orders"
FROM Practice..PizzaSales

----Average Pizzas Per Order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id),2) AS "Avg. Pizzas per Order"
FROM Practice..PizzaSales


----Section B - Daily Trend for Total Orders
SELECT DATENAME(DW, order_date) as "Day", COUNT(DISTINCT order_id) as "Total Orders"
FROM Practice..PizzaSales
GROUP BY DATENAME(DW, order_date)
Order by [Total Orders] DESC

----Section C - Monthly Trend for Orders
SELECT DATENAME(MONTH, order_date) as "Day", COUNT(DISTINCT order_id) as "Total Orders"
FROM Practice..PizzaSales
GROUP BY DATENAME(MONTH, order_date)
Order by [Total Orders] DESC

----Section D - % of Sales by Pizza Category
Select * From Practice..PizzaSales

SELECT pizza_category, round(sum(total_price),2) as "Total Revenue", round((sum(total_price)/(SELECT sum(total_price) From Practice..PizzaSales)*100),2) AS "%"
From Practice..PizzaSales
GROUP BY pizza_category
Order by [Total Revenue]

----Section E - % of Sales by Pizza Size
SELECT pizza_size, round(sum(total_price),2) as "Total Revenue", ROUND((sum(total_price)/(SELECT sum(total_price) From Practice..PizzaSales)*100),2) AS "%"
From Practice..PizzaSales
GROUP BY pizza_size
Order by [Total Revenue]

----Section F - Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as "Total Sold"
From Practice..PizzaSales
GROUP BY pizza_category
ORDER BY [Total Sold]

----Section G - Top 5 Pizzas by Revenue
Select * From Practice..PizzaSales

	SELECT TOP 5 pizza_name, ROUND(SUM(total_price),2) as "Total Revenue"
	From Practice..PizzaSales
	GROUP BY pizza_name
	Order by [Total Revenue] DESC

----Section H - Bottom 5 Pizzas by Revenue

	SELECT TOP 5 pizza_name, ROUND(SUM(total_price),2) as "Total Revenue"
	From Practice..PizzaSales
	GROUP BY pizza_name
	Order by [Total Revenue] ASC

----Section I - Top 5 Pizzas by Quantity

	SELECT TOP 5 pizza_name, SUM(quantity) as "Quantity"
	From Practice..PizzaSales
	GROUP BY pizza_name
	Order by Quantity DESC

----Section J - Bottom 5 Pizzas by Quantity

	SELECT TOP 5 pizza_name, SUM(quantity) as "Quantity"
	From Practice..PizzaSales
	GROUP BY pizza_name
	Order by Quantity ASC


----Section K - Top 5 Pizzas by Total Orders

	SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) as "Total Orders"
	From Practice..PizzaSales
	GROUP BY pizza_name
	Order by [Total Orders] DESC


----Section L - Bottom 5 Pizzas by Total Orders
	SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) as "Total Orders"
	From Practice..PizzaSales
	GROUP BY pizza_name
	Order by [Total Orders] ASC