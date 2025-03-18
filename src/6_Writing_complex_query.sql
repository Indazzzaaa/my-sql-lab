-- [Subqueries]

-- Find the products that are more 
-- expensive than Lettuce (id =3)

SELECT *
FROM products
WHERE unit_price > (
    SELECT unit_price
    FROM products
    WHERE product_id = 3
)

-- In Sql_hr database
-- FInd the employees whose earn more than average

USE sql_hr;
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees

)

-- [In operator]
-- Find the products that never been ordered

use sql_store;

SELECT *
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM  order_items
);


-- [Subqueires vs Join]
-- Assuming subqueries and join have same execution time to do same work
-- Always perfer which are more readable.


-- [ALL keyword]
-- Select invoices larger than all invoices of Client 3

use sql_invoicing;

SELECT *
FROM invoices
WHERE invoice_total > (
    SELECT MAX(invoice_total)
    FROM invoices
    WHERE client_id = 3
)

-- Using ALL
-- First subquery will executed
-- Then subquery will return list of values 
-- Now for each invoice total in invoices will be compared agains all values returned from subquery.
SELECT *
FROM invoices
WHERE invoice_total > ALL (
    SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
)

-- [Any or Some Keyword]
-- Select thing where value is greater then any value.
-- Select invoices larger than any invoices of Client 3
SELECT *
FROM invoices
WHERE invoice_total > ANY (
    SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
)

-- Select Clients with at least two invoices
SELECT *
FROM clients
WHERE client_id = ANY( -- we could also use `client_id IN (subquery)`
    SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2
);

-- Correlated Subqueries
-- Find the employees who have salary greater then avg salary in there department.
/* 
Execution Flow : Of Correlated Subqueries.
1. Top query will run row by row, so first it will go to first employee
2. Then for first employee it will run the subquery.
3. If the salary of employee is greater then the returned avg salay then that employee record will be included.
4. Now move to step 1 for next employee.

 */
use sql_hr;
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
)


-- [Exists Operator]
-- Select clients that have an invoices

use sql_invoicing;

-- Way-1 : Using IN
SELECT *
FROM clients
WHERE client_id IN (
    SELECT DISTINCT client_id
    FROM invoices
)

-- Way-2 : using exists operator
-- IT's also correlation query.
-- Faster then IN operator solution. IF there are many records.
SELECT *
FROM clients c
WHERE EXISTS (
    SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
)


-- [Subqueries in the SELECT clause]
-- Give in difference between invoice total and average for all invoices.
use sql_invoicing;
SELECT 
    invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference -- we are not allowed ot use column aliases that's why we used select.
FROM invoices;

-- [Subqueries in From clause]
SELECT *
FROM (
    SELECT 
    invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference -- we are not allowed ot use column aliases that's why we used select.
    FROM invoices
) AS sales_summary -- whenever we use subquery in FROM clause have to give the alias whether we use it or not.
where invoice_total > 150;

