import sys
from db_config import get_db_connection
from psycopg2 import errors

def search_available_rooms(property_id, start_date, end_date):
    conn = get_db_connection()
    if not conn: return
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
        rooms = cur.fetchall()
        print(f"\n--- Available Rooms at Property {property_id} ({start_date} to {end_date}) ---")
        if not rooms: print("No rooms available.")
        for room in rooms:
            print(f"Room {room[0]:<10} | {room[1]:<25} | ${room[2]}/night")
    except Exception as e: print(f"Error: {e}")
    finally: cur.close(); conn.close()

def make_booking(email, prop_id, room_number, check_in, check_out, amount):
    conn = get_db_connection()
    if not conn: return
    cur = conn.cursor()
    try:
        cur.execute("CALL sp_make_reservation(%s, %s, %s, %s, %s, %s)", 
                    (email, prop_id, room_number, check_in, check_out, amount))
        conn.commit()
        print("\n✅ Booking Successful! Payment processed and Data Warehouse updated.")
    except errors.ExclusionViolation:
        conn.rollback()
        print("\n❌ ERROR: Double Booking Prevented by GiST Constraint!")
        print("This room is already reserved for the selected dates.")
    except errors.RaiseException as e:
        conn.rollback()
        print(f"\n❌ ERROR: {e.diag.message_primary}")
    except Exception as e:
        conn.rollback(); print(f"\n❌ Error: {e}")
    finally: cur.close(); conn.close()

def view_analytics():
    conn = get_db_connection()
    if not conn: return
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
        results = cur.fetchall()
        print("\n--- 📊 ENTERPRISE ANALYTICS (OLAP) ---")
        print(f"{'Property':<25} | {'Room Type':<25} | {'Bookings':<8} | {'Revenue'}")
        print("-" * 75)
        for row in results:
            print(f"{row[0]:<25} | {row[1]:<25} | {row[2]:<8} | ${row[3]:,.2f}")
    except Exception as e: print(f"Error: {e}")
    finally: cur.close(); conn.close()

def main():
    while True:
        print("\n=== APEX LUXURY HOTEL SYSTEM ===")
        print("1. Search Available Rooms")
        print("2. Make a Booking")
        print("3. View Revenue Analytics (OLAP)")
        print("4. Exit")
        choice = input("Select (1-4): ")

        if choice == '1':
            print("\nProperties: 1=Mombasa, 2=Nairobi, 3=Diani, 4=Maasai Mara")
            prop = int(input("Property ID: "))
            start = input("Check-in (YYYY-MM-DD): "); end = input("Check-out (YYYY-MM-DD): ")
            search_available_rooms(prop, start, end)
        elif choice == '2':
            email = input("Guest Email: "); prop = int(input("Property ID: ")); room = input("Room Number: ")
            start = input("Check-in (YYYY-MM-DD): "); end = input("Check-out (YYYY-MM-DD): ")
            amount = float(input("Total Amount: $"))
            make_booking(email, prop, room, start, end, amount)
        elif choice == '3':
            view_analytics()
        elif choice == '4': 
            print("Exiting system.")
            sys.exit()
        else:
            print("Invalid choice.")

if __name__ == "__main__": 
    main()