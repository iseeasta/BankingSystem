-- =============================================
-- BANKING SYSTEM — SIMPLE TEMPLATE
-- =============================================
-- Run this top to bottom in order
-- Everything is under "CreateSchema" schema


-- =============================================
-- STEP 1 — Create Schema
-- =============================================
CREATE SCHEMA IF NOT EXISTS "CreateSchema";


-- =============================================
-- STEP 2 — Create Tables
-- =============================================

-- Parent table — create this first
CREATE TABLE "CreateSchema".bank_records
(
    Sr_no       SERIAL NOT NULL,
    UNIQUE(Sr_no),
    Acc_no      VARCHAR(12) PRIMARY KEY,
    Acc_holder  VARCHAR(20),
    Acc_created DATE NOT NULL,
    Acc_type    VARCHAR(15) NOT NULL DEFAULT 'Savings',
    Acc_balance NUMERIC(20),
    Acc_branch  VARCHAR(25) NOT NULL DEFAULT 'Main Branch(New Delhi)'
);

-- Cards table — linked to bank_records
CREATE TABLE "CreateSchema".cards
(
    Credit_cardNo VARCHAR(19) NOT NULL,
    Credit_score  DECIMAL(4,2),
    Debit_card    VARCHAR(3)  NOT NULL DEFAULT 'No',
    Debit_cardNo  VARCHAR(19) NOT NULL DEFAULT '-',
    UNIQUE (Credit_cardNo, Debit_cardNo),
    Acc_no        VARCHAR(12),
    FOREIGN KEY (Acc_no) REFERENCES "CreateSchema".bank_records(Acc_no)
);

-- Customer table — linked to bank_records
CREATE TABLE "CreateSchema".customer
(
    Fathers_name VARCHAR(24),
    Mothers_name VARCHAR(24),
    Phone_no     NUMERIC(12),
    Email_id     VARCHAR(25),
    UNIQUE (Phone_no, Email_id),
    Address      VARCHAR(30),
    Acc_no       VARCHAR(12),
    FOREIGN KEY (Acc_no) REFERENCES "CreateSchema".bank_records(Acc_no)
);

-- Aadhaar card table — linked to bank_records
CREATE TABLE "CreateSchema".adhaar_card
(
    Acc_no      VARCHAR(12),
    Adhaar_card VARCHAR(14) PRIMARY KEY,
    FOREIGN KEY (Acc_no) REFERENCES "CreateSchema".bank_records(Acc_no)
);

-- PAN card table — linked to bank_records
CREATE TABLE "CreateSchema".pan_card
(
    Acc_no   VARCHAR(12),
    Pan_card VARCHAR(14) PRIMARY KEY,
    FOREIGN KEY (Acc_no) REFERENCES "CreateSchema".bank_records(Acc_no)
);

-- Transaction table — linked to bank_records
CREATE TABLE "CreateSchema".transcation
(
    Acc_no            VARCHAR(12),
    FOREIGN KEY (Acc_no) REFERENCES "CreateSchema".bank_records(Acc_no),
    Amount_deposited  NUMERIC(15),
    Amount_withdrawed NUMERIC(10)
);


-- =============================================
-- STEP 3 — Insert Sample Data (1 entry each)
-- =============================================

INSERT INTO "CreateSchema".bank_records (Acc_no, Acc_holder, Acc_created, Acc_balance)
VALUES ('002AER232222', 'Mr.Shubas', '2005-12-13', '600000');

INSERT INTO "CreateSchema".cards (Credit_cardNo, Credit_score, Debit_card, Debit_cardNo, Acc_no)
VALUES ('0010-3122-4353-1323', '89.99', 'No', '-', '002AER232222');

INSERT INTO "CreateSchema".customer (Fathers_name, Mothers_name, Phone_no, Email_id, Address, Acc_no)
VALUES ('Mr.Aditya', 'Mrs.Suhri', '9297222154', 'qwert23@gmail.com', 'Lucknow, India', '002AER232222');

INSERT INTO "CreateSchema".adhaar_card (Acc_no, Adhaar_card)
VALUES ('002AER232222', '1234-5678-9012');

INSERT INTO "CreateSchema".pan_card (Acc_no, Pan_card)
VALUES ('002AER232222', 'ABCDE1234F');

INSERT INTO "CreateSchema".transcation (Acc_no, Amount_deposited, Amount_withdrawed)
VALUES ('002AER232222', '2025000', '44302');


-- =============================================
-- STEP 4 — View All Tables
-- =============================================

SELECT * FROM "CreateSchema".bank_records;
SELECT * FROM "CreateSchema".cards;
SELECT * FROM "CreateSchema".customer;
SELECT * FROM "CreateSchema".adhaar_card;
SELECT * FROM "CreateSchema".pan_card;
SELECT * FROM "CreateSchema".transcation;


-- =============================================
-- STEP 5 — Aggregations
-- =============================================

-- Total deposited amount
SELECT SUM(Amount_deposited) AS total_deposited FROM "CreateSchema".transcation;

-- Average balance across all accounts
SELECT AVG(Acc_balance) AS avg_balance FROM "CreateSchema".bank_records;

-- Count total accounts
SELECT COUNT(Acc_no) AS total_accounts FROM "CreateSchema".bank_records;

-- Accounts with balance between 50000 and 100000
SELECT * FROM "CreateSchema".bank_records
WHERE Acc_balance BETWEEN 50000 AND 100000;

-- Accounts in specific branches
SELECT * FROM "CreateSchema".bank_records
WHERE Acc_branch IN ('Mumbai Branch', 'Bangalore Branch');

-- Highest and lowest balance
SELECT MAX(Acc_balance) FROM "CreateSchema".bank_records;
SELECT MIN(Acc_balance) FROM "CreateSchema".bank_records;


-- =============================================
-- STEP 6 — Clauses
-- =============================================

-- WHERE — accounts with balance above 25000
SELECT Acc_holder, Acc_balance FROM "CreateSchema".bank_records
WHERE Acc_balance >= 25000;

-- DISTINCT — unique branches
SELECT DISTINCT Acc_branch FROM "CreateSchema".bank_records;

-- LIMIT — first 10 entries only
SELECT * FROM "CreateSchema".bank_records LIMIT 10;

-- LIKE — accounts with type starting with 'Sal'
SELECT Acc_type FROM "CreateSchema".bank_records
WHERE Acc_type LIKE 'Sal%';

-- ORDER BY — sorted by Sr_no
SELECT * FROM "CreateSchema".bank_records ORDER BY Sr_no;


-- =============================================
-- STEP 7 — GROUP BY and String Functions
-- =============================================

-- GROUP BY balance
SELECT Acc_balance FROM "CreateSchema".bank_records GROUP BY Acc_balance;

-- String functions
SELECT CONCAT(Acc_type, Acc_balance) FROM "CreateSchema".bank_records;
SELECT UPPER(Acc_holder)             FROM "CreateSchema".bank_records;
SELECT LOWER(Acc_holder)             FROM "CreateSchema".bank_records;
SELECT LENGTH(Acc_holder)            FROM "CreateSchema".bank_records;
SELECT LEFT(Acc_holder, 5)           FROM "CreateSchema".bank_records;
SELECT TRIM(Acc_branch)              FROM "CreateSchema".bank_records;
SELECT REVERSE(Acc_holder)           FROM "CreateSchema".bank_records;


-- =============================================
-- STEP 8 — CASE Statement
-- =============================================

-- Label accounts as HIGH or LOW balance
SELECT Acc_holder, Acc_balance,
CASE
    WHEN Acc_balance > 100000 THEN 'HIGH'
    ELSE 'LOW'
END AS label
FROM "CreateSchema".bank_records;

-- Label transactions as Wasting or Not_Wasting
SELECT Acc_no, Amount_deposited, Amount_withdrawed,
CASE
    WHEN Amount_deposited > 10000 AND Amount_withdrawed < 20000 THEN 'Wasting'
    ELSE 'Not_Wasting'
END AS quality
FROM "CreateSchema".transcation;


-- =============================================
-- STEP 9 — ALTER TABLE and Constraints
-- =============================================

-- Add a new column
ALTER TABLE "CreateSchema".bank_records
ADD COLUMN category VARCHAR(18);

-- Rename the column
ALTER TABLE "CreateSchema".bank_records
RENAME COLUMN category TO categories;

-- Drop the column
ALTER TABLE "CreateSchema".bank_records
DROP COLUMN categories;

-- Add a CHECK constraint
ALTER TABLE "CreateSchema".bank_records
ADD CONSTRAINT acc_holder_check CHECK (Acc_holder IS NOT NULL);

-- Drop the constraint
ALTER TABLE "CreateSchema".bank_records
DROP CONSTRAINT acc_holder_check;


-- =============================================
-- STEP 10 — CRUD Operations
-- =============================================

-- UPDATE balance
UPDATE "CreateSchema".bank_records
SET Acc_balance = 750000
WHERE Acc_no = '002AER232222';

-- DELETE a specific transaction
DELETE FROM "CreateSchema".transcation
WHERE Acc_no = '002AER232222';


-- =============================================
-- RESET — Drop all tables (run in this order)
-- =============================================

DROP TABLE "CreateSchema".cards;
DROP TABLE "CreateSchema".customer;
DROP TABLE "CreateSchema".adhaar_card;
DROP TABLE "CreateSchema".pan_card;
DROP TABLE "CreateSchema".transcation;
DROP TABLE "CreateSchema".bank_records;
