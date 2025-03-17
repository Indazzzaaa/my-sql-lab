-- [Aggregate Functions]
-- MAX, MIN, AVG, SUM, COUNT
-- These aggregate functions only operate on non-null values.
-- These does not care about the duplicate values so we have to use DISTINCT with them.

use sql_invoicing;
SELECT 
    MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total*1.1) AS total,
    COUNT(payment_date) AS count_of_payments,
    COUNT(*) AS total_records, -- way to get all records count irrespective of null
    COUNT(DISTINCT client_id ) AS distinct_records 
FROM invoices

-- [Group By Clause]

-- let say we want to see total sells done by each client
SELECT 
    client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoices_date >= '2019-07-01'
GROUP BY client_id -- by default result will be sorted on basis of this
ORDER BY total_sales DESC -- Please take note of order of clauses it matters.

-- Using multiple colums in grup by
-- Eg. there are multiple city in each state and we want data for each state.

use sql_invoicing;
SELECT
    state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients USING (client_id)
GROUP BY state, city --  treat each (state, city) pair separately

-- [Having Clause]
-- How we can get total sales > 500
-- Using Having clause, it help in filter data after the Group By
-- With Where clause we can only filter data before our rows are group.

use sql_invoicing;
SELECT
    client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5; -- But the colums used in this clause have to be part of the select clause. While this is not necessay in where clause.


-- [RollUP Operator]
-- Helps to get let say we have total sales per client but what will be the total sales of all clients combined.
-- Only Availabe in MYSQL not the part of SQL language.

SELECT
    client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP; 