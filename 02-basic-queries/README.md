# Basic Queries

---

## What This Covers

The fundamentals of reading data from a single table with `SELECT`: choosing columns, filtering rows with `WHERE`, pattern matching with `LIKE`, combining conditions, and sorting results with `ORDER BY`.

See [basic_queries.sql](basic_queries.sql) for the worked examples against the Northwind database.

---

## Core Clauses

- **`SELECT`** — choose which columns to return (`*` for all, or a named list)
- **`FROM`** — the table to read from
- **`WHERE`** — filter rows by a condition
- **`ORDER BY`** — sort the results (`ASC` by default, `DESC` for descending)

```sql
SELECT FirstName, LastName, City
FROM Employees
WHERE City = 'London'
ORDER BY LastName;
```

---

## Filtering with WHERE

- **Comparison:** `=`, `<>`, `>`, `<`, `>=`, `<=`
- **Combining:** `AND`, `OR`
- **Pattern matching:** `LIKE` with `%` (any sequence of characters) — e.g. `City LIKE 'B%'` finds cities starting with `B`

```sql
-- Products stored in jars or bottles
SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%jars'
   OR QuantityPerUnit LIKE '%bottles';
```

---

## Next Steps

Once comfortable here, move on to [03-joins](../03-joins/README.md) to combine data across multiple tables.
