/*  
	1. Total Sales
	2. Total Profit
	3. Total Quantity
	4. Total Order Count
	5. Avg Shipping Cost
	6. Sales by specific category and its sub-categories
	7. Sales and Profit correlation
	8. Sales by Market correlation
	9. Sales by country correlation
	
	
*/


----- Check to see if any KPI has duplicate values -----
--SELECT [Order ID], [Order Date], [Customer Id],Category, [Product Name], COUNT(*) OVER (PARTITION BY [Order id])
--FROM [Global SuperStore]..Orders
----GROUP BY [Order ID], [Customer ID], [Order Date]
----HAVING COUNT(*) >1
--ORDER BY [Order ID]

SELECT *, ROW_NUMBER() OVER (PARTITION BY [Order Id], [Product Name] Order by [Row Id])
FROM [Global SuperStore]..Orders
--- No Duplicates found in the dataset---

------ Check for any missing or null values -------
---51,290 records total
SELECT * 
FROM [Global SuperStore]..Orders
-- 9,983 not null 
SELECT [Postal Code]
FROM [Global SuperStore]..Orders
WHERE [Postal Code] is not null
-- Verifies that all Postal codes that have a value in this dataset are from US
SELECT [Postal Code], country
FROM [Global SuperStore]..Orders
WHERE [Postal Code] is not null and country = 'United States'
-- 
SELECT [Postal Code], COUNT(*) 
FROM [Global SuperStore]..Orders
GROUP BY [Postal Code]
HAVING COUNT(*)>1 and [Postal Code] is null

--- There are no missing values in this dataset, all the postals codes rows that dont have a null are associated with US the rest of the countries are all null and dont have a value.
--- Cannot further fill these data unless more information is provided. 







------ Change format of any data to correct type ---------

SELECT * 
FROM [Global SuperStore]..Orders

ALTER TABLE [Global SuperStore]..Orders
ALTER COLUMN [Ship Date] date

------- 1. Total Sales
--Total Sales Per Unique Customer
SELECT [Customer ID], SUM(Sales) as TotalSales
FROM [Global SuperStore]..Orders
GROUP BY [Customer ID]
Order by [Customer ID]
 
 --Total Sales Per Country and State

SELECT Country, ROUND(SUM(Sales),2) as TotalSalesPerCountry
FROM [Global SuperStore]..Orders
GROUP BY Country
Order by Country

SELECT Country, state, ROUND(SUM(Sales),2) as TotalSalesPerCountryState
FROM [Global SuperStore]..Orders
GROUP BY Country, State
Order by Country, State

--SELECT Country, state, [Order Id], [Order Date], SUM(Sales) OVER (PARTITION BY Country, state ORDER by [Order Date]) 
--FROM [Global SuperStore]..Orders
--Order by Country, State

-- Min and Max Sales Per state in the United States. 
SELECT Country, state, Min(b.TotalSalesPerCountryStatePostalCode) as Min, Max(b.TotalSalesPerCountryStatePostalCode) as Max
FROM 
(
SELECT Country, state, [Postal Code], ROUND(SUM(Sales),2) as TotalSalesPerCountryStatePostalCode
FROM [Global SuperStore]..Orders
GROUP BY Country, State, [Postal Code]
HAVING [Postal Code] is not null
) b
GROUP BY Country, state
ORDER BY b.Country


 --Total Sales Per Category and Subcategory 
-- Total Sales per Category
SELECT Category, ROUND(SUM(SALES),2) AS TotalSalesPerCategory
FROM [Global SuperStore]..Orders
GROUP BY Category
Order by TotalSalesPerCategory DESC

--Total Sales per Category subdivided into subcaategories and total number of purchases of each product 
SELECT Category,[Sub-Category], ROUND(SUM(SALES),2) AS TotalSalesPerCategory, SUM(Quantity) AS TotalQuantityofProductsPurchased 
FROM [Global SuperStore]..Orders
GROUP BY Category, [Sub-Category]
--HAVING [Sub-Category]='Phones'
Order by TotalSalesPerCategory, Category DESC


--- 2. Total Profit 
-- Profit By Country and State 
SELECT Country, ROUND(SUM(Profit),2) as TotalProfit
FROM [Global SuperStore]..Orders
GROUP BY Country
ORDER BY TotalProfit DESC


SELECT [Order ID] ,Country,State,Market, ROUND(SUM(Profit),2) As TotalProfit
FROM [Global SuperStore]..Orders 
GROUP BY Country, state,[Order ID],Market
ORDER BY [Order ID]

--Checking to see the # of Returns made from the country Argentina
SELECT a.[Order ID] ,a.Country,a.State, a.Market, ROUND(SUM(Profit),2) As TotalProfit
FROM [Global SuperStore]..Orders a
JOIN [Global SuperStore]..Returns b
ON a.[Order ID] = b.[Order ID] AND a.Market = b.Market
GROUP BY Country, state, a.[Order ID], a.Market
HAVING Country = 'Argentina'
ORDER BY [Order ID]

SELECT * FROM [Global SuperStore]..Returns
WHERE Market ='LATAM' 

--Profit Generated from each customer
SELECT [Customer ID], [Customer Name], ROUND(SUM(Profit),2) AS TotalProfitEarnedFromEachCustomer
FROM [Global SuperStore]..Orders
GROUP BY [Customer ID],[Customer Name]
ORDER BY [Customer ID]


--3. Total Quantity

--Total Quantity of items placed per category
SELECT Category, SUM(Quantity) AS TotalQuantityOfItemsOrder
FROM [Global SuperStore]..Orders
GROUP BY Category
ORDER BY Category

--Total Quantity of items placed per sub-category
SELECT Category, [Sub-Category], SUM(Quantity) AS TotalQuantityOfItemsOrder
FROM [Global SuperStore]..Orders
GROUP BY Category, [Sub-Category]
ORDER BY Category

--Total Quantity of items placed per country
SELECT Country, SUM(Quantity) AS TotalQuantityOfItemsOrder
FROM [Global SuperStore]..Orders
GROUP BY country
--HAVING Country='Canada'
ORDER BY TotalQuantityOfItemsOrder DESC

--Total Quantity of items placed per State
SELECT Country, state, SUM(Quantity) AS TotalQuantityOfItemsOrder
FROM [Global SuperStore]..Orders
GROUP BY country, State
--HAVING Country='Canada'
ORDER BY country, TotalQuantityOfItemsOrder DESC

--Total Quantity of items returned


SELECT a.Country, COUNT(b.Returned) as TotalCountReturned, SUM(a.Quantity) as TotalQuantityReturned
FROM [Global SuperStore]..Orders a
JOIN [Global SuperStore]..Returns b
ON a.[Order ID] = b.[Order ID]
GROUP BY a.Country
ORDER BY  TotalCountReturned DESC

-- 4. Total Order Count

SELECT COUNT(DISTINCT[Order Id]) AS TotalCountofOrders
FROM [Global SuperStore]..Orders
--GROUP BY [Order ID]
--ORDER BY [Order ID]


SELECT Country, Category, [Sub-Category], COUNT([Order Id]) AS TotalCountofOrders
FROM [Global SuperStore]..Orders
GROUP BY Country, Category,[Sub-Category]
ORDER BY Country, TotalCountofOrders DESC


-- 5. AVG Shipping Cost


--AVG shipping cost per country, state, category, sub-category

SELECT Country, state, Category, [Sub-Category], ROUND(AVG([Shipping Cost]),2) AS AvgShippingCost
FROM [Global SuperStore]..Orders
GROUP BY Category, [Sub-Category], country, State
--HAVING [Sub-Category]='Labels' and Country='Canada'
ORDER BY Country, AvgShippingCost 

-- AVG shipping cost for Country
SELECT Country,  ROUND(AVG([Shipping Cost]),2) AS AvgShippingCost
FROM [Global SuperStore]..Orders
GROUP BY Country
ORDER BY AvgShippingCost 

--AVG shipping cost per Category
SELECT Category,  ROUND(AVG([Shipping Cost]),2) AS AvgShippingCost
FROM [Global SuperStore]..Orders
GROUP BY Category
ORDER BY AvgShippingCost 

--AVG shipping costs per sub-category
SELECT Category,[Sub-Category],  ROUND(AVG([Shipping Cost]),2) AS AvgShippingCost
FROM [Global SuperStore]..Orders
GROUP BY Category,[Sub-Category]
ORDER BY AvgShippingCost 