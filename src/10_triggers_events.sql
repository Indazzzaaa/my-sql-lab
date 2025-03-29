-- [Trigger ]
-- A block of SQL code that automatically gets executed before or after an insert, update or delete statement.
-- Used to enforce data-consistency

DELIMITER $$
CREATE TRIGGER payments_after_insert /* table_after/before_insert/update/delete */
    /* ! In trigger we can modify any data except this trigger is for otherwise it will go in infinite loop */
    AFTER /* Or BEFORE */ INSERT /* UPDATE / DELETE */ ON payments
    FOR EACH ROW -- To fire on row change 
BEGIN
    UPDATE invoices
    SET payment_total = payment_total + /* OLD */ NEW.amount -- NEW will return the NEW row inserted, OLD will return the old data.
    WHERE invoice_id = NEW.invoice_id;
END $$

DELIMITER;

-- Test the above trigger
-- Expected : When we insert into the Payments table our Invoices table should update.
INSERT INTO payments
VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1)
 

 -- [Viewing the triggers]
 -- There is no way we can see the triggers in db directly, so use below commands.
 SHOW TRIGGERS


 -- [Dropping Triggers]
 DROP TRIGGER IF EXISTS payments_after_insert;


 -- [Using Triggers for Auditing]

 -- 1. Create the Table to store our audits
 USE sql_invoicing; 

CREATE TABLE payments_audit
(
	client_id 		INT 			NOT NULL, 
    date 			DATE 			NOT NULL,
    amount 			DECIMAL(9, 2) 	NOT NULL,
    action_type 	VARCHAR(50) 	NOT NULL,
    action_date 	DATETIME 		NOT NULL
)

-- 2. Modify our triggers 
DELIMITER $$
-- Trigger to fire when something inserted from payments table
CREATE TRIGGER payments_after_insert 
    AFTER  INSERT ON payments
    FOR EACH ROW 
BEGIN
    UPDATE invoices
    SET payment_total = payment_total + NEW.amount 
    WHERE invoice_id = NEW.invoice_id;

    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW() );
END $$

DELIMITER;

-- Trigger to fire when something deleted from payments table
CREATE TRIGGER payments_after_delete
    AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
    UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;

    INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW() );
END

DROP TRIGGER IF EXISTS payments_after_delete;

-- 3. Now Test the triggers
INSERT INTO payments
VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1);

DELETE FROM payments
WHERE payment_id = 10;


-- [Event]
-- A task ( or block of SQL code) that gets executed according to a schedule.
-- We can automate database from this.
SHOW VARIABLES LIKE 'event%'; -- To check all system variables, we have to turn on event scheduler.
-- SET GLOBAL event_schedular  = ON -- On it if it's OFF


-- Create Event
CREATE EVENT yearly_delete_stale_audit_rows /* freq_operation_whatOperation */
ON SCHEDULE
    -- AT '2026-01-01' -- at if we want to execute it once
    EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01' -- Starts and Ends are Optional
DO BEGIN
    DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END


-- [Viewing and Dropping Events]
SHOW EVENTS;
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;
-- WE have alter event which can help to modify event without deleting it.
-- alter event can also used for tmporarly enable or disable event.
