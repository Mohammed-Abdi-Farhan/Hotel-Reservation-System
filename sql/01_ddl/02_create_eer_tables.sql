-- Creates the EER Specialization hierarchy (Person -> Guest/Staff).
--          Implements Base Entity and Subtype modeling.

-- Reset tables (drop in reverse order to avoid FK conflicts)
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

-- Person superclass: stores shared identity data for all users
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

-- Guest subclass
CREATE TABLE Guest (
    person_id INT PRIMARY KEY REFERENCES Person(person_id) ON DELETE CASCADE,
    loyalty_points INT DEFAULT 0,
    vip_status VARCHAR(20) DEFAULT 'Standard',
    CONSTRAINT chk_loyalty_points CHECK (loyalty_points >= 0),
    CONSTRAINT chk_vip_status CHECK (vip_status IN ('Standard', 'Silver', 'Gold', 'Platinum', 'Diamond'))
);

-- Staff subclass
CREATE TABLE Staff (
    person_id INT PRIMARY KEY REFERENCES Person(person_id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,
    property_id INT, -- FK constraint added in 03_create_property_tables.sql
    hire_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT chk_role CHECK (role IN ('General Manager', 'Front Desk', 'Housekeeping', 'Chef', 'Security'))
);