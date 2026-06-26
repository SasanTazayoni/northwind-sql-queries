-- Aggregation and Subquery Exercises

-- ============================================================
-- Aggregation Practice
-- ============================================================

-- 1. Orders per customer
SELECT CustomerID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;

-- 2. Total Revenue (whole database)
SELECT ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) AS TotalRevenue
FROM [Order Details];

-- 3. Revenue per order
SELECT OrderID,
ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) AS TotalSales
FROM [Order Details]
GROUP BY OrderID;

-- 4. Revenue per customer
SELECT
	o.CustomerID,
	ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS RevenueFromCustomer
FROM Orders o
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY o.CustomerID
ORDER BY RevenueFromCustomer DESC;

-- 5. Count total number of products
SELECT COUNT(ProductID) AS NumberOfProducts
FROM Products;

-- 6. Find the most expensive product
SELECT TOP 1 ProductID, ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC;

-- 7. Total quantity sold per product
SELECT ProductID, SUM(Quantity) AS TotalNumberOfSales
FROM [Order Details]
GROUP BY ProductID
ORDER BY TotalNumberOfSales DESC;

-- 8. Customers who made more than 5 orders
SELECT CustomerID, COUNT(OrderID) AS OrdersPerCustomer
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 5;

-- 9. Top 3 orders by total value
SELECT TOP 3
	o.OrderID,
	ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS OrderValue
FROM Orders o
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY o.OrderID
ORDER BY OrderValue DESC;

-- ============================================================
-- Subqueries Practice
-- ============================================================

-- 1. Products above avg price

-- 2. Orders above avg order value

-- 3. Customers with more than 5 orders (can be done with or without a subquery)

-- 4. Products that have been ordered at least once

-- 5. Customers that spent above avg per order

-- 6. Products above the avg price for their category


-- ============================================================
-- Bonus
-- ============================================================

-- 7. Find products cheaper than the average price

-- 8. Find customers who have placed at least one order

-- 9. Find orders with total value greater than average

-- 10. Find products never ordered (use subquery, not JOIN)

-- 11. Find employees who handled more than 10 orders
