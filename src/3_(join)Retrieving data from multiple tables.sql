-- * Read join.md first.


-- #region Summary
/* 
- JOINS : Inner, Self, Compound, Implicit, Outer ( LEFT JOIN, RIGHT JOIN, FULL JOIN )
- UNION

 */

-- #endregion Summary


-- [Inner Joins]
-- Retrive records with matching values in both tables.
SELECT customers.first_name, orders.order_id
FROM customers
    INNER JOIN orders -- could have used JOIN only (it's default mean INNER JOIN)
    ON customers.customer_id = orders.customer_id;

-- [Joining Across Databases]
-- Purpose: Joining tables from different databases.
/* 
- Syntax
SELECT columns
FROM database1.table1 AS alias1
INNER JOIN database2.table2 AS alias2
ON alias1.common_column = alias2.common_column;


*/

-- [Self Joins]
-- Purpose: Joining a table to itself.
use sql_hr;
-- Change database to sql_hr.
SELECT E1.first_name as Employee, E2.first_name as Manager
FROM employees AS E1
    INNER JOIN employees AS E2 ON E1.reports_to = E2.employee_id;
/* Use to list employees along side there managers.  */

-- [Joining  Multiple Tables]
-- Purpose: Combining more than two tables in a single query.
-- eg. Query retiving customer name, their orders, and the products in those orders.

/* 
- Syntax
SELECT table1.column, table2.column, table3.column
FROM table1
JOIN table2 ON table1.common_column = table2.common_column
JOIN table3 ON table2.common_column = table3.common_column;

*/

use sql_store;

SELECT customers.first_name, orders.order_id, products.name
FROM
    customers
    JOIN orders ON customers.customer_id = orders.customer_id
    JOIN order_items ON orders.order_id = order_items.order_id
    JOIN products ON order_items.product_id = products.product_id;

-- [Compound Join]
-- Purpose : Use multiple conditions in a join to refine data retrieval.
/* 
SELECT columns
FROM table1
JOIN table2
ON table1.column1 = table2.column1
AND table1.column2 = table2.column2;
*/

-- Retrive order items along with their correspoinding notes.
use sql_store;

SELECT oi.order_id, oi.product_id, oin.note, oin.product_id as order_item_pid
FROM
    order_items AS oi
    JOIN order_item_notes AS oin ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;

-- [Implicit Join]
-- Purpose : Perform joins using the WHERE clause  without explicit JOIN keyword.
SELECT customers.first_name, orders.order_id
FROM customers, orders
WHERE customers.customer_id = orders.customer_id;

-- [Outer Joins]
-- Purpose : Retrive records with matching values in both tables, and all records from one table.
-- Types : LEFT JOIN, RIGHT JOIN, FULL JOIN

-- LEFT : All records from left and matching from right
SELECT customers.first_name, orders.order_id
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id;

-- RIGHT : All records from right nad matching from left.
SELECT customers.first_name, orders.order_id
FROM customers
RIGHT JOIN orders ON customers.customer_id = orders.customer_id;

-- FULL : All records from both tables.
/* 
 - This is how it works
 1. It finds the common entires and retuns it.
 2. Now there will be some record on left and some on right which do not match, and the columns which are not present in the other table will be NULL.
 3. It will return all the records from left and right with NULL values for the columns which are not present in the other table.

 */
SELECT customers.first_name, orders.order_id
FROM customers
FULL JOIN orders ON customers.customer_id = orders.customer_id;

-- [Cross Join]
-- Purpose : Retrive all possible combinations of rows from two tables.
/*
- Syntax 
  SELECT columns
  FROM table1
  CROSS JOIN table2;

 */

-- [USING clause]
-- Purpose : write short join syntex. Can be used with both inner and outer join.
SELECT *
FROM order o
JOIN customers c
    -- ON o.customer_id = c.customer_id
    USING (customer_id) -- if column name is same then we can use using clause.

SELECT *
FROM order_items oi
JOIN order_item_notes oin
    /* ON oi.order_id = oin.order_id AND
        oi.product_id = oin.product_id */
    USING (order_id, product_id) -- simplify above query.


-- [Unions]
-- Purpos : To combine rows from multiple tables
-- ! Both of queries must return same number of columns otherwise we'll get error.
-- And let say both returns records in 2 columns, so whatever the name of first query column name that will be the name of entire result returned.
SELECT order_id, order_date, 'Active' as status
FROM orders
WHERE order_date >= '2019-01-01'
UNION -- combine result from multiple queries and both table can be different.
SELECT order_id, order_date, 'Archived' as status
FROM orders
WHERE order_date < '2019-01-01';



