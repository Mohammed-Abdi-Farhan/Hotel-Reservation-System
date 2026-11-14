import psycopg2
from psycopg2 import Error, OperationalError

# ============================================================================
# DATABASE CONFIGURATION
# ============================================================================
DB_NAME = "hotel_enterprise"
DB_USER = "postgres"
DB_PASSWORD = "postgres" 
DB_HOST = "localhost"
DB_PORT = "5432"

def get_db_connection():
    """
    Establishes and returns a connection to the PostgreSQL database.
    Handles connection errors gracefully so the application doesn't crash.
    """
    try:
        connection = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT
        )
        return connection
    except OperationalError as e:
        print(f"\n❌ FATAL ERROR: Could not connect to the database.")
        print(f"   Reason: {e}")
        print("   Please check that PostgreSQL is running and your password is correct.\n")
        return None
    except Error as e:
        print(f"\n❌ Unexpected Database Error: {e}\n")
        return None

def close_db_connection(conn, cursor=None):
    """
    Safely closes the cursor and connection to prevent memory leaks.
    """
    if cursor:
        cursor.close()
    if conn:
        conn.close()

# ============================================================================
# SELF-TEST BLOCK (Run this file directly to test your connection)
# ============================================================================
if __name__ == "__main__":
    print("Testing database connection...")
    test_conn = get_db_connection()
    
    if test_conn:
        print("✅ Connection Successful!")
        
        # Test a simple query
        try:
            cur = test_conn.cursor()
            cur.execute("SELECT version();")
            db_version = cur.fetchone()
            print(f"✅ Connected to: {db_version[0]}")
            close_db_connection(test_conn, cur)
        except Exception as e:
            print(f"❌ Query failed: {e}")
    else:
        print("❌ Connection Failed. Please check your credentials.")