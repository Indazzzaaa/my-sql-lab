-- See indexes helps to find our record faster, and index are so small compare to our table such that mysql puts it in RAM, and the do opeeration based on that then search for record from disk.
-- So performing, querying anything on indexes are faster since everything is done on RAM.

-- So when we run our queries with `Explain` it select type, 1. Simple  2. Index


-- Sql ingnores the index when we embedded expression in our Query
use sql_store;
EXPLAIN SELECT customer_id FROM customers
-- WHERE points + 10 > 2010; --! Full scan
WHERE points > 2020;