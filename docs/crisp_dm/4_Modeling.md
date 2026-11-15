# CRISP-DM Phase 4: Modeling

## 1. Data Modeling (Star Schema)
For analytical modeling, we utilized a Dimensional Star Schema. This decouples reporting from the normalized OLTP database, ensuring fast query execution. 
*   **Fact Table:** `Fact_Booking` stores quantitative revenue data.
*   **Dimension Table:** `Dim_Date` provides the context for time-series analysis.

## 2. Analytical Queries
The model is queried using SQL aggregations (SUM, COUNT, GROUP BY) via a Python CLI. Examples include:
*   Total Revenue by Property (`Fact_Booking` JOIN `Property`).
*   Revenue Distribution by Room Type (`Fact_Booking` JOIN `Room` JOIN `RoomType`).
*   Seasonal Revenue Trends (`Fact_Booking` JOIN `Dim_Date`).