
-- Creating database
CREATE DATABASE IF NOT EXISTS sql_store2;

-- Dropping database (Deletes everything from database)
DROP DATABASE IF EXISTS sql_store2;

-- Create Table in database
USE sql_store2;
CREATE TABLE IF NOT EXISTS customers
(
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    email VARCHAR(255) NOT NULL UNIQUE
)


-- Add new Column to table
ALTER TABLE customers
    ADD last_name VARCHAR(50) NOT NULL AFTER first_name,
    MODIFY COLUMN first_name VARCHAR(55) DEFAULT '',
    DROP points
    ;

-- Creating Relationships
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    -- Naming : fk_currentTable_parentTable
    FOREIGN KEY fk_orders_customers (customer_id)
        REFERENCES customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

-- To know character set
SHOW CHARSET;  -- We can change the colation based on the type of language we want to support(eg. Chinese only, latin only, Asian, Europian etc.)

-- Storage engines
SHOW ENGINES; -- THe default one is InnoDB
ALTER TABLE customers
ENGINE = InnoDB -- to change the storage engine for table.(It's expensive since changing storage engine MySQL has to rebuild the entire table.)