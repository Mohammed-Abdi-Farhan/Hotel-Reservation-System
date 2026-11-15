--   Enforces no-double-booking, optimizes performance, 
--          and initializes the Data Warehouse Star Schema.

-- The core rule: prevent overlapping confirmed reservations for the same room
ALTER TABLE Reservation ADD CONSTRAINT no_overlapping_bookings
EXCLUDE USING gist (
    room_id WITH =,
    daterange(check_in, check_out, '[]') WITH &&
) WHERE (status = 'Confirmed');

-- Indexes to speed up lookups
CREATE INDEX idx_person_email ON Person USING btree (email);
CREATE INDEX idx_reservation_daterange ON Reservation USING gist (daterange(check_in, check_out, '[]'));
CREATE INDEX idx_room_property_type_status ON Room (property_id, type_id, status);

-- Basic star schema for revenue analytics (Milestone 6)
CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY, -- Format: YYYYMMDD
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    quarter INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE Fact_Booking (
    fact_id BIGSERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES Reservation(reservation_id),
    room_id INT NOT NULL REFERENCES Room(room_id),
    property_id INT NOT NULL REFERENCES Property(property_id),
    date_key INT NOT NULL REFERENCES Dim_Date(date_key),
    revenue DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_fact_revenue CHECK (revenue > 0)
);
