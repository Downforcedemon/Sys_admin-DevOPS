import psycopg2
from psycopg2 import sql

# Replace these values with your actual credentials
host = "192.168.4.25"
port = 5432
database = "ecomm"
user = "postgres"
password = "<password>"

try:
    # Connect to the PostgreSQL database
    connection = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password
    )
    print("Connection successful!")

    # Create a cursor object to execute queries
    cursor = connection.cursor()

    # Execute a simple query to test the connection
    cursor.execute("SELECT version();")
    db_version = cursor.fetchone()
    print("PostgreSQL database version:", db_version)

    # Close the cursor and the connection
    cursor.close()
    connection.close()
    print("Connection closed.")

except psycopg2.OperationalError as e:
    print("OperationalError: Could not connect to the database.")
    print("Details:", e)
except Exception as e:
    print("An error occurred:", e)
