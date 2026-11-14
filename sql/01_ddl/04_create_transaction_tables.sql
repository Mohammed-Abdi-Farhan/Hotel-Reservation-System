-- ============================================================================
-- FILE: 04_create_transaction_tables.sql
-- PURPOSE: The OLTP Core. Handles Reservations, Payments, and Auditing.
-- ============================================================================

-- 1. RESERVATION
CREATE TABLE Reservation (
    reservation_id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL REFERENCES Guest(person_id) ON DELETE RESTRICT,
    room_id INT NOT NULL REFERENCES Room(room_id) ON DELETE RESTRICT,
    rate_plan_id INT REFERENCES RatePlan(rate_plan_id) ON DELETE SET NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed',
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_res_dates CHECK (check_out > check_in),
    CONSTRAINT chk_res_status CHECK (status IN ('Confirmed', 'Cancelled', 'Completed', 'No-Show')),
    CONSTRAINT chk_total_amount CHECK (total_amount >= 0)
);

COMMENT ON TABLE Reservation IS 'Core transactional table bridging Guests, Rooms, and Rate Plans.';

-- 2. PAYMENT (Financial Ledger)
CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES Reservation(reservation_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Completed',
    transaction_reference UUID DEFAULT uuid_generate_v4(), -- A+ Feature: Unique transaction ID
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Cash', 'Bank Transfer', 'Loyalty Points')),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Pending', 'Completed', 'Refunded', 'Failed'))
);

COMMENT ON TABLE Payment IS 'Financial ledger with unique UUID transaction references.';

-- 3. AUDIT LOG (For Triggers)
CREATE TABLE Reservation_Audit (
    audit_id SERIAL PRIMARY KEY,
    reservation_id INT,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100) DEFAULT CURRENT_USER,
    action_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_action_type CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE'))
);

COMMENT ON TABLE Reservation_Audit IS 'Automated lineage tracking table for all Reservation mutations.';