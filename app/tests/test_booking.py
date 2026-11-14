import pytest
import sys
import os

# Add the app directory to the path so we can import services
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from services.booking_service import search_available_rooms, make_booking, get_revenue_analytics

def test_search_available_rooms():
    """Test that the search returns a list (even if empty)."""
    rooms = search_available_rooms(property_id=1, start_date='2030-01-01', end_date='2030-01-05')
    assert type(rooms) is list, "The search function must return a list."

def test_valid_booking():
    """Test that a valid booking succeeds."""
    # Using dates far in the future to avoid conflicts with seed data
    success, message = make_booking(
        email='tony.s@email.com', 
        prop_id=2, 
        room_number='301', 
        check_in='2030-05-01', 
        check_out='2030-05-05', 
        amount=1200.00
    )
    assert success is True, f"Valid booking failed: {message}"

def test_double_booking_prevention():
    """Test that a double-booking attempt is rejected by the database GiST constraint."""
    # We try to book the exact same room and dates we just booked above
    success, message = make_booking(
        email='steve.r@email.com', # Different guest
        prop_id=2, 
        room_number='301', 
        check_in='2030-05-03', # Overlapping dates
        check_out='2030-05-07', 
        amount=1200.00
    )
    
    # The system should return False and the specific error message
    assert success is False, "System allowed a double booking!"
    assert "Double Booking Prevented" in message, f"Wrong error message returned: {message}"

def test_analytics_retrieval():
    """Test that the OLAP analytics query returns data."""
    results = get_revenue_analytics()
    assert type(results) is list, "Analytics must return a list."
    assert len(results) > 0, "Analytics returned no data from the warehouse."