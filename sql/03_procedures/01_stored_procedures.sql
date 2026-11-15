-- Encapsulates the booking logic to ensure atomicity (ACID).


CREATE OR REPLACE PROCEDURE sp_make_reservation(
    p_guest_email VARCHAR,
    p_property_id INT,
    p_room_number VARCHAR,
    p_check_in DATE,
    p_check_out DATE,
    p_total_amount DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_guest_id INT;
    v_room_id INT;
    v_res_id INT;
    v_date_key INT;
BEGIN
    -- 1. Validate Guest
    SELECT person_id INTO v_guest_id FROM Person WHERE email = p_guest_email;
    IF v_guest_id IS NULL THEN RAISE EXCEPTION 'Guest not found.'; END IF;

    -- 2. Validate Room
    SELECT room_id INTO v_room_id FROM Room WHERE property_id = p_property_id AND room_number = p_room_number;
    IF v_room_id IS NULL THEN RAISE EXCEPTION 'Room not found at this property.'; END IF;

    -- 3. Insert Reservation (The GiST constraint will throw an error here if double-booked)
    INSERT INTO Reservation (guest_id, room_id, check_in, check_out, status, total_amount)
    VALUES (v_guest_id, v_room_id, p_check_in, p_check_out, 'Confirmed', p_total_amount)
    RETURNING reservation_id INTO v_res_id;

    -- 4. Insert Payment
    INSERT INTO Payment (reservation_id, amount, payment_method, payment_status)
    VALUES (v_res_id, p_total_amount, 'Credit Card', 'Completed');

    -- 5. ETL to Data Warehouse (Fact_Booking)
    SELECT TO_CHAR(p_check_in, 'YYYYMMDD')::INT INTO v_date_key;
    
    INSERT INTO Fact_Booking (reservation_id, room_id, property_id, date_key, revenue)
    VALUES (v_res_id, v_room_id, p_property_id, v_date_key, p_total_amount);

    RAISE NOTICE 'Booking Successful! Reservation ID: %', v_res_id;
END;
$$;