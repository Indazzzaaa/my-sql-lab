-- If we desing our index, then mysql can use that indexes to do sorting as well.
-- But if we see, it's using filesort that means none of index could perform this sorting and filesort is vary expensive operation.

-- Let say we have composite columns (a,b)
-- These are the ways mysql can use to sort our data
-- a ✅
-- a,b ✅
-- a DESC, b DESC ✅
-- b ✅
-- a, c, b ❌
-- a, b DESC ❌


use sql_store;
EXPLAIN SELECT customer_id FROM customers
ORDER BY points;
SHOW STATUS LIKE 'last_query_cost'; -- its mysql vairable to tell us cost of last query executed.


-- Decision to make while creating indexes
-- 1. Look at where clause
-- 2. Then look at the columns in order by clause.(Whether we can include them in our index, so we can have benefit of index while sorting)
-- 3. Look at the columns in select Clause.


-- [Index Maintaince]
-- Look for Duplicate Inexes (A,B,C) and another (A,B C)
-- Redundant Indexes : (A,B) and another (B), but it's not redundant (B,A)
-- ! Before creating indexes look at the existing indexes. And since every write operation also updates indexes, so drop the unused ones.
