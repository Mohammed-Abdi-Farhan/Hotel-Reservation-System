# CRISP-DM Phase 2: Data Understanding

## 1. Data Sources
The system utilizes a dual-database architecture:
*   **OLTP (Online Transaction Processing):** Tables like `Reservation`, `Payment`, and `Room` capture live, high-velocity transactional data.
*   **OLAP (Online Analytical Processing):** A Star Schema consisting of `Fact_Booking` and `Dim_Date` designed specifically for historical analysis.

## 2. Data Dictionary (Core Analytical Tables)
*   `Fact_Booking`: Contains `fact_id`, `reservation_id`, `room_id`, `property_id`, `date_key`, and `revenue` (DECIMAL). This is the quantitative core of the warehouse.
*   `Dim_Date`: Contains `date_key`, `full_date`, `year`, `month`, `day`, `quarter`, and `is_weekend` (BOOLEAN). This allows for time-series and seasonality analysis.

## 3. Data Quality
The data is highly structured and governed by strict `CHECK` constraints and Foreign Keys in PostgreSQL. However, missing values exist in the `Payment` table for cancelled or no-show reservations, which must be handled during data preparation.