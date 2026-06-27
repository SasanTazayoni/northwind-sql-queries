-- Stored Procedure Exercises

-- 1. Create an SP to return all products.
CREATE PROCEDURE GetAllProducts
AS
BEGIN
  SELECT * FROM Products;
END;

-- 2. Create an SP that inserts a product into the Products table.
CREATE PROCEDURE InsertProduct
  @ProductName NVARCHAR(40),
  @SupplierID INT,
  @CategoryID INT,
  @QuantityPerUnit NVARCHAR(20),
  @UnitPrice MONEY,
  @UnitsInStock SMALLINT,
  @UnitsOnOrder SMALLINT,
  @ReorderLevel SMALLINT,
  @Discontinued BIT
AS
BEGIN
  INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
  VALUES (@ProductName, @SupplierID, @CategoryID, @QuantityPerUnit, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @ReorderLevel, @Discontinued);
END;

-- 3. Create an SP that updates a product's price.
CREATE PROCEDURE UpdateProductPrice
  @ProductID INT,
  @UnitPrice MONEY
AS
BEGIN
  UPDATE Products
  SET UnitPrice = @UnitPrice
  WHERE ProductID = @ProductID;
END;

-- 4. Create an SP that finds high value customers using conditional logic.
CREATE PROCEDURE GetHighValueOrders
AS
BEGIN
  SELECT
    o.CustomerID,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalSpend,
    CASE
      WHEN SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) > 20000 THEN 'High'
      WHEN SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) > 5000 THEN 'Medium'
      ELSE 'Low'
    END AS CustomerValue
  FROM Orders o
  JOIN [Order Details] od ON od.OrderID = o.OrderID
  GROUP BY o.CustomerID;
END;

-- 5. Create an SP that finds orders per employee, using parameters.
CREATE PROCEDURE GetOrdersByEmployee
  @EmployeeID INT
AS
BEGIN
  SELECT *
  FROM Orders
  WHERE EmployeeID = @EmployeeID;
END;

-- 6. Create an SP that takes a minimum order value and returns orders above that value.
CREATE PROCEDURE GetOrdersAboveMinValue
	@MinOrderValue MONEY
AS
BEGIN
	SELECT OrderID, ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) AS OrderTotal
	FROM [Order Details]
	GROUP BY OrderID
	HAVING ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) > @MinOrderValue
END;

-- 7. Create an SP that takes @CustomerID and returns:
--    - Total number of orders
--    - Total spend
--    - Average order value
--    - Customer category: "High Value" (> 1000), "Medium" (500-1000), "Low" (< 500)
CREATE PROCEDURE GetCustomerSummary
  @CustomerID NCHAR(5)
AS
BEGIN
  SELECT
    o.CustomerID,
    COUNT(od.OrderID) AS TotalOrders,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalSpend,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) / COUNT(DISTINCT od.OrderID), 2) AS AverageOrderValue,
    CASE
      WHEN ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) > 1000 THEN 'High'
      WHEN ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) > 500 THEN 'Medium'
      ELSE 'Low'
    END AS CustomerValue
  FROM [Order Details] od
  JOIN Orders o ON o.OrderID = od.OrderID
  WHERE o.CustomerID = @CustomerID
  GROUP BY o.CustomerID;
END;

