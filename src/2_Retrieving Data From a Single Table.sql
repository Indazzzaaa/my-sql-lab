
-- #region Summary
/* 
- SELECT : is used to retrieve data from a table.
- WHERE : is used to filter records.
- AND, OR, NOT : are used to combine multiple conditions in WHERE clause.
- IN : is used to specify multiple values in a WHERE clause.
- BETWEEN : is used to filter records based on a range of values.
- LIKE : is used in a WHERE clause to search for a specified pattern in a column.
- REGEXP : is used to specify a regular expression pattern in a WHERE clause.
- IS NULL : Purpose is to check NULL values in a column.
- ORDER BY : is used to sort the result set in ascending or descending order.
- LIMIT : is used to specify the number of records to return.
 */

-- #endregion Summary


--[ SELECT ] : is used to retrieve data from a table.
-- By column name
SELECT first_name, last_name
FROM customers;

-- Selecting all columns / showing the entire table
SELECT *
FROM customers;

-- We can Rename colums(aliases) as well
SELECT first_name AS "First Name", last_name AS Surname
FROM customers;

-- [WHERE] : is used to filter records.
SELECT first_name, last_name
FROM customers
WHERE state = 'CA';

-- [AND, OR, NOT] : are used to combine multiple conditions in WHERE clause.
SELECT * 
FROM customers
WHERE state = 'CA' AND city = 'Visalia'; /* Similarly we can use OR */

-- Use of NOT
SELECT *
FROM customers
WHERE NOT state = 'CA';
-- WHERE NOT (state = 'CA' AND city = 'Visalia'); 

-- [IN] : is used to specify multiple values in a WHERE clause.
SELECT *
FROM customers
WHERE state IN ('CA', 'NY', 'TX');

-- [BETWEEN] : is used to filter records based on a range of values.
SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000; /* 1000 <= x <= 3000 */

-- [LIKE] : is used in a WHERE clause to search for a specified pattern in a column.

-- #region About patterns used with Likes
/* 
- Here are symbols represented in LIKE clause:
- % : 0 or more characters.
    eg. 'J%' : any Starts with J, '%J' : any Ends with J, '%J%' : any Contains J.

- _ : Represents a single character.    
    eg. 'J__' : any 3 letter word starting with J.

- Square Bracket [] : Represents any single character within the brackets.
    eg. 'J[aeiou]%' : any word starting with J followed by a vowel.

- Caret (^) or Exclamation Mark (!) inside square brackets: Represents any single character not within the brackets.
    eg. 'J[^aeiou]%' : any word starting with J followed by a consonant.

- Hyphen (-) inside square brackets: Represents a range of characters.
    eg. 'J[A-M]%' : any word starting with J followed by a letter from A to M.
 */

-- #endregion

SELECT *
FROM customers
WHERE first_name LIKE 'J%'; /* Starts with J */

-- [REGEXP] : is used to specify a regular expression pattern in a WHERE clause.
-- This is more powerful than LIKE.

-- #region About Regular Expressions
/* 
- ^ : Starts with. eg. '^J' : Starts with J.
- $ : Ends with. eg. 'J$' : Ends with J.
- . : Any single character. eg. 'J.n' : Starts with J, followed by any character, ends with n.
- * : 0 or more occurrences of the preceding element. eg. 'J.*' : any word starting with J. followed by 0 or more characters.
- + : 1 or more occurrences of the preceding element. eg. 'J.+' : any word starting with J followed by 1 or more characters.
- ? : 0 or 1 occurrence of the preceding element. eg. 'J.?' : any word starting with J followed by 0 or 1 character.
- [] : Represents any single character within the brackets. eg. 'J[aeiou]' : any word starting with J followed by a vowel.
- [^] : Represents any single character not within the brackets. eg. 'J[^aeiou]' : any word starting with J followed by a consonant.
- | : Acts as an OR operator. eg. 'J|K' : any word starting with J or K
- () : Groups expressions. eg. '(J|K)ohn' : any word starting with J or K followed by ohn.
    eg. '^(John|Jane)' : any word Starts with John or Jane
- {n} : Exactly n occurrences of the preceding element. eg. 'J.{2}' : any word starting with J followed by 2 characters.
- {n,} : n or more occurrences of the preceding element. eg. 'J.{2,}' : any word starting with J followed by 2 or more characters.
- {n,m} : n to m occurrences of the preceding element. eg. 'J.{2,4}' : any word starting with J followed by 2 to 4 characters.
- \ : Escape character. eg. '\.' : any word containing a dot.
- \d : Any digit. eg. '\d{3}' : any word containing 3 digits.
- \D : Any non-digit. eg. '\D{3}' : any word containing 3 non-digits.
- \w : Any word character. eg. '\w{3}' : any word containing 3 word characters.
- \W : Any non-word character. eg. '\W{3}' : any word containing 3 non-word characters.
- \s : Any whitespace character. eg. '\s{3}' : any word containing 3 whitespace characters.
- \S : Any non-whitespace character. eg. '\S{3}' : any word containing 3 non-whitespace characters.
- \b : Word boundary. eg. '\bJ' : any word starting with J.
- \B : Non-word boundary. eg. '\BJ' : any word not starting with J.

AND MANY MORE...
 */

-- #endregion 

SELECT *
FROM customers
WHERE first_name REGEXP '^J'; /* Starts with J */

-- [IS NULL] : Purpose is to check NULL values in a column.
SELECT *
FROM customers
WHERE phone IS NULL;

-- [ ORDER BY ] : is used to sort the result set in ascending or descending order.
-- #region About ORDER BY Syntax
/* 
  SELECT column1, column2, ...
  FROM table_name
  ORDER BY column1 [ASC|DESC], column2 [ASC|DESC], ...;
 */
-- #endregion
SELECT *
FROM customers
ORDER BY first_name ASC, last_name DESC; /* First Sort by ASC on first_name, the DESC on last_name having two same first_name */

-- [ LIMIT ] : is used to specify the number of records to return.
-- used to create the pagination.
SELECT *
FROM customers
-- LIMIT 5; /* Returns first 5 records */
-- LIMIT 5 OFFSET 5; /* Returns 5 records starting from 6th record */
LIMIT 3, 20; /* Returns 20 records starting from 4th record */
