--  Populates the enterprise database with realistic seed data.


-- 1. Clean Slate & Reset IDs (Safe to run multiple times)
TRUNCATE TABLE Fact_Booking, Payment, Reservation, Reservation_Audit, Room, Facility, Property, RatePlan, RoomType, Guest, Staff, Person, Dim_Date RESTART IDENTITY CASCADE;

-- 2. Insert Properties
INSERT INTO Property (name, city, country, star_rating, contact_email) VALUES
('Mombasa Beach Resort', 'Mombasa', 'Kenya', 5, 'mombasa@apexluxury.com'),
('Nairobi City Hotel', 'Nairobi', 'Kenya', 5, 'nairobi@apexluxury.com'),
('Diani Ocean Suites', 'Diani', 'Kenya', 5, 'diani@apexluxury.com'),
('Maasai Mara Safari Lodge', 'Narok', 'Kenya', 5, 'mara@apexluxury.com');

-- 3. Insert Facilities
INSERT INTO Facility (property_id, name, is_complimentary, opening_hours) VALUES
(1, 'Infinity Ocean Pool', TRUE, '06:00 - 22:00'),
(1, 'Michelin-Star Seafood Restaurant', FALSE, '12:00 - 23:00'),
(1, 'Ocean Spa & Wellness', FALSE, '09:00 - 20:00'),
(2, 'Executive Business Center', TRUE, '24/7'),
(2, 'Rooftop Sky Bar', FALSE, '17:00 - 02:00'),
(3, 'Private White-Sand Beach', TRUE, '24/7'),
(3, 'Scuba Diving Center', FALSE, '08:00 - 18:00'),
(4, 'Guided Safari Game Drives', TRUE, '06:00 - 18:00'),
(4, 'Outdoor Bush Dinner', FALSE, '19:00 - 22:00');

-- 4. Insert Room Types
INSERT INTO RoomType (name, base_price, max_occupancy) VALUES
('Standard Garden View', 100.00, 2),
('Deluxe Ocean View', 180.00, 2),
('Executive Club Room', 300.00, 2),
('Junior Suite', 450.00, 3),
('Master Suite', 700.00, 4),
('Presidential Suite', 1500.00, 6),
('Royal Penthouse', 3000.00, 8),
('Private Safari Villa', 4500.00, 10);

-- 5. Insert Rate Plans
INSERT INTO RatePlan (name, multiplier, start_date, end_date) VALUES
('Standard Corporate Rate', 1.00, '2026-01-01', '2026-12-31'),
('Peak Christmas Season', 1.85, '2026-12-15', '2027-01-05'),
('Summer Holiday Promo', 1.25, '2026-07-01', '2026-08-31'),
('Government/Military Rate', 0.80, '2026-01-01', '2026-12-31');

-- 6. Insert People
INSERT INTO Person (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@email.com', '+254700000001'),
('Jane', 'Smith', 'jane.smith@email.com', '+254700000002'),
('Alice', 'Johnson', 'alice.j@email.com', '+254700000003'),
('Bob', 'Williams', 'bob.w@email.com', '+254700000004'),
('Charlie', 'Brown', 'charlie.b@email.com', '+254700000005'),
('Diana', 'Prince', 'diana.p@email.com', '+254700000006'),
('Bruce', 'Wayne', 'bruce.w@email.com', '+254700000007'),
('Clark', 'Kent', 'clark.k@email.com', '+254700000008'),
('Tony', 'Stark', 'tony.s@email.com', '+254700000009'),
('Natasha', 'Romanoff', 'natasha.r@email.com', '+254700000010'),
('Steve', 'Rogers', 'steve.r@email.com', '+254700000011'),
('Peter', 'Parker', 'peter.p@email.com', '+254700000012'),
('Wanda', 'Maximoff', 'wanda.m@email.com', '+254700000013'),
('Stephen', 'Strange', 'stephen.s@email.com', '+254700000014'),
('Carol', 'Danvers', 'carol.d@email.com', '+254700000015'),
('Obi-Wan', 'Kenobi', 'obiwan.k@email.com', '+254700000016'),
('Anakin', 'Skywalker', 'anakin.s@email.com', '+254700000017'),
('Padme', 'Amidala', 'padme.a@email.com', '+254700000018'),
('Leia', 'Organa', 'leia.o@email.com', '+254700000019'),
('Han', 'Solo', 'han.s@email.com', '+254700000020'),
('Eve', 'Davis', 'eve.d@apexluxury.com', '+254711000001'),    
('Frank', 'Miller', 'frank.m@apexluxury.com', '+254711000002'), 
('Grace', 'Hopper', 'grace.h@apexluxury.com', '+254711000003'), 
('Henry', 'Ford', 'henry.f@apexluxury.com', '+254711000004'),   
('Ivy', 'League', 'ivy.l@apexluxury.com', '+254711000005'),
('Jack', 'Ryan', 'jack.r@apexluxury.com', '+254711000006'),
('Karen', 'Page', 'karen.p@apexluxury.com', '+254711000007'),
('Luke', 'Cage', 'luke.c@apexluxury.com', '+254711000008'),
('Matt', 'Murdock', 'matt.m@apexluxury.com', '+254711000009'),
('Nina', 'Williams', 'nina.w@apexluxury.com', '+254711000010');

-- 7. Insert Guests
INSERT INTO Guest (person_id, loyalty_points, vip_status) VALUES
(1, 150, 'Silver'), (2, 1200, 'Gold'), (3, 0, 'Standard'),
(4, 5000, 'Platinum'), (5, 50, 'Standard'), (6, 8500, 'Diamond'),
(7, 3000, 'Platinum'), (8, 200, 'Silver'), (9, 15000, 'Ambassador'),
(10, 450, 'Silver'), (11, 800, 'Gold'), (12, 100, 'Silver'),
(13, 2500, 'Platinum'), (14, 6000, 'Diamond'), (15, 12000, 'Ambassador'),
(16, 50, 'Standard'), (17, 900, 'Gold'), (18, 4000, 'Platinum'),
(19, 11000, 'Ambassador'), (20, 300, 'Silver');

-- 8. Insert Staff
INSERT INTO Staff (person_id, role, property_id) VALUES
(21, 'General Manager', 1), (22, 'Front Desk', 1), 
(23, 'Housekeeping', 2), (24, 'Chef', 3), (25, 'Security', 3),
(26, 'General Manager', 2), (27, 'Front Desk', 4), 
(28, 'Chef', 1), (29, 'Housekeeping', 4), (30, 'Front Desk', 3);

-- 9. Insert Rooms
INSERT INTO Room (property_id, room_number, type_id, status, floor_number) VALUES
(1, '101', 1, 'Available', 1), (1, '102', 1, 'Available', 1),
(1, '201', 2, 'Available', 2), (1, '202', 2, 'Available', 2),
(1, '301', 3, 'Available', 3), (1, '302', 3, 'Available', 3),
(1, '401', 4, 'Available', 4), (1, '501', 5, 'Available', 5),
(1, 'PH-01', 6, 'Available', 6), (1, 'ROYAL-1', 7, 'Available', 7),
(2, '101', 1, 'Available', 1), (2, '201', 2, 'Available', 2),
(2, '301', 3, 'Available', 3), (2, '401', 4, 'Available', 4),
(2, '501', 5, 'Available', 5), (2, 'PH-N1', 6, 'Available', 6),
(2, 'PH-N2', 6, 'Available', 6), (2, 'ROYAL-N', 7, 'Available', 7),
(3, 'Villa-1', 5, 'Available', 1), (3, 'Villa-2', 5, 'Available', 1),
(3, 'Villa-3', 5, 'Available', 1), (3, 'Suite-1', 4, 'Available', 2),
(3, 'Suite-2', 4, 'Available', 2), (3, 'ROYAL-D', 7, 'Available', 3),
(4, 'Safari-V1', 8, 'Available', 1), (4, 'Safari-V2', 8, 'Available', 1),
(4, 'Safari-V3', 8, 'Available', 1), (4, 'Safari-V4', 8, 'Available', 1);

-- 10. Insert Reservations (Using Dynamic Subqueries)
INSERT INTO Reservation (guest_id, room_id, rate_plan_id, check_in, check_out, status, total_amount) VALUES
((SELECT person_id FROM Person WHERE email = 'john.doe@email.com'), (SELECT room_id FROM Room WHERE room_number = '101' AND property_id = 1), 1, '2026-01-10', '2026-01-15', 'Completed', 500.00),
((SELECT person_id FROM Person WHERE email = 'jane.smith@email.com'), (SELECT room_id FROM Room WHERE room_number = '401' AND property_id = 1), 1, '2026-02-14', '2026-02-18', 'Completed', 1800.00),
((SELECT person_id FROM Person WHERE email = 'bob.w@email.com'), (SELECT room_id FROM Room WHERE room_number = '501' AND property_id = 2), 1, '2026-02-20', '2026-02-25', 'Completed', 3500.00),
((SELECT person_id FROM Person WHERE email = 'tony.s@email.com'), (SELECT room_id FROM Room WHERE room_number = 'ROYAL-D' AND property_id = 3), 3, '2026-03-01', '2026-03-08', 'Completed', 15750.00),
((SELECT person_id FROM Person WHERE email = 'alice.j@email.com'), (SELECT room_id FROM Room WHERE room_number = '102' AND property_id = 1), 1, '2026-03-15', '2026-03-18', 'Cancelled', 300.00),
((SELECT person_id FROM Person WHERE email = 'diana.p@email.com'), (SELECT room_id FROM Room WHERE room_number = 'Villa-2' AND property_id = 3), 1, '2026-04-01', '2026-04-10', 'Completed', 4000.00),
((SELECT person_id FROM Person WHERE email = 'peter.p@email.com'), (SELECT room_id FROM Room WHERE room_number = 'Safari-V2' AND property_id = 4), 1, '2026-04-15', '2026-04-18', 'Completed', 13500.00),
((SELECT person_id FROM Person WHERE email = 'carol.d@email.com'), (SELECT room_id FROM Room WHERE room_number = 'PH-01' AND property_id = 1), 1, '2026-05-01', '2026-05-05', 'Completed', 6000.00),
((SELECT person_id FROM Person WHERE email = 'clark.k@email.com'), (SELECT room_id FROM Room WHERE room_number = '301' AND property_id = 2), 1, '2026-05-20', '2026-05-22', 'Completed', 700.00),
((SELECT person_id FROM Person WHERE email = 'leia.o@email.com'), (SELECT room_id FROM Room WHERE room_number = 'PH-N1' AND property_id = 2), 4, '2026-06-10', '2026-06-20', 'Completed', 9000.00),
((SELECT person_id FROM Person WHERE email = 'obiwan.k@email.com'), (SELECT room_id FROM Room WHERE room_number = '101' AND property_id = 2), 1, '2026-06-01', '2026-06-05', 'Completed', 500.00),
((SELECT person_id FROM Person WHERE email = 'bruce.w@email.com'), (SELECT room_id FROM Room WHERE room_number = '301' AND property_id = 1), 3, '2026-07-05', '2026-07-15', 'Completed', 2250.00),
((SELECT person_id FROM Person WHERE email = 'wanda.m@email.com'), (SELECT room_id FROM Room WHERE room_number = 'ROYAL-N' AND property_id = 2), 3, '2026-07-20', '2026-07-25', 'Completed', 2812.50),
((SELECT person_id FROM Person WHERE email = 'anakin.s@email.com'), (SELECT room_id FROM Room WHERE room_number = '302' AND property_id = 1), 1, '2026-08-01', '2026-08-05', 'Completed', 1200.00),
((SELECT person_id FROM Person WHERE email = 'charlie.b@email.com'), (SELECT room_id FROM Room WHERE room_number = '201' AND property_id = 2), 3, '2026-08-15', '2026-08-20', 'Completed', 1125.00),
((SELECT person_id FROM Person WHERE email = 'natasha.r@email.com'), (SELECT room_id FROM Room WHERE room_number = '401' AND property_id = 2), 1, '2026-09-10', '2026-09-12', 'No-Show', 600.00),
((SELECT person_id FROM Person WHERE email = 'john.doe@email.com'), (SELECT room_id FROM Room WHERE room_number = '501' AND property_id = 1), 1, '2026-10-10', '2026-10-15', 'Confirmed', 2000.00),
((SELECT person_id FROM Person WHERE email = 'padme.a@email.com'), (SELECT room_id FROM Room WHERE room_number = 'PH-N2' AND property_id = 2), 1, '2026-11-05', '2026-11-10', 'Confirmed', 3500.00),
((SELECT person_id FROM Person WHERE email = 'steve.r@email.com'), (SELECT room_id FROM Room WHERE room_number = 'Safari-V4' AND property_id = 4), 1, '2026-11-15', '2026-11-20', 'Confirmed', 22500.00),
((SELECT person_id FROM Person WHERE email = 'stephen.s@email.com'), (SELECT room_id FROM Room WHERE room_number = 'ROYAL-1' AND property_id = 1), 2, '2026-12-20', '2026-12-27', 'Confirmed', 19425.00),
((SELECT person_id FROM Person WHERE email = 'han.s@email.com'), (SELECT room_id FROM Room WHERE room_number = 'Suite-2' AND property_id = 3), 2, '2026-12-22', '2026-12-28', 'Confirmed', 23310.00);

-- 11. Insert Payments
INSERT INTO Payment (reservation_id, amount, payment_method, payment_status)
SELECT reservation_id, total_amount, 'Credit Card', 'Completed' 
FROM Reservation WHERE status IN ('Completed', 'Confirmed');

-- 12. Populate Dim_Date
INSERT INTO Dim_Date (date_key, full_date, year, month, day, quarter, is_weekend)
SELECT 
    TO_CHAR(d, 'YYYYMMDD')::INT, d, EXTRACT(YEAR FROM d), EXTRACT(MONTH FROM d), 
    EXTRACT(DAY FROM d), EXTRACT(QUARTER FROM d),
    CASE WHEN EXTRACT(ISODOW FROM d) IN (6, 7) THEN TRUE ELSE FALSE END
FROM generate_series('2026-01-01'::date, '2026-12-31'::date, '1 day'::interval) d;

-- 13. ETL: Populate Fact_Booking (Data Warehouse)
INSERT INTO Fact_Booking (reservation_id, room_id, property_id, date_key, revenue)
SELECT 
    r.reservation_id, 
    r.room_id, 
    rm.property_id, 
    TO_CHAR(r.check_in, 'YYYYMMDD')::INT, 
    r.total_amount
FROM Reservation r
JOIN Room rm ON r.room_id = rm.room_id
WHERE r.status IN ('Completed', 'Confirmed');