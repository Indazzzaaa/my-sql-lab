-- [inserting into table]

-- Deafult : Means whatever default was created while creating the colum : eg. AutoIncrement, Null or some default value or some expression.
INSERT INTO
    customers
VALUES (
        DEFAULT, -- Default here means auto AUTO_INCREMENT
        'John',
        'Smith',
        '1990-01-01',
        NULL, -- We can also put Default here means Null in this 
        'address',
        'city',
        'CA',
        DEFAULT -- Instead of NULL we put DEFAULT
    );

-- Other Way by telling column name (flexible since we can change the order of column name)
/* 
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

*/

-- Inserting multiple rows in table
INSERT INTO
    shippers (name)
values ('Shippers1'),
    ('Shippers2'),
    ('Shippers3');

-- Inserting into multiple tables
-- Let say we create an order and having multiple order items.

INSERT INTO
    orders (
        customer_id,
        order_date,
        status
    )
VALUES (1, '2019-01-02', 1);

INSERT INTO
    order_items
VALUES (LAST_INSERT_ID(), 1, 1, 2.95), -- LAST_INSERT_ID() returns the last automatically generated AUTO_INCREMENT value for the current session (connection). Which will be Orders id
    (LAST_INSERT_ID(), 2, 1, 3.95);

-- [Subqueries : Using Select as subqueries]
-- Always first subqueries runs then actual query get chance to run.

-- 1. Copy the entire table
-- Change : it will create order_achieved table with name data but there won't be any keys property. But other properties will be respected like not null, default values.
CREATE TABLE orders_archived AS SELECT * FROM orders;
-- Similarly we can put all the complex statements like filtering etc.

-- 2. Inserting multiple rows using the subqueries.
INSERT INTO
    orders_archived
SELECT *
FROM orders
WHERE
    order_date < '2019-01-01';

-- [Updating Data]

-- Updating single row
use sql_invoicing;

UPDATE invoices
SET
    payment_total = DEFAULT,
    payment_date = NULL
WHERE  -- if we ommit WHERE clause then all records will be updated
    invoice_id = 1;

-- Updating multiple Rows
-- Note mysql work bench runs on safe update mode which allows on 1 record to be udpated at a time.
UPDATE invoices
SET 
    payment_total = invoices_total*.5, 
    payment_date = due_date
WHERE client_id IN (3,4); 

-- using subqueries in update
UPDATE invoices
SET 
    payment_total = invoices_total*.5, 
    payment_date = due_date
WHERE client_id  IN 
                (SELECT client_id 
                FROM clients 
                WHERE state IN ('CA', 'NY')) ;


-- [Deleting Rows]
DELETE FROM invoices 
WHERE invoice_id = 1 -- if no WHERE clause then it will delete all rows
