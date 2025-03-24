-- Stored Procedure is database object that contains block of sql code.
/* 
Most of the database optimizes the stored procedures so there is additional benefit of doing it.

! Benefits
1. Store and organize SQL, in SQL instead of with application code.
2. Faster execution 
3. Data security : Can decide which user can call which procedure.

 */

 -- [Creating stored procedure]

--  DELIMITER $$ -- to tell mysql to use this delimeter for termination instead of ;
 CREATE PROCEDURE get_client()
 BEGIN
    SELECT * FROM clients; -- it's necessary to terminate the procedure with ;
END

-- DELIMITER ; -- Reset the delimiter

-- Calling the procedure
CALL get_client(); 
CALL get_payments();

-- [Dropping Stored Procedures]
DROP PROCEDURE IF EXISTS get_client; -- drop procedure if it exists


-- [Stored Procedures with Parameters]
 CREATE PROCEDURE get_client_by_state(state CHAR(2)) -- for multiple seprate using comma
 BEGIN
    SELECT * FROM clients c
    WHERE c.state = state;
END

CALL get_client_by_state('CA');


-- Parameter with default value
DROP PROCEDURE IF EXISTS get_client_by_state;
CREATE PROCEDURE get_client_by_state(state CHAR(2)) -- for multiple seprate using comma
 BEGIN
    IF state IS NULL THEN
        SET state = "CA";
    END IF;
    SELECT * FROM clients c
    WHERE c.state = state;
END

CALL get_client_by_state(NULL); -- We have to specify value even null for work as default

-- Let say if state is not set then return the all states 
DROP PROCEDURE IF EXISTS get_client_by_state;
CREATE PROCEDURE get_client_by_state(state CHAR(2)) -- for multiple seprate using comma
 BEGIN
    /* IF state IS NULL THEN
        SELECT * FROM clients;
    ELSE
        SELECT * FROM clients c
        WHERE c.state = state;
    END IF; */
    -- Shorter way
    SELECT * FROM clients c
    WHERE c.state = IFNULL(state, c.state);
END
CALL get_client_by_state(NULL); 


-- [Parameter validation]
-- Normally we do our parameter validation in application code
CREATE PROCEDURE make_payment(
    invoice_id INT,
    payment_amount DECIMAL(9, 2),
    payment_date  DATE
)
BEGIN
    IF payment_amount <= 0 THEN
        SIGNAL SQLSTATE '22003' -- way to raise except and number is predefined sql errors
            SET MESSAGE_TEXT = 'Invalid payment amount';

    END IF;

    UPDATE invoices i
    SET
        i.payment_total = payment_amount,
        i.payment_date = payment_date
    WHERE i.invoice_id = invoice_id;
END

-- Call with invalid payment amount and see the error
CALL make_payment(2, -100, '2019-01-01');


-- [Output Parameters]
DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;
CREATE PROCEDURE get_unpaid_invoices_for_client(
    cient_id INT, 
    OUT invoices_count INT, -- with out makes them output parameters
    OUT invoices_total DECIMAL(9, 2)
)
BEGIN
    SELECT count(*), SUM(invoice_total)
    INTO invoices_count, invoices_total -- above two values will be copied in these two
    FROM invoices i
    WHERE i.client_id = client_id
        AND payment_total = 0;

END

-- This is way to call it

-- user or session variables, because these variables will be there during the entire session of the user.
set @invoices_count = 0; -- way to create variables
set @invoices_total = 0;
call get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total; -- to read the data

-- Local variable : as soon as stored procedure finishes these variable freed up
CREATE PROCEDURE get_risk_factor()
BEGIN
    DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
    DECLARE invoices_count INT;

    SELECT count(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices;

    SET risk_factor = invoices_total/ invoices_count * 5;

    SELECT risk_factor;

END

CALL get_risk_factor()


-- [ Functions ]
-- How to create own functions.
-- Function can only return single value. And other things are similar to stored procedure.
-- 0 / null => null in sql

CREATE FUNCTION get_risk_factor_for_client(
    client_id INT
)
RETURNS INTEGER
-- DETERMINISTIC -- always return same output for same input
READS SQL DATA 
-- MODIFIES SQL DATA
BEGIN
    DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
    DECLARE invoices_count INT;

    SELECT count(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;

    SET risk_factor = invoices_total / invoices_count * 5;

    RETURN IFNULL(risk_factor, 0);
END

-- To execute the function
SELECT client_id,
        name,
        get_risk_factor_for_client(client_id) as risk_factor
FROM clients;



-- Conventions : Different way to name stored procedures and functions
-- procGetRiskFactor
-- getRiskFactor
-- get_risk_factor

-- Delimiter Conventions
-- DELIMITER //
-- DELIMITER $$







    
