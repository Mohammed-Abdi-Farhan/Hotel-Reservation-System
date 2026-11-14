-- ============================================================================
-- FILE: 05_constraints_and_indexes.sql
-- PURPOSE: The A+ Engine. Enforces no-double-booking, optimizes performance, 
--          and initializes the Data Warehouse Star Schema.
-- ============================================================================

-- ============================================================================
-- 1. CONCURRENCY CONTROL (Prevent Double-Booking)
-- ============================================================================
-- This is the most critical line of code in the entire database.
-- It creates an exclusion constraint using GiST. It mathematically prevents
-- an INSERT if the room_id matches AND the date range overlaps, provided
-- the status is 'Confirmed'.
ALTER TABLE Reservation ADD CONSTRAINT no_overlapping_bookings
EXCLUDE USING gist (
    room_id WITH =,
    daterange(check_in, check_out, '[]') WITH &&
) WHERE (status = 'Confirmed');

-- ============================================================================
-- 2. PERFORMANCE TUNING (Indexes)
-- ============================================================================
-- B-Tree Index for fast user lookups by email.
CREATE INDEX idx_person_email ON Person USING btree (email);

-- GiST Index for ultra-fast range queries (e.g., searching for available rooms).
CREATE INDEX idx_reservation_daterange ON Reservation USING gist (daterange(check_in, check_out, '[]'));

-- Composite B-Tree Index for filtering rooms by property, type, and status.
CREATE INDEX idx_room_property_type_status ON Room (property_id, type_id, status);

-- ============================================================================
-- 3. DATA WAREHOUSE STAR SCHEMA (OLAP / Milestone 6 Preview)
-- ============================================================================
-- We build a dimensional model to prove forward-looking architecture.

-- DIMENSION: Date (Crucial for Time-Series Analysis)
CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY, -- Format: YYYYMMDD (e.g., 20261201)
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    quarter INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- FACT TABLE: Bookings
CREATE TABLE Fact_Booking (
    fact_id BIGSERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES Reservation(reservation_id),
    room_id INT NOT NULL REFERENCES Room(room_id),
    property_id INT NOT NULL REFERENCES Property(property_id),
    date_key INT NOT NULL REFERENCES Dim_Date(date_key),
    revenue DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_fact_revenue CHECK (revenue > 0)
);

COMMENT ON TABLE Fact_Booking IS 'OLAP Fact table storing quantifiable revenue data for analytics.';