import sys
from services.booking_service import search_available_rooms, make_booking, get_revenue_analytics

def get_int_input(prompt):
    """Helper to safely get an integer input without crashing."""
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("❌ Invalid input. Please enter a number.")

def get_float_input(prompt):
    """Helper to safely get a float input without crashing."""
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("❌ Invalid input. Please enter a valid amount.")

def main():
    print("==============================================")
    print("  HOTEL RESERVATION SYSTEM   ")
    print("==============================================")
    
    while True:
        print("\n--- MAIN MENU ---")
        print("1. Search Available Rooms")
        print("2. Make a Booking")
        print("3. View Revenue Analytics (OLAP)")
        print("4. Exit")
        
        choice = input("Select an option (1-4): ").strip()

        if choice == '1':
            print("\n[Properties: 1=Mombasa, 2=Nairobi, 3=Diani, 4=Maasai Mara]")
            prop = get_int_input("Property ID: ")
            start = input("Check-in (YYYY-MM-DD): ").strip()
            end = input("Check-out (YYYY-MM-DD): ").strip()
            
            print(f"\n⏳ Searching for rooms...")
            rooms = search_available_rooms(prop, start, end)
            
            if not rooms:
                print("❌ No rooms available for these dates.")
            else:
                print(f"\n--- 🟢 AVAILABLE ROOMS AT PROPERTY {prop} ({start} to {end}) ---")
                print(f"{'Room':<10} | {'Type':<25} | {'Price/Night'}")
                print("-" * 55)
                for room in rooms:
                    print(f"{room[0]:<10} | {room[1]:<25} | ${room[2]:,.2f}")

        elif choice == '2':
            print("\n--- 📝 NEW BOOKING ---")
            email = input("Guest Email: ").strip()
            prop = get_int_input("Property ID: ")
            room = input("Room Number: ").strip()
            start = input("Check-in (YYYY-MM-DD): ").strip()
            end = input("Check-out (YYYY-MM-DD): ").strip()
            amount = get_float_input("Total Amount: $")
            
            print(f"\n⏳ Processing booking...")
            success, message = make_booking(email, prop, room, start, end, amount)
            print(message)

        elif choice == '3':
            print("\n⏳ Generating OLAP Analytics from Data Warehouse...")
            results = get_revenue_analytics()
            
            if not results:
                print("❌ No analytics data available.")
            else:
                print("\n--- 📊 ENTERPRISE ANALYTICS (OLAP) ---")
                print(f"{'Property':<25} | {'Room Type':<25} | {'Bookings':<8} | {'Total Revenue'}")
                print("-" * 80)
                for row in results:
                    print(f"{row[0]:<25} | {row[1]:<25} | {row[2]:<8} | ${row[3]:,.2f}")

        elif choice == '4':
            print("\nExiting system. Goodbye!")
            sys.exit(0)
            
        else:
            print("❌ Invalid choice. Please select 1, 2, 3, or 4.")

if __name__ == "__main__":
    main()