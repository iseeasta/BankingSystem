# BankingSystem.md

> *( this is explanation of what i did and how it works — whole project )*

---

# SCHEMA

--> { First thing before any table — we create a Schema }

```sql
CREATE SCHEMA IF NOT EXISTS "CreateSchema";
```

A Schema is just a namespace — a folder inside the database.

Without it, all tables would sit directly under public schema.

(IF NOT EXISTS) means if schema already there, skip quietly, no error.

All our tables will be accessed as ("CreateSchema".table_name).

This keeps banking tables organized and separate from anything else.

---

# TableCreation.pgsql

--> { This, creates all 6 tables with their columns and constraints }

--> { bank_records is the parent — all other tables depend on it }

--> { Run this first before any data insertion }

```sql
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
```

This is the parent table — every other table connects to this one.

(Sr_no SERIAL) auto-increments — DB assigns the number automatically.

(UNIQUE(Sr_no)) means no two rows can have same Sr_no.

(Acc_no VARCHAR(12) PRIMARY KEY) is the main identifier for each account.

(DATE NOT NULL) means Acc_created must always be filled.

(DEFAULT 'Savings') means if Acc_type not given, it becomes Savings automatically.

(DEFAULT 'Main Branch(New Delhi)') same — branch auto-fills if not provided.

```sql
CREATE TABLE "CreateSchema".cards
(
    ...
    UNIQUE (Credit_cardNo, Debit_cardNo),
    Acc_no VARCHAR(12),
    FOREIGN KEY (Acc_no) REFERENCES "CreateSchema".bank_records(Acc_no)
);
```

(UNIQUE on two columns together) means the COMBINATION must be unique.

Two rows cant have same Credit_cardNo AND same Debit_cardNo at the same time.

Each alone can repeat, but both together cannot.

(FOREIGN KEY) is the link between cards and bank_records.

(Acc_no) in cards must exist in bank_records.Acc_no first.

You cannot insert a card for an account that doesnt exist.

This is called referential integrity.

```sql
CREATE TABLE "CreateSchema".customer ( ... same FK pattern ... );
CREATE TABLE "CreateSchema".adhaar_card ( ... same FK pattern ... );
CREATE TABLE "CreateSchema".pan_card ( ... same FK pattern ... );
CREATE TABLE "CreateSchema".transcation ( ... same FK pattern ... );
```

All 4 remaining tables follow the same pattern.

All link back to bank_records via Acc_no Foreign Key.

(adhaar_card) has Adhaar_card as PRIMARY KEY — no two same Aadhaar numbers.

(pan_card) has Pan_card as PRIMARY KEY — no two same PAN numbers.

(transcation) has no PK — multiple transactions allowed per account.

---

# DataInsertion/

--> { These files insert 100 rows into each table — 600 total entries }

--> { All 6 files must be run AFTER TableCreation }

--> { BankRecords.sql must run FIRST — others depend on its Acc_no values }

```sql
INSERT INTO "CreateSchema".bank_records (Acc_no, Acc_holder, ...)
VALUES ('QCEP6AUJS2N8', 'Mr.PLRAWD', ...);
```

Each INSERT adds one row.

100 rows inserted in a single INSERT statement using multiple VALUES.

Acc_no values are random 12-char strings — unique for each account.

Order matters — if you run Cards.sql before BankRecords.sql,

Foreign Key will throw error because the Acc_no doesnt exist yet.

Always bank_records first, then the rest.

---

# SimpleQueries/Aggregators.sql

--> { These are functions that calculate something across multiple rows }

--> { They collapse many rows into one result }

```sql
SELECT SUM(Amount_deposited) AS total_deposited
FROM "CreateSchema".transcation;
```

(SUM) adds up all values in Amount_deposited column.

(AS total_deposited) just renames the output column to something readable.

Without AS it would show as just "sum" in result.

```sql
SELECT AVG(Acc_balance)
FROM "CreateSchema".bank_records;
```

(AVG) calculates average of all Acc_balance values.

Divide total sum by count — same math, SQL does it for you.

```sql
SELECT COUNT(Acc_no)
FROM "CreateSchema".bank_records;
```

(COUNT) counts how many rows have a value in Acc_no.

Basically tells you total number of accounts.

---

# SimpleQueries/Clauses.sql

--> { Clauses are the modifiers — they narrow down or shape what SELECT returns }

```sql
WHERE Acc_balance >= 25000;
```

(WHERE) filters rows — only rows that match the condition come through.

Everything else is ignored.

```sql
SELECT DISTINCT Acc_branch
FROM "CreateSchema".bank_records;
```

(DISTINCT) removes duplicates from result.

100 accounts but maybe only 5 unique branches — DISTINCT shows just those 5.

```sql
SELECT * FROM "CreateSchema".bank_records
LIMIT 10;
```

(LIMIT) caps the output — show only first 10 rows.

Useful when table has thousands of rows and you just want a quick look.

---

# SimpleQueries/GroupByAndStringFunction.sql

```sql
SELECT CONCAT(Acc_type, Acc_balance)
FROM "CreateSchema".bank_records;
```

(CONCAT) joins two column values into one string.

Like 'Savings' + '600000' becomes 'Savings600000'.

```sql
SELECT CONCAT_WS(' -> ', Acc_type, Acc_balance)
FROM "CreateSchema".bank_records;
```

(CONCAT_WS) same as CONCAT but adds a separator between values.

Result becomes 'Savings -> 600000'. cleaner.

---

# SimpleQueries/SwitcgCase.sql

--> { CASE is SQL version of switch-case or if-else — applied per row }

```sql
SELECT Acc_holder, Acc_balance,
CASE
    WHEN Acc_balance > 100000 THEN 'HIGH'
    ELSE 'LOW'
END AS label
FROM "CreateSchema".bank_records;
```

For every row, CASE checks the condition.

If Acc_balance > 100000 — it writes 'HIGH' in label column.

Otherwise — it writes 'LOW'.

(END AS label) closes the CASE and names the new output column.

No actual column called label exists in the table.

It gets created on the fly just for that query output.

---

# SimpleQueries/AlteringAndConstains.sql

--> { ALTER TABLE changes the structure of an existing table — not the data }

```sql
ALTER TABLE "CreateSchema".bank_records
ADD COLUMN category VARCHAR(18);
```

(ADD COLUMN) creates a new column in an already existing table.

All existing rows get NULL in that column by default.

```sql
ALTER TABLE "CreateSchema".bank_records
DROP COLUMN categories;
```

(DROP COLUMN) permanently removes the column and all its data.

Cannot undo this. gone.
