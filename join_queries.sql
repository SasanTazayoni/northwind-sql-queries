-- 1. Customers and their Orders
SELECT *
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2. Orders with Product Names
SELECT od.OrderID, p.ProductName
FROM [Order Details] od
JOIN Products p ON p.ProductID = od.ProductID

-- 3. Order Total Value

-- 4. Total Spend and Number of Orders

-- 5. Top 5 Customers by Spend

-- 6. Customers with no Orders

-- 7. Orders with Customer and Employee Info

-- 8. Product Sales by Category
