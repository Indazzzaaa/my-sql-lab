-- Full text index : Used to design the search engine type of feature.
-- SQL gives relevancy score to each result (between 0-1)
-- It has two modes
-- 1. Natural Language Mode : Default
-- 2. Boolean Mode : we'll see this later

-- ! This index uses inverted index data structure, where it store each workd in there root froms and all the rows(or columns) it occured into.

use sql_blog;

CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);

-- Now do the full text search 
SELECT *
FROM posts
WHERE MATCH(title, body) AGAINST('react redux');
-- ! In match we have to pass all those columns which we have passed while creating the index. Otherwise MySql will give error.

-- To see Relevancy
SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('react redux');

-- To do search in boolean mode
SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('react -redux' IN BOOLEAN MODE);
-- '-redux' must not have redux in the result.
-- '+redux' must have redux in the result;
-- '"handling a from"' must have the full pharase in same sequence.

SHOW INDEXES in posts;