from app.db_config import get_db_connection
from psycopg2 import errors

def search_available_rooms(property_id, start_date, end_date):
    """Business logic to find available rooms."""
    conn = get_db_connection()
    if not conn: return []
    cur = conn.cursor()
    query = """
        SELECT r.room_number, rt.name, rt.base_price
        FROM Room r
        JOIN RoomType rt ON r.type_id = rt.type_id
        WHERE r.property_id = %s AND r.status != 'Maintenance'
        AND NOT EXISTS (
            SELECT 1 FROM Reservation res
            WHERE res.room_id = r.room_id AND res.status = 'Confirmed'
            AND daterange(res.check_in, res.check_out, '[]') && daterange(%s, %s, '[]')
        ) ORDER BY rt.base_price ASC;
    """
    try:
        cur.execute(query, (property_id, start_date, end_date))
        return cur.fetchall()
    except Exception as e: 
        print(f"Error: {e}")
        return []
    finally: 
        cur.close()
        conn.close()

def make_booking(email, prop_id, room_number, check_in, check_out, amount):
    """Business logic to create a booking."""
    conn = get_db_connection()
    if not conn: return False, "Database connection failed."
    cur = conn.cursor()
    try:
        cur.execute("CALL sp_make_reservation(%s, %s, %s, %s, %s, %s)", 
                    (email, prop_id, room_number, check_in, check_out, amount))
        conn.commit()
        return True, "✅ Booking Successful! Payment processed and Data Warehouse updated."
    except errors.ExclusionViolation:
        conn.rollback()
        return False, "❌ ERROR: Double Booking Prevented by GiST Constraint!"
    except errors.RaiseException as e:
        conn.rollback()
        return False, f"❌ ERROR: {e.diag.message_primary}"
    except Exception as e:
        conn.rollback()
        return False, f"❌ Error: {e}"
    finally: 
        cur.close()
        conn.close()

def get_revenue_analytics():
    """Business logic for OLAP analytics."""
    conn = get_db_connection()
    if not conn: return []
    cur = conn.cursor()
    query = """
        SELECT p.name AS Property, rt.name AS Room_Type, COUNT(f.fact_id) AS Bookings, SUM(f.revenue) AS Total_Revenue
        FROM Fact_Booking f
        JOIN Room r ON f.room_id = r.room_id
        JOIN RoomType rt ON r.type_id = rt.type_id
        JOIN Property p ON f.property_id = p.property_id
        GROUP BY p.name, rt.name
        ORDER BY Total_Revenue DESC;
    """
    try:
        cur.execute(query)
        return cur.fetchall()
    except Exception as e: 
        print(f"Error: {e}")
        return []
    finally: 
        cur.close()
        conn.close()