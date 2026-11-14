-- ============================================================================
-- FILE: 02_triggers_and_views.sql
-- PURPOSE: Implements automated auditing and simplified reporting.
-- ============================================================================

-- 1. TRIGGER FUNCTION: Automated Audit Logging
CREATE OR REPLACE FUNCTION log_reservation_action()
RETURNS TRIGGER AS $func$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO Reservation_Audit(reservation_id, action_type) VALUES (OLD.reservation_id, 'DELETE');
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO Reservation_Audit(reservation_id, action_type) VALUES (NEW.reservation_id, 'UPDATE');
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO Reservation_Audit(reservation_id, action_type) VALUES (NEW.reservation_id, 'INSERT');
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$func$ LANGUAGE plpgsql;

-- 2. ATTACH TRIGGER TO RESERVATION TABLE
DROP TRIGGER IF EXISTS trg_reservation_audit ON Reservation;
CREATE TRIGGER trg_reservation_audit
AFTER INSERT OR UPDATE OR DELETE ON Reservation
FOR EACH ROW EXECUTE FUNCTION log_reservation_action();

-- 3. CREATE VIEW: Simplified Reporting
CREATE OR REPLACE VIEW v_active_bookings AS
SELECT 
    r.reservation_id,
    p.first_name || ' ' || p.last_name AS guest_name,
    pr.name AS property_name,
    rm.room_number,
    rt.name AS room_type,
    r.check_in,
    r.check_out,
    r.total_amount,
    r.status
FROM Reservation r
JOIN Guest g ON r.guest_id = g.person_id
JOIN Person p ON g.person_id = p.person_id
JOIN Room rm ON r.room_id = rm.room_id
JOIN Property pr ON rm.property_id = pr.property_id
JOIN RoomType rt ON rm.type_id = rt.type_id
WHERE r.status = 'Confirmed';