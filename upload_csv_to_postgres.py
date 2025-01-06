import psycopg2
import csv

# Database connection details
conn = psycopg2.connect(
    dbname="$dbname",
    user="$username",
    password="your_password",
    host="192.168.x.x",  # IP of your Red Hat VM
    port="5432"
)
cursor = conn.cursor()

# Path to the CSV file
csv_file_path = "/path/to/your/orders.csv"

# Open the CSV file and insert into the database
with open(csv_file_path, 'r') as file:
    cursor.copy_expert("COPY $table_name FROM STDIN WITH CSV HEADER DELIMITER ','", file)

conn.commit()
cursor.close()
conn.close()


