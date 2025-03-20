-- Used to save our quries and subquires which can be re-used later.
-- Views don't stores data, data is still stored in actual table it just query.
-- Some time we don't have permissions to access table directly so in those cases we modify data only using views.

/* 
[Other Benefits of Views]
- Simplify Queries
- Reduce the impact of changes to our database design.
- Restrict access to the data.
 */

USE sql_invoicing;

-- Let say total sales for each client
CREATE VIEW sales_by_client AS -- After executing see in views
SELECT
    c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i using (client_id)
GROUP BY client_id, name;

-- Now use above view created
-- WE can do anything as we would do with normal table(Relation)
SELECT *
FROM sales_by_client
ORDER BY total_sales DESC;


--  [Altering or dropping view]

-- Drop view
DROP VIEW sales_by_client; -- check in database view will be deleted

-- Another way to replace the view or create if view does not exits
-- So we don't have to drop view first to create/modify the previous stored views.
CREATE OR REPLACE VIEW sales_by_client AS
SELECT
    c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i using (client_id)
GROUP BY client_id, name;


-- [Updatable views]
-- If we don't have below mention things in our view then we called updatable view which means we can we can update data through it.

/* 
-- DISTINCT
-- Aggregate Functions (MIN, MAX, SUM...)
-- GROUP BY / HAVING
-- UNION

 */

 CREATE OR REPLACE VIEW invoices_with_balance AS
 SELECT
    invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total ) > 0
WITH CHECK OPTION ; -- This will prevent update or delete statements from excluding rows from views.

-- Now use view to update data
DELETE FROM invoices_with_balance
WHERE invoice_id = 1;
UPDATE  invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;


-- [The With Option Check Clause]
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 2; -- This will be removed from view, think why? For checking this first comment WITH CHECK OPTION .

