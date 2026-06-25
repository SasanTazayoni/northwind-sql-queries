-- Advanced Join Exercises

-- 1. Products Never Ordered
-- Find all products that have never appeared in an order.
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;

-- 2. Full Order Breakdown
-- Create a table showing OrderID, Customer Name, Product Name, Quantity, Unit Price, and any other columns you want to include.
SELECT
    od.OrderID,
    c.ContactName,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    o.OrderDate
FROM [Order Details] od
JOIN Orders o ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductID = od.ProductID;

-- 3. Average Order Value per Customer
-- For each customer show: number of orders, total spend, and average order value.
SELECT
	c.CompanyName,
	COUNT(DISTINCT o.OrderID) AS NumberOfOrders,
	ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSpend,
	ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) / COUNT(DISTINCT o.OrderID), 2) AS AverageValue
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.CompanyName;

-- 4. Employees with No Orders
-- Find employees who have not been assigned any orders. Same pattern as customers with no orders.
SELECT e.FirstName, e.LastName
FROM Employees e
LEFT JOIN Orders o ON o.EmployeeID = e.EmployeeID
WHERE o.OrderID IS NULL;

-- 5. Most Popular Product
-- Which product has been ordered the most (by quantity)?
SELECT TOP 1 p.ProductName, SUM(od.Quantity) AS TotalQuantitySold
FROM [Order Details] od
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantitySold DESC;

-- 6. Customers with Declining orders
-- Are there any customers that placed fewer orders in 1997 than 1996?
SELECT
	c.ContactName,
	COUNT(CASE WHEN YEAR(o.OrderDate) = 1996 THEN 1 END) AS Orders1996,
    COUNT(CASE WHEN YEAR(o.OrderDate) = 1997 THEN 1 END) AS Orders1997
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.ContactName
HAVING 
	COUNT(CASE WHEN YEAR(o.OrderDate) = 1997 THEN 1 END) < 
    COUNT(CASE WHEN YEAR(o.OrderDate) = 1996 THEN 1 END);

-- 7. Product Pairings
-- Find products that are commonly ordered together.
SELECT od1.ProductID, od2.ProductID, COUNT(*) AS TimesBoughtTogether
FROM [Order Details] od1
JOIN [Order Details] od2 ON od2.OrderID = od1.OrderID
WHERE od1.ProductID < od2.ProductID
GROUP BY od1.ProductID, od2.ProductID
ORDER BY TimesBoughtTogether DESC;

-- 8. Territory performance
-- Show total revenue per territory including Territory Name, Employee Count, Revenue.

