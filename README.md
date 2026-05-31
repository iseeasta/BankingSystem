# Banking System — PostgreSQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![PLpgSQL](https://img.shields.io/badge/PLpgSQL-100%25-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

A relational banking database built in PostgreSQL from scratch. Covers full schema design, table creation with constraints and foreign keys, 600+ records of sample data, and a variety of SQL queries including aggregations, clauses, CASE statements, string functions, and CRUD operations.

---

## What It Covers

- Designed a normalized relational schema with 6 linked tables
- Implemented Primary Keys, Foreign Keys, UNIQUE constraints, and CHECK constraints
- Inserted 100 records per table — 600+ total entries
- Wrote queries covering aggregations, clauses, GROUP BY, string functions, CASE/SWITCH, and CRUD
- Practiced ALTER TABLE operations — add, rename, change type, drop columns

---

## Project Structure

```
BankingSystem/
├── Template.pgsql
├── .gitignore
└── PostgresProject/
    ├── TableCreation.pgsql               → Creates all 6 tables with constraints
    ├── SampleData.pgsql                  → Single sample entry for each table
    ├── SelectTable.pgsql                 → SELECT queries to view tables
    ├── DropingTable.pgsql                → DROP statements to reset schema
    │
    ├── DataInsertion/
    │   ├── BankRecords.sql               → 100 bank account entries
    │   ├── Cards.sql                     → 100 credit/debit card entries
    │   ├── Customer.sql                  → 100 customer entries
    │   ├── AdhaarCard.sql                → 100 Aadhaar card entries
    │   ├── PanCard.sql                   → 100 PAN card entries
    │   └── Transcation.sql               → 100 transaction entries
    │
    └── SimpleQueries/
        ├── Aggregators.sql               → SUM, AVG, COUNT, MAX, MIN, BETWEEN, IN
        ├── Clauses.sql                   → WHERE, DISTINCT, LIMIT, LIKE, ORDER BY
        ├── GroupByAndStringFunction.sql  → GROUP BY, CONCAT, SUBSTR, UPPER, TRIM etc.
        ├── SwitcgCase.sql                → CASE WHEN THEN ELSE END
        ├── AlteringAndConstains.sql      → ALTER TABLE, ADD/DROP COLUMN, CHECK constraints
        │
        ├── CRUDOperations/
        │   └── UpdatingAndDeleting.sql   → UPDATE and DELETE queries
        │
        └── RelationshipAndForeignKey/
            ├── CreatingTableForBetterRelations.sql  → Improved relational table design
            └── StartingExplainationNow.md           → Notes on relationships and FK logic
```

---

## Database Schema

All tables live under the `"CreateSchema"` schema in PostgreSQL.

### Tables and Relationships

```
bank_records (Parent Table)
│
├── cards          → FK: Acc_no → bank_records.Acc_no
├── customer       → FK: Acc_no → bank_records.Acc_no
├── adhaar_card    → FK: Acc_no → bank_records.Acc_no
├── pan_card       → FK: Acc_no → bank_records.Acc_no
└── transcation    → FK: Acc_no → bank_records.Acc_no
```

---

### Table: bank_records

| Column | Type | Constraint |
|---|---|---|
| Sr_no | SERIAL | NOT NULL, UNIQUE |
| Acc_no | VARCHAR(12) | PRIMARY KEY |
| Acc_holder | VARCHAR(20) | — |
| Acc_created | DATE | NOT NULL |
| Acc_type | VARCHAR(15) | DEFAULT 'Savings' |
| Acc_balance | NUMERIC(20) | — |
| Acc_branch | VARCHAR(25) | DEFAULT 'Main Branch(New Delhi)' |

---

### Table: cards

| Column | Type | Constraint |
|---|---|---|
| Credit_cardNo | VARCHAR(19) | NOT NULL |
| Credit_score | DECIMAL(4,2) | — |
| Debit_card | VARCHAR(3) | DEFAULT 'No' |
| Debit_cardNo | VARCHAR(19) | DEFAULT '-' |
| Acc_no | VARCHAR(12) | FK → bank_records |

---

### Table: customer

| Column | Type | Constraint |
|---|---|---|
| Fathers_name | VARCHAR(24) | — |
| Mothers_name | VARCHAR(24) | — |
| Phone_no | NUMERIC(12) | UNIQUE |
| Email_id | VARCHAR(25) | UNIQUE |
| Address | VARCHAR(30) | — |
| Acc_no | VARCHAR(12) | FK → bank_records |

---

### Table: adhaar_card

| Column | Type | Constraint |
|---|---|---|
| Acc_no | VARCHAR(12) | FK → bank_records |
| Adhaar_card | VARCHAR(14) | PRIMARY KEY |

---

### Table: pan_card

| Column | Type | Constraint |
|---|---|---|
| Acc_no | VARCHAR(12) | FK → bank_records |
| Pan_card | VARCHAR(14) | PRIMARY KEY |

---

### Table: transcation

| Column | Type | Constraint |
|---|---|---|
| Acc_no | VARCHAR(12) | FK → bank_records |
| Amount_deposited | NUMERIC(15) | — |
| Amount_withdrawed | NUMERIC(10) | — |

---

## SQL Concepts Covered

| Category | What Was Done |
|---|---|
| **Aggregations** | SUM, AVG, COUNT, MAX, MIN, BETWEEN, IN, OR |
| **Clauses** | WHERE, DISTINCT, LIMIT, LIKE, ORDER BY |
| **GROUP BY** | Group by column, find totals per group |
| **String Functions** | CONCAT, CONCAT_WS, SUBSTR, LEFT, RIGHT, LENGTH, UPPER, LOWER, TRIM, POSITION, REVERSE, REPLACE |
| **CASE / SWITCH** | Conditional labels on query output |
| **ALTER TABLE** | ADD COLUMN, RENAME COLUMN, ALTER COLUMN TYPE, DROP COLUMN |
| **Constraints** | CHECK, NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY |
| **CRUD** | INSERT, SELECT, UPDATE, DELETE |

---

## Setup & Run

**1. Open PostgreSQL**
```bash
sudo -u postgres psql
```

**2. Create Schema**
```sql
CREATE SCHEMA IF NOT EXISTS "CreateSchema";
```

**3. Run Table Creation**
```sql
\i PostgresProject/TableCreation.pgsql
```

**4. Insert Data**
```sql
\i PostgresProject/DataInsertion/BankRecords.sql
\i PostgresProject/DataInsertion/Cards.sql
\i PostgresProject/DataInsertion/Customer.sql
\i PostgresProject/DataInsertion/AdhaarCard.sql
\i PostgresProject/DataInsertion/PanCard.sql
\i PostgresProject/DataInsertion/Transcation.sql
```

**5. Verify**
```sql
SELECT COUNT(*) FROM "CreateSchema".bank_records;
SELECT COUNT(*) FROM "CreateSchema".cards;
SELECT COUNT(*) FROM "CreateSchema".transcation;
```

---

## Data Summary

| Table | Records |
|---|---|
| bank_records | 100 |
| cards | 100 |
| customer | 100 |
| adhaar_card | 100 |
| pan_card | 100 |
| transcation | 100 |
| **Total** | **600** |

---

## Author

![GitHub](https://img.shields.io/badge/GitHub-iseeasta-181717?style=for-the-badge&logo=github&logoColor=white)
![LinkedIn](https://img.shields.io/badge/LinkedIn-iseeasta-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)
![Gmail](https://img.shields.io/badge/Gmail-iseeasta@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)
