# 🚲 02 — BikeStores Sales Database

> **12 business-driven SQL queries analyzing sales performance, inventory levels, customer behavior, and staff workload for a multi-store bicycle retail company.**

---

## 📌 Database Overview

The BikeStores database models a multi-store retail operation:

| Schema | Table | Description |
|--------|-------|-------------|
| `sales` | `customers` | Customer records |
| `sales` | `orders` | Order headers |
| `sales` | `order_items` | Order line items with price & discount |
| `sales` | `stores` | Store locations |
| `sales` | `staffs` | Sales staff records |
| `production` | `products` | Product catalog |
| `production` | `categories` | Product categories |
| `production` | `brands` | Brand records |
| `production` | `stocks` | Store inventory levels |

---

## 📊 Queries Overview

| # | Requested By | Business Question | Concepts Used |
|---|-------------|-------------------|---------------|
| Q1 | Sales Manager | Top 10 customers by order count | `COUNT`, `GROUP BY`, `TOP`, `INNER JOIN` |
| Q2 | Inventory Manager | Top 20 lowest-stock products | `SUM`, `ISNULL`, `LEFT JOIN`, `ORDER BY ASC` |
| Q3 | Product Manager | Product count per category | `COUNT`, `GROUP BY`, `INNER JOIN` |
| Q4 | Sales Manager | Yearly sales quantity per product | `YEAR()`, `SUM`, multi-table JOIN |
| Q5 | Product Manager | Products never sold | `LEFT JOIN`, `WHERE IS NULL` |
| Q6 | Sales Manager | Top customers by total revenue | Custom Function, `SUM`, `ORDER BY DESC` |
| Q7 | Product Manager | Total revenue per category | Custom Function, multi-table JOIN |
| Q8 | Operations Manager | Total orders processed per store | `COUNT`, `LEFT JOIN`, `GROUP BY` |
| Q9 | HR Manager | Total orders handled per staff member | `COUNT`, `LEFT JOIN` |
| Q10 | Production Manager | Product count per brand | `COUNT`, `LEFT JOIN`, `ORDER BY DESC` |
| Q11 | Marketing Manager | One-time customers only | `HAVING COUNT = 1` |
| Q12 | Marketing Manager | Repeat customers (loyalty candidates) | `HAVING COUNT > 1` |

---

## 💡 Key Highlights

**Custom Scalar Function (Q6 & Q7):**
```sql
CREATE FUNCTION sales.Total_Amount_Sales(
    @quantity INT,
    @list_price DEC(10,2),
    @discount DEC(4,2)
)
RETURNS DEC(10,2)
AS
BEGIN
    RETURN (@quantity * @list_price * (1 - @discount))
END;
```
This function encapsulates the revenue calculation logic — making queries reusable, clean, and maintainable across multiple reports.

**Q5 — Products Never Sold:**
```sql
WHERE I.product_id IS NULL
```
Using `LEFT JOIN` + `NULL` filter to identify products with zero sales — a common inventory optimization technique.

**Q11 & Q12 — Customer Segmentation:**
Using `HAVING COUNT = 1` vs `HAVING COUNT > 1` to split customers into one-time buyers vs repeat buyers — directly supporting loyalty program targeting.

---

## 💼 Business Context

Every query in this project was written in response to a specific business stakeholder request — simulating real corporate reporting workflows:

- **Sales Manager** → Revenue and customer performance
- **Inventory Manager** → Stock risk and product availability
- **Marketing Manager** → Customer segmentation and retention
- **HR Manager** → Staff workload distribution
- **Operations Manager** → Store performance comparison

---

## 🛠️ How to Run

1. Restore the BikeStores database in SSMS (load_data.sql)
2. Open `BikeStores_Queries.sql`
3. Run queries individually or all at once

---

[← Back to Portfolio](../README.md)
