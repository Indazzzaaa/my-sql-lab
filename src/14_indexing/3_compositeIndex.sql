-- We know that when we create index, and when we do any write operation all those index updates, like if we have created 10 index all 10 will update.

-- So composite index comes for rescue, it creates one index with multiple columns, and there are maximum 16 columns we can include in composite index but that not what we should go for each time.

USE sql_store;
CREATE INDEX idx_state_points ON customers (state, points);
EXPLAIN SELECT customer_id FROM customers
WHERE state ='CA' AND points > 1000;

SHOW INDEXES IN customers;
DROP INDEX idx_state ON customers;

-- [Order of columns in Composite Index]
-- Put the most frequently used cloumns first.
-- Put the columns with highest cardinality first. (eg. M/F colums will have only 2 cardinality which is bed)
-- Always Take your queries into account.

-- Let's compare the rows to scan by sql to decide which index will perform better,(Lower the number better the performance).
CREATE INDEX idx_lastname_state ON customers (last_name, state);
CREATE INDEX idx_state_lastname ON customers (state, last_name);


EXPLAIN SELECT customer_id
FROM customers
-- USE INDEX (idx_lastname_state) we can force MySQL to use this index if we want.
WHERE state='CA' AND last_name LIKE 'A%';

