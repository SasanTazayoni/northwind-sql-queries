# CASE Statements & Stored Procedures

---

## CASE Statements

### What are they?

A `CASE` statement is SQL's version of an if/else. It evaluates conditions row by row and returns a value based on the first condition that is true. The result can be used anywhere an expression is valid — `SELECT`, `ORDER BY`, `WHERE`, `GROUP BY`.

### Why use them?

- Add conditional logic directly in a query without needing application-side code
- Categorise or label data on the fly (e.g. "High / Medium / Low")
- Pivot or reshape results
- Control sort order dynamically

### Syntax

There are two forms:

**Searched CASE** — evaluates a boolean condition each time (most flexible):

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE default_result
END
```

**Simple CASE** — compares one expression against fixed values:

```sql
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ...
    ELSE default_result
END
```

`ELSE` is optional but recommended — without it, unmatched rows return `NULL`.

### Simple example

```sql
SELECT
    OrderID,
    Freight,
    CASE
        WHEN Freight < 25  THEN 'Low'
        WHEN Freight < 100 THEN 'Medium'
        ELSE 'High'
    END AS FreightBand
FROM Orders;
```

### Northwind example — label stock levels

```sql
SELECT
    ProductName,
    UnitsInStock,
    CASE
        WHEN UnitsInStock = 0            THEN 'Out of Stock'
        WHEN UnitsInStock < 10           THEN 'Critical'
        WHEN UnitsInStock < 30           THEN 'Low'
        ELSE                                  'Adequate'
    END AS StockStatus
FROM Products
ORDER BY UnitsInStock;
```

### Northwind example — conditional aggregation

`CASE` inside an aggregate lets you count or sum only rows that meet a condition, all in one pass.

```sql
-- Count how many products in each category are discontinued vs active
SELECT
    c.CategoryName,
    COUNT(p.ProductID)                                           AS TotalProducts,
    SUM(CASE WHEN p.Discontinued = 1 THEN 1 ELSE 0 END)         AS Discontinued,
    SUM(CASE WHEN p.Discontinued = 0 THEN 1 ELSE 0 END)         AS Active
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
```

---

## Stored Procedures

### What are they?

A stored procedure (SP) is a named, saved block of SQL that lives in the database and can be executed by name. It can accept input parameters, contain logic (loops, conditionals, variables), and return result sets or output values.

### Why use them?

- **Reusability** — write the logic once, call it anywhere
- **Security** — grant users EXECUTE permission on a procedure without giving them direct table access
- **Performance** — execution plans are cached after the first run
- **Maintainability** — business logic lives in one place; change the SP and every caller benefits

### Syntax

```sql
CREATE PROCEDURE procedure_name
    @param1 datatype,
    @param2 datatype = default_value   -- optional default
AS
BEGIN
    -- SQL statements here
END;
```

Execute it:

```sql
EXEC procedure_name @param1 = value1, @param2 = value2;
```

Modify it:

```sql
ALTER PROCEDURE procedure_name
AS
BEGIN
    -- updated logic
END;
```

Remove it:

```sql
DROP PROCEDURE procedure_name;
```

### Simple example

```sql
CREATE PROCEDURE GetProductsByCategory
    @CategoryID INT
AS
BEGIN
    SELECT ProductName, UnitPrice, UnitsInStock
    FROM Products
    WHERE CategoryID = @CategoryID;
END;

-- Call it:
EXEC GetProductsByCategory @CategoryID = 1;
```

### Northwind example — customer order summary

```sql
CREATE PROCEDURE GetCustomerOrderSummary
    @CustomerID NCHAR(5)
AS
BEGIN
    SELECT
        o.OrderID,
        o.OrderDate,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS OrderValue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.CustomerID = @CustomerID
    GROUP BY o.OrderID, o.OrderDate
    ORDER BY o.OrderDate DESC;
END;

-- Call it:
EXEC GetCustomerOrderSummary @CustomerID = 'ALFKI';
```

### Northwind example — low stock report with threshold parameter

```sql
CREATE PROCEDURE GetLowStockProducts
    @Threshold INT = 10   -- default threshold of 10 units
AS
BEGIN
    SELECT
        p.ProductName,
        p.UnitsInStock,
        c.CategoryName,
        CASE
            WHEN p.UnitsInStock = 0 THEN 'Out of Stock'
            ELSE 'Low'
        END AS StockStatus
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE p.UnitsInStock <= @Threshold
    ORDER BY p.UnitsInStock;
END;

-- Call with default threshold:
EXEC GetLowStockProducts;

-- Call with custom threshold:
EXEC GetLowStockProducts @Threshold = 20;
```

---

## What is DRY? How do SPs help with it?

**DRY** stands for **Don't Repeat Yourself**. The principle states that any piece of logic should have a single, authoritative definition in a system. If you find yourself writing the same code in multiple places, that is a signal to extract it into one reusable unit.

### The problem without DRY

Imagine five different reports all calculate customer total spend the same way:

```sql
-- In report A:
ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2)

-- In report B:
ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2)

-- In report C... D... E...
```

If the business changes the discount logic, you must find and update every copy. Miss one and the reports disagree.

### How SPs enforce DRY

Wrap the logic in a stored procedure once:

```sql
CREATE PROCEDURE GetCustomerSpend
    @CustomerID NCHAR(5)
AS
BEGIN
    SELECT
        o.CustomerID,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSpend
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.CustomerID = @CustomerID
    GROUP BY o.CustomerID;
END;
```

Now every report, application, and script calls:

```sql
EXEC GetCustomerSpend @CustomerID = 'ALFKI';
```

When the discount rule changes, you update **one place** — the SP — and every caller automatically gets the correct result.

### Summary

| Without SPs (WET)             | With SPs (DRY)                   |
|-------------------------------|----------------------------------|
| Logic duplicated across queries | Logic defined once in the SP   |
| Change requires editing many files | Change made in one place   |
| Risk of inconsistency          | All callers stay consistent      |
| No encapsulation               | Permissions controlled via EXEC  |

> **WET** — "Write Everything Twice" — is the informal opposite of DRY. SPs are one of the primary tools SQL gives you to avoid it.
