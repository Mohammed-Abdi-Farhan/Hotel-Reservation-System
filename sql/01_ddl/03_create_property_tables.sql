-- Multi-Property architecture, Facilities, Room Types, and Rates.
--          Designed for a scalable hotel chain (e.g., Marriott, Hilton).


-- Property table (Physical hotel branches)
CREATE TABLE Property (
    property_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    star_rating INT NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    CONSTRAINT chk_star_rating CHECK (star_rating BETWEEN 1 AND 5)
);

-- Add the Staff foreign key now that Property exists
ALTER TABLE Staff ADD CONSTRAINT fk_staff_property 
FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE SET NULL;

-- Amenities offered at specific properties
CREATE TABLE Facility (
    facility_id SERIAL PRIMARY KEY,
    property_id INT NOT NULL REFERENCES Property(property_id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    is_complimentary BOOLEAN DEFAULT TRUE,
    opening_hours VARCHAR(50)
);

-- Room categories (extracted to BCNF to keep pricing out of the physical Room table)
CREATE TABLE RoomType (
    type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    base_price DECIMAL(10,2) NOT NULL,
    max_occupancy INT NOT NULL,
    CONSTRAINT chk_base_price CHECK (base_price > 0),
    CONSTRAINT chk_max_occupancy CHECK (max_occupancy > 0)
);

-- Seasonal pricing multipliers
CREATE TABLE RatePlan (
    rate_plan_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    multiplier DECIMAL(3,2) DEFAULT 1.00,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT chk_multiplier CHECK (multiplier > 0),
    CONSTRAINT chk_rate_plan_dates CHECK (end_date > start_date)
);

-- Physical room inventory
CREATE TABLE Room (
    room_id SERIAL PRIMARY KEY,
    property_id INT NOT NULL REFERENCES Property(property_id) ON DELETE CASCADE,
    room_number VARCHAR(10) NOT NULL,
    type_id INT NOT NULL REFERENCES RoomType(type_id) ON DELETE RESTRICT,
    status VARCHAR(20) DEFAULT 'Available',
    floor_number INT NOT NULL,
    CONSTRAINT chk_room_status CHECK (status IN ('Available', 'Occupied', 'Maintenance', 'Cleaning')),
    CONSTRAINT uq_property_room UNIQUE (property_id, room_number) -- Allows Room 101 in both Mombasa and Nairobi
);