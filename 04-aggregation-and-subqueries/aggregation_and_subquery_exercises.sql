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
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-- 2. Orders above avg order value
SELECT
  OrderID,
  ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) AS OrderValue
FROM [Order Details]
GROUP BY OrderID
HAVING ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) > (
  SELECT AVG(OrderValue)
  FROM (
    SELECT SUM(Quantity * UnitPrice * (1 - Discount)) AS OrderValue
    FROM [Order Details]
    GROUP BY OrderID
  ) AS OrderTotals
);

-- 3. Customers with more than 5 orders (can be done with or without a subquery)
SELECT CustomerID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 5;

-- 4. Products that have been ordered at least once
SELECT ProductID, ProductName
FROM Products
WHERE ProductID IN (SELECT ProductID FROM [Order Details]);

-- 5. Customers that spent above avg per order
SELECT
   o.CustomerID,
  ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalSpend
FROM Orders o
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY o.CustomerID
HAVING ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) > (
  SELECT AVG(OrderValue)
  FROM (
    SELECT SUM(Quantity * UnitPrice * (1 - Discount)) AS OrderValue
    FROM [Order Details]
    GROUP BY OrderID
  ) AS OrderTotals
);


-- 6. Products above the avg price for their category
SELECT ProductID, ProductName, UnitPrice
FROM Products p
WHERE UnitPrice > (
	SELECT AVG(UnitPrice) AS AveragePrice
	FROM Products p2
	WHERE p2.CategoryID = p.CategoryID
);

-- ============================================================
-- Bonus
-- ============================================================

-- 7. Find products cheaper than the average price
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM Products);

-- 8. Find customers who have placed at least one order
SELECT CustomerID
FROM Customers
WHERE CustomerID IN (
	SELECT CustomerID FROM Orders
)

-- 9. Find products never ordered (use subquery, not JOIN)
SELECT *
FROM Products
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM [Order Details]
);

-- 10. Find employees who handled more than 10 orders
SELECT EmployeeID, COUNT(OrderID) TotalOrders
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(OrderID) > 10;
