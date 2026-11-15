# CRISP-DM Phase 3: Data Preparation

## 1. ETL (Extract, Transform, Load) Pipeline
Data is not manually inserted into the Data Warehouse. Instead, an automated ETL process is triggered inside the `sp_make_reservation` Stored Procedure. When a booking is confirmed, the transaction automatically extracts the relevant IDs, transforms the check-in date into a `date_key`, and loads it into `Fact_Booking`.

## 2. Data Cleaning (Python/Pandas)
In the Exploratory Data Analysis phase (Jupyter Notebook), the following cleaning steps are applied:
*   **Handling Missing Values:** Null `amount` values from cancelled reservations are imputed with `0.00` to ensure revenue aggregations do not break.
*   **Data Type Conversion:** String dates (`YYYY-MM-DD`) are converted to `datetime` objects to allow mathematical operations.
*   **Feature Engineering:** A new feature `Length_of_Stay` is calculated by subtracting `check_in` from `check_out`. Month names are extracted from dates to analyze seasonality.