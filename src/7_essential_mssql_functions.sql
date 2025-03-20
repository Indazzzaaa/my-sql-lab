-- [Numeric Functions]
SELECT ROUND(3.14178,2);
SELECT TRUNCATE(3.14178,2);
SELECT CEILING(5.2);
SELECT FLOOR(5.2);
SELECT ABS(-5.2);
SELECT RAND(); -- 0-1


-- [String Functions]
SELECT LENGTH('SKY');
SELECT LOWER('SKY');
SELECT UPPER('SKY');
SELECT LTRIM('  SKY  '); -- left trim
SELECT RTRIM('  SKY  '); -- right trim
SELECT TRIM('  SKY  '); -- any leading or trailing
SELECT LEFT('APPLE', 3); -- from left 3 char 
SELECT RIGHT('APPLE', 3); -- from right 3 char
SELECT SUBSTRING('APPLE of ours', 3, 5); -- start 3 and length 5 
SELECT LOCATE('n', "Kindergarten"); -- 0 or first occurance of substring
SELECT CONCAT('first', 'last');
SELECT CONCAT(first_name, ' ', last_name) as full_name
FROM customers;
-- And many more


-- [Date and time functions]
SELECT NOW(), CURDATE(), CURTIME();
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAY(NOW());
SELECT HOUR(NOW());
SELECT DAYNAME(NOW());
SELECT MONTHNAME(NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(YEAR FROM NOW());

-- Formatting Date and Time
-- 'YYYY-MM-DD`
SELECT DATE_FORMAT(NOW(), '%Y');
SELECT DATE_FORMAT(NOW(), '%M %d %y');
SELECT DATE_FORMAT(NOW(), '%H:%i:%p');

-- Calculating Dates and Time
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);
SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR);
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);
SELECT DATEDIFF('2019-01-05 09:00', '2019-01-01 17:00'); -- only days difference
SELECT TIME_TO_SEC('9:00') - TIME_TO_SEC('09:02');

-- [Other Usefull functions]


-- Ley say instead of null I want to show custom message
use sql_store;
SELECT
    order_id,
    IFNULL(shipper_id, 'Not assigned') AS shipper
FROM orders;


SELECT
    order_id,
    -- COALESCE returns first not null value in the list and if all null then fallback 'not assigned' will be returned.
    COALESCE(shipper_id, comments, 'Not assigned') AS shipper
FROM orders;


-- [if Function]
-- IF(epxression, first, second)  if expression is true `first` value is returned otherwise `second` value will be returned.

SELECT
    order_id,
    order_date,
    IF(
        YEAR(order_date)= YEAR(NOW()),
        'Active',
        'Archived'
        ) AS category
FROM orders;


-- [Case Operator]
-- To allow multiple test expressions

SELECT
    order_id,
    order_date,
    CASE
        WHEN YEAR(order_date) = YEAR(NOW()) THEN 'ACTIVE'
        WHEN YEAR(order_date) >= YEAR(NOW()) - 7 THEN 'Last 7 Years'
        WHEN YEAR(order_date) < YEAR(NOW()) - 7 THEN 'Archived'
        ELSE 'FUTURE' -- if none of above ran then it will run
    END AS category
FROM orders;
        