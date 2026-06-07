-- 1. Customers and their Orders
SELECT *
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2. Orders with Product Names
SELECT od.OrderID, p.ProductName
FROM [Order Details] od
JOIN Products p ON p.ProductID = od.ProductID;

-- 3. Order Total Value
SELECT OrderID,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS Order_Value
FROM [Order Details]
GROUP BY OrderID;

-- 4. Total Spend and Number of Orders
SELECT CustomerID,
	  COUNT(o.OrderID) AS NumberOfOrders,
	  ROUND(SUM(UnitPrice * Quantity * (1-Discount)), 2) AS TotalSpend
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY CustomerID
ORDER BY TotalSpend DESC;

-- 5. Top 5 Customers by Spend
SELECT TOP 5 CustomerID,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalSpend
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY CustomerID
ORDER BY TotalSpend DESC;

-- 6. Customers with no Orders
SELECT c.CustomerID, COUNT(OrderID) AS NumberOfOrders
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL
GROUP BY c.CustomerID;

-- 7. Orders with Customer and Employee Info
SELECT o.OrderID, o.OrderDate, 
    c.ContactName AS CustomerName,
    e.FirstName + ' ' + e.LastName AS EmployeeName
FROM Orders o 
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 8. Product Sales by Category
SELECT c.CategoryName,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS Revenue
FROM Categories c
JOIN Products p
  ON c.CategoryID = p.CategoryID
JOIN [Order Details] od
  ON p.ProductID = od.ProductID
GROUP BY c.CategoryName;