/* 
[Data Types Category]
1. String Types
2. Numeric Types
3. Data and Time
4. Blob Types
5. Spatial Types

 */

-- [String Types]
/* 
- CHAR(x): fixed-length
- VARCHAR(x): variable-length, max(65,535 english-characters ~64KB)
- MEDIUMTEXT: max(16MB)
- LONGTEXT: max(4GB)
- TINYTEXT: max(255 bytes)
- TEXT: max(64kb)

! All these types supports international characters. eg. Eglish lang uses 1 bytes, European & Middle-easter uses 2 bytes , and Asian uses 3 bytes.
! So if we use char(10) then mysql will reserve 30 bytes for the values in that column.

*/


-- [Integer Types]
/* 
TINYINT : 1b [-128, 127]
UNSIGNED TINYINT : [0,255]
SMALLINT: 2b [-32k, 32k]
MEDIUMINT: 3b [-8M, 8M]
INT: 4b [-2B, 2B]
BIGINT: 8b [-9z, 9z]

! If we try to store more then required type range then mysql will throw error.
? Integer types also supports zero fill. eg. We named colm int(4) and we stored 2 in that value, when we display mysql will display : 0002

 */

 -- [Floating Types]
 /* 
 - DECIMAL(p, s) => eg DECIMAL(9,2) : means total 9 digits and 2 after decimal. eg. 1234567.89
 - DEC
 - NUMERIC
 - FIXED

? For scientific calculation and less precision
 - FLOAT : 4b
 - DOUBLE: 8b
 
 
  */

-- [Boolean Types]
/* 
- BOOL
- BOOLEAN

! They are just tiny ints, they store True : 1, and False: 0

 */

 -- [ Enums and Set Types]
 /* 
 - ENUM('small', 'medium', 'large')
 - SET(...)
 ! Not recommended to use Enum/SET since it's costly to do modification.
 ? Better approach is use another table and put the values in there.

 
 
  */

-- [ Date and Time]
/* 
- DATE
- TIME
- DATETIME : 8b
- TIMESTAMP : 4b (up to 2038)
- YEAR

 */

-- [Blob Type : Used to store binary data ]
/* 
- TINYBLOB : 255b
- BLOB: 65KB
- MEDIUMBLOB: 16MB
- LONGBLOB: 4GB

! Generally speaking, keep your file data out of databases, it causes all sort of problems discuss below.
- Increased database size
- Slow backups
- Performance problems
- More code to read/write file logic in our code to and from databases.

 */

 -- [JSON Type : Lightweight format for storing and transferring data over the internet]
 /* 
 - See how to do CRUD operation on JSON.
  */
