-- [Transactions]
-- A group of SQL statements that represents a single unit of work.
-- Either all operations done successfully or in case of partial success or failure we roll-back.

-- [ACID]
/* 
Atomicity : Either all or none
Consistency : Database will be consistent state after the transaction.
Isolation : Every transaction are isolated even they modify same data.
Durability : Once transactions are committed changes made by them are permanant.Even in case of power failure.

*/

 -- ! When Transaction Not Necessary
 /* 
 1. Single, Independent Queries
    - If an INSERT, UPDATE, or DELETE operation is isolated and doesn't depend on other queries, a transaction is not required.
    - Example: A simple DELETE FROM users WHERE id = 5 is independent and doesn’t need a transaction.

2. Read-Only Operations
    - SELECT queries don’t modify data, so they usually don’t require transactions (unless in a repeatable read or serializable isolation mode).
 
*/

-- [Creating Transactions]

-- MySQL wraps ever statement in a transaction and end with commit and we can check the status of transaction using autocommit variable.
-- By default autocommit is ON, so every statement is automatically committed.
SHOW VARIABLES LIKE 'autocommit';

USE sql_store;

START TRANSACTION;

INSERT INTO orders(customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1,1,1);

COMMIT;
-- ROLLBACK: We can use this instead of commit to manually undo the changes made by the transaction.
ROLLBACK;


-- [Concurrency and Locking]

-- When multiple transactions are executed concurrently, they can interfere with each other, leading to data inconsistencies.
-- To prevent this, databases use locking mechanisms to ensure that transactions are isolated from each other.

-- In most of the scenario, the default locking behaviour is sufficient.
-- But in some cases, we may need to explicitly lock the rows or tables to prevent other transactions from modifying them until the current transaction is complete.

/* 
! Common Concurrency Issues:
1. Lost Updates: Two transactions read the same data and then update it, leading to one transaction's changes being lost. Becasue the last one which is committed will be saved.
   - Example: Transaction A reads a row, modifies it, and commits. Transaction B reads the same row, modifies it, and commits. Transaction A's changes are lost.
   - Solution: Use transactions to ensure that the updates are atomic.
2. Dirty Reads: A transaction reads data that has been modified by another transaction but not yet committed, leading to inconsistent results.  
3. Non-Repeatable Reads: A transaction reads the same data twice and gets different results because another transaction modified it in between.
4. Phantom(Ghost) Reads: A transaction reads a set of rows that match a condition, but another transaction inserts or deletes rows that affect the result set before the first transaction is committed.
5. Deadlocks: Two or more transactions are waiting for each other to release locks, leading to a standstill.
   - Example: Transaction A locks row 1 and waits for row 2, while Transaction B locks row 2 and waits for row 1.
   - Solution: Use a timeout or deadlock detection mechanism to resolve deadlocks.
6. Lost Lock: A transaction acquires a lock on a resource, but another transaction releases it before the first transaction can use it.
   - Example: Transaction A locks row 1, but Transaction B releases the lock before Transaction A can use it.
   - Solution: Use a timeout or deadlock detection mechanism to resolve lost locks.

 */

 -- We can sovle the concurrency issues by using the following isolation levels:

 /* [Isolation Levels : Least to Most Strict]
    1. Read Uncommitted: Transactions can read data that has been modified but not yet committed by other transactions. This level allows dirty reads.
       - Example: Transaction A reads a row that Transaction B is currently modifying but hasn't committed yet.
       - Use Case: When performance is critical and data consistency is not a concern.
    2. Read Committed: Transactions can only read data that has been committed by other transactions. This level prevents dirty reads but allows non-repeatable reads and phantom reads.
       - Example: Transaction A reads a row that Transaction B has committed, but Transaction B can still modify the row after Transaction A reads it.
       - Use Case: When data consistency is important, but performance is also a concern.
    3. Repeatable Read: Transactions can read the same data multiple times and get the same results, even if other transactions modify it in between. This level prevents dirty reads and non-repeatable reads but allows phantom reads.
       - Example: Transaction A reads a row, and even if Transaction B modifies it, Transaction A will still see the original value.
       - Use Case: When data consistency is critical and performance is less of a concern.          
    4. Serializable: The strictest isolation level, where transactions are executed one after the other, as if they were serialized. This level prevents dirty reads, non-repeatable reads, and phantom reads but can lead to decreased performance due to increased locking.
       - Example: Transaction A and Transaction B cannot read or modify the same row at the same time.
       - Use Case: When data consistency is critical and performance is not a concern.
       !- Note: This level can lead to deadlocks and decreased performance due to increased locking.

  */


 SHOW VARIABLES LIKE 'transaction_isolation';
 SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- Only for current transaction
 SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- For current session all transaction will be in this isolation level.

 SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- For all session and transaction in the server.

 USE sql_store;
 SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
 START TRANSACTION;
 SELECT * FROM customers WHERE state = 'VA';
 COMMIT;




