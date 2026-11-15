# CRISP-DM Phase 6: Deployment

## 1. Current Deployment (Milestone 2)
The system is currently deployed as a local Python Command Line Interface (CLI) interacting with a PostgreSQL database. The architecture uses a Service Layer (`booking_service.py`) to separate SQL logic from the user interface. 
*   Dependencies are managed via `requirements.txt`.
*   Automated testing is handled via `pytest`.

## 2. Future Deployment (Milestone 6)
In future iterations, the deployment will be expanded:
*   **API Layer:** A FastAPI wrapper will be deployed to expose the database logic as RESTful endpoints for web and mobile frontends.
*   **Scheduled ETL:** The real-time ETL inside the stored procedure may be moved to an Apache Airflow cron job to handle massive scale.
*   **Visualization:** Integration with a dashboarding tool (e.g., PowerBI or Streamlit) to visualize the OLAP data dynamically.