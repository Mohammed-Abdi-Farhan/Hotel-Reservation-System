# 🏨 **HOTEL RESERVATION SYSTEM**
### Enterprise Database Architecture, Concurrency Control & OLAP Analytics

## 📌 Project Overview

This project is a production-grade, high-concurrency relational database management system designed for a multi-property hotel chain. It handles real-time room availability, booking transactions, and revenue analytics. The system is architected to prevent data anomalies and concurrency race conditions at the physical storage engine level, ensuring strict ACID compliance.

---

## 💼 Business Context

### 🎯 Problem Statement

Many hotel reservation systems still rely on application code to decide whether a room is free. The application reads availability, then writes the booking, and in the gap between those two steps another request can get in. When two agents or guests go for the last available room at the same moment, both checks pass and both bookings are saved. The result is a double-booking: a guest turned away at the front desk, compensation costs, and lasting damage to the hotel's reputation.

A second problem sits alongside this one. Management reports such as occupancy and revenue summaries are often run directly against the live booking tables. These long, heavy queries compete with customer transactions for resources and slow down the system guests are using to book.

### ✅ Expected Final Output

The project delivers an Enterprise Hotel Reservation System, built on PostgreSQL with a Python CLI, that:

1.  **Guarantees no double-booking.** Overlapping reservations for the same room are rejected by the database itself through an exclusion constraint and transactional row locking, so correctness holds even under simultaneous requests.
2.  **Handles concurrency cleanly.** When two users compete for the same room, one booking succeeds and the other receives a clear "room no longer available" response, with no corrupted or inconsistent data.
3.  **Keeps reporting off the booking path.** Occupancy and revenue reports run from indexed materialized views (or a separate reporting layer), so analytics no longer slow down live reservations.
4.  **Demonstrates the results.** Concurrent test sessions show the system blocking a double-booking, with the behaviour before and after the fix compared in the report.

---

## ❓ Key Technical Questions

1. How can we mathematically prevent double-booking at the database engine level?
2. How do we normalize the schema to BCNF to eliminate data redundancies?
3. How can we ensure atomicity (ACID compliance) during the booking and payment process?
4. How can we implement a Data Warehouse to run fast OLAP (analytical) queries without slowing down the live booking system?

---

## 📁 Data Sources & Tech Stack

| Source | Description |
| :--- | :--- |
| `PostgreSQL 14+` | Relational Database Engine (OLTP & OLAP) |
| `pgAdmin 4` | Database Administration & Query Tool |
| `Python 3` | Application Layer (`psycopg2`, `pytest`) |
| `draw.io` | EER Diagram Modeling |
| `FastAPI` | REST API Deployment Layer (Future) |

---

## 📊 System Implementation & EDA

Conducted using Python and SQL in the `app/` and `sql/` directories.

### 📈 System Visualizations

### 🎨 Entity-Relationship (EER) Diagram
*The schema utilizes disjoint specialization (`Person` -> `Guest`/`Staff`) and is normalized to BCNF. The diagram also highlights the GiST constraint.*



### 🧩 OLAP Revenue Analytics
*The Python CLI queries the Data Warehouse Star Schema to generate real-time revenue reports grouped by Property and Room Type.*



### 📅 Concurrency Control in Action
*The Python CLI catching the `ExclusionViolation` when a user attempts to double-book a room, proving the database protects itself.*



---

## 🔍 Key Insights & Engineering Decisions

### Insight 1: Concurrency Control (GiST Exclusion Constraint)
- **The Problem:** Initial application-level checks in Python failed under high concurrency (race conditions).
- **The Solution:** Implemented a PostgreSQL `EXCLUDE USING gist` constraint on `daterange` types. This mathematically prevents overlapping confirmed reservations at the engine level, making double-booking impossible.

### Insight 2: Atomic Transactions (Stored Procedures)
- Mid-transaction failures (e.g., room booked, but payment fails) were mitigated by encapsulating the booking logic in a PL/pgSQL Stored Procedure (`sp_make_reservation`). If one step fails, the entire transaction rolls back.

### Insight 3: OLTP/OLAP Separation (Data Warehousing)
- By implementing a Star Schema (`Fact_Booking`, `Dim_Date`) and loading it automatically via ETL inside the Stored Procedure, reporting queries no longer compete with live booking transactions.

---

## 🗺️ Milestone Roadmap (1–6)

To demonstrate mastery of advanced database concepts, the system evolves continuously across six distinct milestones:

- [x] **Milestone 1: Data Modeling & Relational Foundations**
  - EER Specialization and BCNF Normalization.
  - Implementation of the GiST `EXCLUDE` constraint to prevent double bookings.
- [x] **Milestone 2: Query Systems & Application Integration**
  - Python CLI with parameterized queries (SQLi prevention).
  - PL/pgSQL Stored Procedures, Triggers, and Views.
  - Automated Pytest suite verifying constraint enforcement.
- [ ] **Milestone 3: Conceptual Design & Schema Optimization**
  - Formal functional dependency analysis and decomposition proofs.
- [ ] **Milestone 4: Storage, Indexing & Query Optimization**
  - Query execution plan analysis (`EXPLAIN ANALYZE`).
  - Strategic B-Tree and GiST indexing for performance tuning.
- [ ] **Milestone 5: Transactions, Concurrency & System Reliability**
  - Simulating high-concurrency race conditions using Python threading.
  - Deadlock handling and recovery analysis.
- [ ] **Milestone 6: Distributed Systems & Data Warehousing**
  - Full ETL pipeline into a Star Schema.
  - Advanced OLAP analytics and CRISP-DM data mining integration.

---

## 📂 Project Structure
<pre>
Hotel-Reservation-System/
├── 📁 app/                          # Python Application Layer
│   ├── 📁 services/                 # Business logic & SQL queries (Service Layer)
│   ├── 📁 tests/                    # Automated Pytest suite
│   ├── 📄 app.py                    # CLI Interface
│   └── 📄 db_config.py              # Database connection configuration
├── 📁 docs/                         # Academic Reports & Diagrams
│   ├── 📁 milestone_1/              # EER Diagram & Justification
│   ├── 📁 milestone_2/              # M2 Report
│   ├── 📁 SRS/                      # Software Requirements Specification
│   └── 📁 crisp_dm/                 # CRISP-DM Methodology (M6)
├── 📁 sql/                          # Database Migration Scripts
│   ├── 📁 01_ddl/                   # Tables, constraints, extensions
│   ├── 📁 02_dml/                   # Seed data
│   └── 📁 03_procedures/            # Stored procedures, triggers, views
├── 📄 .gitignore                    # Excludes venv, pycache, etc.
├── 📄 requirements.txt              # Python dependencies
└── 📝 README.md                     # Project overview and documentation
</pre>

---

## 🛠️ Workflow & Responsibilities

| Stage | Responsibility |
| :--- | :--- |
| 🗄️ Database Architecture (DDL & BCNF) | Schema design, normalization, and constraint implementation |
| 🧠 Business Logic & Python CLI | Application layer, service separation, and user interface |
| 🧪 Automated Testing (Pytest) | Integration tests for concurrency and analytics |
| 📑 Documentation (SRS & PDFs) | Technical reports, diagrams, and milestone deliverables |

---

## ✅ GitHub Limitations & Exclusions

- `venv/` and `__pycache__/` are excluded via `.gitignore` to prevent bloating the repository.
- Database credentials in `db_config.py` are left blank for security. Users must input their local PostgreSQL password.

---

## 🧠 Tools Used

- **Database:** PostgreSQL 14+, pgAdmin 4
- **Backend:** Python 3, psycopg2
- **Testing:** Pytest
- **Modeling:** draw.io

---

## 📤 Deliverables

| Deliverable | Status |
| :--- | :--- |
| Enterprise EER Diagram | ✅ Complete |
| PostgreSQL DDL & DML Scripts | ✅ Complete |
| Python CLI Application | ✅ Complete |
| Automated Pytest Suite | ✅ Complete |
| Milestone 1 & 2 PDF Reports | ✅ Complete |