from flask import Flask, render_template
import mysql.connector

app = Flask(__name__)

# MySQL database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'vscode_extensions'
}

# Establish a connection to the database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Create a table if not exists
cursor.execute("""
    CREATE TABLE IF NOT EXISTS exts (
        name VARCHAR(255),
        downloads INT(15)
    )
""")

# Define route to display extsensions
@app.route('/')
def show_exts():
    # Retrieve data from the database
    cursor.execute("SELECT name, downloads FROM exts")
    exts = cursor.fetchall()
    return render_template('exts.html', exts=exts)

if __name__ == '__main__':
    app.run(debug=True)
