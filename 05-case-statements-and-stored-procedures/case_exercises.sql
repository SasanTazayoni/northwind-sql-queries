-- CASE Exercises

-- 1. Revenue Buckets
-- Using CASE, sort orders into revenue buckets of "Low", "Medium" and "High".
SELECT
  OrderID,
  ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) AS Revenue,
  CASE
    WHEN SUM(Quantity * UnitPrice * (1 - Discount)) < 500 THEN 'Low'
    WHEN SUM(Quantity * UnitPrice * (1 - Discount)) < 2000 THEN 'Medium'
    ELSE 'High'
  END AS RevenueBucket
FROM [Order Details]
GROUP BY OrderID;

-- 2. Stock Status
-- Output ProductName, UnitsInStock and a custom column called "StockStatus" that reflects the level of stock of that item.
SELECT ProductName, UnitsInStock,
  CASE
    WHEN UnitsInStock = 0 THEN 'OUT OF STOCK'
    WHEN UnitsInStock < 20 THEN 'LOW'
    WHEN UnitsInStock < 50 THEN 'MEDIUM'
    ELSE 'HIGH'
  END AS StockStatus
FROM Products
ORDER BY ProductName;

-- 3. Product Price Categories (CASE + Aggregation)
-- Count how many products fall into each price category:
-- Cheap (< 10), Mid (10-20), Expensive (> 20)
SELECT
  CASE
    WHEN UnitPrice < 10 THEN 'Cheap'
    WHEN UnitPrice < 20 THEN 'Mid'
    ELSE 'Expensive'
  END AS PriceCategory,
  COUNT(*) AS ProductCount
FROM Products
GROUP BY
  CASE
    WHEN UnitPrice < 10 THEN 'Cheap'
    WHEN UnitPrice < 20 THEN 'Mid'
    ELSE 'Expensive'
  END;

-- 4. Customer Order Count with Labels (CASE + GROUP BY)
-- Show each customer and label them:
-- "Frequent" (> 10 orders), "Occasional" (<= 10)
SELECT CustomerID, COUNT(OrderID) AS NumberOfOrders,
	CASE
		WHEN COUNT(OrderID) > 10 THEN 'Frequent'
		ELSE 'Occasional'
	END OrderFrequency
FROM Orders
GROUP BY CustomerID

-- 5. Product Sales Buckets (CASE + Aggregation + JOIN)
-- For each product, calculate total quantity sold and categorise:
-- Low (< 50), Medium (50-200), High (> 200)
SELECT
  p.ProductName,
  SUM(od.Quantity) AS TotalSold,
  CASE
    WHEN SUM(od.Quantity) < 50 THEN 'Low'
    WHEN SUM(od.Quantity) < 200 THEN 'Medium'
    ELSE 'High'
  END AS SalesBucket
FROM Products p
JOIN [Order Details] od ON od.ProductID = p.ProductID
GROUP BY p.ProductName;


-- 6. Products Above Category Average (Correlated Subquery + CASE)
-- Return all products and label them "Above Avg" or "Below Avg"
-- based on whether their price is above the average for their category.
SELECT
  ProductName,
  UnitPrice,
  CASE
    WHEN UnitPrice > (SELECT AVG(UnitPrice) FROM Products p2 WHERE p2.CategoryID = p.CategoryID) THEN 'Above Avg'
    ELSE 'Below Avg'
  END AS PriceLabel
FROM Products p;
