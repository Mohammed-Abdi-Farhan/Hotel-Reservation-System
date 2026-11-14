# 🏨 Hotel Reservation System

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14%2B-blue?style=for-the-badge&logo=postgresql)
![Python](https://img.shields.io/badge/Python-3.9%2B-yellow?style=for-the-badge&logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-0.95%2B-009688?style=for-the-badge&logo=fastapi)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 📌 Project Overview
The **Hotel Reservation System** is a production-grade, high-concurrency database system designed for a multi-property, international hotel chain. 

Developed for **ICS 2404: Advanced Database Management Systems**, this project evolves through multiple milestones to demonstrate mastery of relational modeling, database internals, concurrency control, and OLAP data warehousing.

### 🛡️ Core Innovation: Mathematical Double-Booking Prevention
Unlike standard systems that rely on vulnerable application-level checks (which are susceptible to race conditions), this system pushes concurrency control down to the physical storage engine using **PostgreSQL GiST Exclusion Constraints**. This guarantees 100% ACID compliance and makes double-booking mathematically impossible.

---

## 🛠️ Technology Stack
*   **Database Engine:** PostgreSQL (v14+)
*   **CLI Application:** Python 3 (`psycopg2`)
*   **REST API Layer:** FastAPI & Uvicorn
*   **Data Analytics:** Jupyter Notebooks & Pandas
*   **Architecture:** OLTP (Transactions) + OLAP (Data Warehouse)

---

## ✨ Key Features (Milestones 1 & 2)

*   **Advanced EER Modeling:** Implements disjoint specialization (`Person` superclass branching to `Guest` and `Staff`) to prevent data anomalies and eliminate null values.
*   **Strict BCNF Normalization:** The relational schema is fully normalized to Boyce-Codd Normal Form. Dimensional tables like `RoomType` and `RatePlan` are extracted to eliminate transitive dependencies.
*   **Database-Level Concurrency Control:** Utilizes an `EXCLUDE USING gist` constraint to prevent overlapping reservation date ranges for the same room.
*   **Atomic Transactions (Stored Procedures):** The booking logic is encapsulated in a PL/pgSQL procedure (`sp_make_reservation`), ensuring that the reservation, payment, and data warehouse ETL process succeed or fail together.
*   **Automated Auditing (Triggers):** An audit trigger (`trg_reservation_audit`) automatically logs every `INSERT`, `UPDATE`, and `DELETE` on the reservations table, ensuring full data lineage.
*   **OLAP Data Warehouse:** Features a Star Schema (`Fact_Booking` and `Dim_Date`) that is automatically populated via ETL during the booking process, enabling real-time revenue analytics.

---

## 📂 Repository Structure
```text
Hotel-Reservation-System/
│
├── app/          # Python CLI Application
├── api/          # FastAPI REST Endpoints
├── docs/         # SRS, ER Diagrams, and Milestone Reports
├── sql/          # Sequential Database Scripts (DDL, DML, Procedures)
├── analytics/    # Jupyter Notebooks for CRISP-DM & OLAP
└── requirements.txt