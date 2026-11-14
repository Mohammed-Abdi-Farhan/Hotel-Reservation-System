import psycopg2
from psycopg2 import Error

def get_db_connection():
    try:
        return psycopg2.connect(
            dbname="hotel_enterprise",
            user="postgres",
            password="postgres", 
            host="localhost",
            port="5432"
        )
    except Error as e:
        print(f"Database connection error: {e}")
        return None