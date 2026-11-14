-- ============================================================================
-- FILE: 03_create_property_tables.sql
-- PURPOSE: Multi-Property architecture, Facilities, Room Types, and Rates.
--          Designed for a scalable hotel chain (e.g., Marriott, Hilton).
-- ============================================================================

-- 1. PROPERTY (Physical Hotel Branch)
CREATE TABLE Property (
    property_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    star_rating INT NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    CONSTRAINT chk_star_rating CHECK (star_rating BETWEEN 1 AND 5)
);

COMMENT ON TABLE Property IS 'Master table for multi-property hotel locations.';

-- Update Staff with the Property FK now that the table exists
ALTER TABLE Staff ADD CONSTRAINT fk_staff_property 
FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE SET NULL;

-- 2. FACILITY (Amenities at specific properties)
CREATE TABLE Facility (
    facility_id SERIAL PRIMARY KEY,
    property_id INT NOT NULL REFERENCES Property(property_id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    is_complimentary BOOLEAN DEFAULT TRUE,
    opening_hours VARCHAR(50)
);

COMMENT ON TABLE Facility IS 'Tracks amenities like Spas, Pools, and Gyms per property.';

-- 3. ROOM TYPE (Normalized to BCNF - Pricing depends on Type, not the physical room)
CREATE TABLE RoomType (
    type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    base_price DECIMAL(10,2) NOT NULL,
    max_occupancy INT NOT NULL,
    CONSTRAINT chk_base_price CHECK (base_price > 0),
    CONSTRAINT chk_max_occupancy CHECK (max_occupancy > 0)
);

COMMENT ON TABLE RoomType IS 'Normalized dimension table for room categories (Single, Suite, etc).';

-- 4. RATE PLAN (Dynamic/Seasonal Pricing)
CREATE TABLE RatePlan (
    rate_plan_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    multiplier DECIMAL(3,2) DEFAULT 1.00,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT chk_multiplier CHECK (multiplier > 0),
    CONSTRAINT chk_rate_plan_dates CHECK (end_date > start_date)
);

COMMENT ON TABLE RatePlan IS 'Handles seasonal pricing multipliers (e.g., Christmas markup).';

-- 5. ROOM (Physical Inventory)
CREATE TABLE Room (
    room_id SERIAL PRIMARY KEY,
    property_id INT NOT NULL REFERENCES Property(property_id) ON DELETE CASCADE,
    room_number VARCHAR(10) NOT NULL,
    type_id INT NOT NULL REFERENCES RoomType(type_id) ON DELETE RESTRICT,
    status VARCHAR(20) DEFAULT 'Available',
    floor_number INT NOT NULL,
    CONSTRAINT chk_room_status CHECK (status IN ('Available', 'Occupied', 'Maintenance', 'Cleaning')),
    CONSTRAINT uq_property_room UNIQUE (property_id, room_number) -- Room 101 can exist in Property A and B
);

COMMENT ON TABLE Room IS 'Physical room inventory tracking real-time status.';