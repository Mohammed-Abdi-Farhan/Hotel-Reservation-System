-- ============================================================================
-- FILE: 02_create_eer_tables.sql
-- PURPOSE: Creates the EER Specialization hierarchy (Person -> Guest/Staff).
--          Implements Base Entity and Subtype modeling.
-- ============================================================================

-- 1. CLEAN SLATE (Drop everything to ensure idempotency)
DROP TABLE IF EXISTS Fact_Booking CASCADE;
DROP TABLE IF EXISTS Reservation_Audit CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Room CASCADE;
DROP TABLE IF EXISTS RoomType CASCADE;
DROP TABLE IF EXISTS RatePlan CASCADE;
DROP TABLE IF EXISTS Facility CASCADE;
DROP TABLE IF EXISTS Property CASCADE;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Guest CASCADE;
DROP TABLE IF EXISTS Person CASCADE;

-- 2. SUPERCLASS: PERSON
-- Note: Serves as the single source of truth for human identities to prevent
-- duplicate emails between staff and guests.
CREATE TABLE Person (
    person_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

COMMENT ON TABLE Person IS 'Superclass table containing base identity data for all humans.';
COMMENT ON COLUMN Person.email IS 'Enforced with a Regular Expression Check constraint to ensure data quality.';

-- 3. SUBCLASS: GUEST (Inherits from Person)
CREATE TABLE Guest (
    person_id INT PRIMARY KEY REFERENCES Person(person_id) ON DELETE CASCADE,
    loyalty_points INT DEFAULT 0,
    vip_status VARCHAR(20) DEFAULT 'Standard',
    CONSTRAINT chk_loyalty_points CHECK (loyalty_points >= 0),
    CONSTRAINT chk_vip_status CHECK (vip_status IN ('Standard', 'Silver', 'Gold', 'Platinum', 'Diamond'))
);

COMMENT ON TABLE Guest IS 'Subclass representing hotel patrons.';

-- 4. SUBCLASS: STAFF (Inherits from Person)
CREATE TABLE Staff (
    person_id INT PRIMARY KEY REFERENCES Person(person_id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,
    property_id INT, -- FK added later after Property table is created
    hire_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT chk_role CHECK (role IN ('General Manager', 'Front Desk', 'Housekeeping', 'Chef', 'Security'))
);

COMMENT ON TABLE Staff IS 'Subclass representing hotel employees.';