-- So to find something mySQL has to scan every record in the table. Similar to linear searching something.
-- Also in most of the cases indexes are much smaller to fit in the RAM, that's why it also usefull in high performance applications.
-- Internally indexes are stored as binary tree (called B-Tree or B+ Tree)
-- B Tree / B+Tree nothing but M-way tree with constraints.(https://www.youtube.com/watch?v=aZjYr87r1b8&ab_channel=AbdulBari)

-- [Drawbacks of indexes]
-- It will increase the database size.(Because indexes are also stored in db)
-- Slow down the writes query (because for each insert, update, Delete. DB has to update the index of record as well)

-- ! Note : Never create indexes based on the table, instead create them based on the query requirement. It used to speed up the query execution.

EXPLAIN SELECT customer_id FROM customers WHERE state = "CA"

-- Create index to speed up our query
CREATE INDEX idx_state ON customers (state);

SHOW INDEXES IN customers;

-- To Regenerate the Table info like index info
ANALYSE TABLE customers;

-- [Automatic index creation]
-- A primary index is built automatically on a table's primary key. ( Often stored as a clustered index (data rows are physically ordered based on this key in some DBMS like MySQL InnoDB))
-- When we created index above, those are called secondary index.(Data is not physically ordered by this index, May store a reference (like row ID or primary key) to locate the actual row)
-- When we create table MySQL creates index on primary key, and the foreign key automatically.

--[How to index Strings][char, varchar, text, blob]
-- We know that strings can be large, and indexes are also stored in memory so we have to do due dilligent to optimally store only the rquire info for index.

CREATE INDEX idx_lastname on customers (last_name(20)) -- Only including the 20 chars fom start for indexing.

-- So the goal is to have as many unique values so that index can perform better.
SELECT
    COUNT (DISTINCT LEFT(last_name, 1)),
    COUNT (DISTINCT LEFT(last_name, 5)),
    COUNT (DISTINCT LEFT(last_name, 10))
FROM customers;


--! Indexes based on PRIMARY KEY also called as `clustering index` or Primary Key Index
-- Because the data rows in the table are physically stored in the order of the primary key index — i.e., the table is clustered around the primary key.


-- And other are called `Non-Clustering Index` or Secondary Index.

-- ! MySQL includes primary key in each secodary index.
