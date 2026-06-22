# Intro to Data Modelling

---

## What is Data Modelling?

When storing data in a relational database, you need to plan out your tables and the relationships between them before writing any SQL.

---

## The Scenario

- We run an online shop
- We have customers, orders, and products
- Orders can contain multiple products

**First instinct** — put everything in one table:

| OrderID | CustomerName | Product1 | Product2 | Product3 |

This breaks down quickly:
- What if an order has 10 products?
- What if the customer's name changes?
- How do we store multiple orders per customer?
- What if two products share the same name?

---

## Core Concepts

**Entities** — the distinct "things" in your system:
- Customers
- Orders
- Products

**Relationships** — how entities connect:
- Customer → Orders (one-to-many)
- Orders → Products (many-to-many)

**Keys** — anchor points for relationships:
- **Primary Key (PK)** — uniquely identifies a row (usually an ID or numeric value)
- **Foreign Key (FK)** — a column that references a PK in another table, linking the two together

---

## Building the Model

**Step 1 — Customers**

| CustomerID (PK) | Name | Email |

**Step 2 — Orders**

| OrderID (PK) | CustomerID (FK) | OrderDate |

**Step 3 — Products**

| ProductID (PK) | ProductName | Price |

---

## Bridge Tables (Many-to-Many)

One order can contain many products, and one product can appear in many orders. This can't be modelled with a direct foreign key — you need a **bridge table**.

**OrderDetails**

| OrderID (FK) | ProductID (FK) | Quantity |

---

## Final Schema

| Table        | Purpose                              |
|--------------|--------------------------------------|
| Customers    | Who placed the order                 |
| Orders       | When and by whom                     |
| OrderDetails | Which products are in each order     |
| Products     | What is being sold                   |

---

## Example Query

```sql
SELECT *
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;
```

---

## Normalisation Rules

**Rule 1 — No repeating columns**

Bad:
```
Product1, Product2, Product3
```
Good:
```
A separate Products table with one row per product
```

**Rule 2 — Each table represents one thing**

Don't mix customer data and order data in the same table.

**Rule 3 — No duplicated data**

`CustomerName` should live in the Customers table only — not repeated on every order row.
