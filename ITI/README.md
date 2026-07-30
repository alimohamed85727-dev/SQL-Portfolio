# 🎓 01 — ITI Academic Database

> **15 SQL queries analyzing student records, instructor data, departments, and course enrollments using the ITI training database.**

---

## 📌 Database Overview

The ITI database models an academic institution with the following entities:

| Table | Description |
|-------|-------------|
| `Student` | Student records with age, department, supervisor |
| `Instructor` | Instructor records with salary and department |
| `Department` | Department information |
| `Course` | Course catalog |
| `Topic` | Course topics |
| `Stud_Course` | Student-course enrollment with grades |

---

## 📊 Queries Overview

| # | Business Question | Concepts Used |
|---|-------------------|---------------|
| Q1 | Count students with a recorded age | `COUNT`, `WHERE IS NOT NULL` |
| Q2 | All unique instructor names | `DISTINCT` |
| Q3 | Student ID, full name, department (null-safe) | `CONCAT`, `ISNULL`, `LEFT JOIN` |
| Q4 | All instructors with their department (including unassigned) | `LEFT JOIN` |
| Q5 | Students and courses where grade exists | `INNER JOIN` (3 tables), `WHERE` |
| Q6 | Number of courses per topic | `GROUP BY`, `COUNT`, `RIGHT JOIN` |
| Q7 | Max and min instructor salary | `MAX`, `MIN` |
| Q8 | Instructors earning below average salary | Subquery, `AVG` |
| Q9 | Department of the lowest-paid instructor | Subquery, `MIN`, `INNER JOIN` |
| Q10 | Top 2 instructor salaries | `TOP`, `ORDER BY DESC` |
| Q11 | Instructor name with salary (null → "instructor bonus") | `COALESCE`, `CAST` |
| Q12 | Average instructor salary | `AVG` |
| Q13 | Student and their supervisor's name | Self JOIN |
| Q14 | Top 2 salaries per department | `DENSE_RANK()`, Window Function |
| Q15 | Random student from each department | `ROW_NUMBER()`, `NEWID()`, Window Function |

---

## 💡 Key Highlights

- **Q14** uses `DENSE_RANK() OVER (PARTITION BY Dept_Id ORDER BY Salary DESC)` — ranking salaries within each department independently
- **Q15** uses `ROW_NUMBER() OVER (PARTITION BY Dept_Id ORDER BY NEWID())` — randomized selection per department, a common real-world HR reporting technique
- **Q3** handles NULL department values gracefully using `ISNULL` — critical for production-quality reporting

---

## 🛠️ How to Run

1. Restore or connect to the ITI database in SSMS
2. Open `ITI_Queries.sql`
3. Run queries individually or all at once

---

[← Back to Portfolio](../README.md)
