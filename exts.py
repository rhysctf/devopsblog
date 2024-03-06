from flask import Flask, render_template, request, redirect, url_for
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

# Create a table if it doesn't exist
cursor.execute("""
    CREATE TABLE IF NOT EXISTS exts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255),
        downloads INT(15)
    )
""")

# Define route to display extensions
@app.route('/')
def show_exts():
    
    # Retrieve data from the database
    cursor.execute("SELECT name, downloads FROM exts")
    exts = cursor.fetchall()
    return render_template('exts.html', exts=exts)

# Define route to add new extension
@app.route('/add_extension', methods=['POST'])
def add_extension():
    name = request.form['name']
    downloads = int(request.form['downloads'])

    # Insert data into the database
    cursor.execute("INSERT INTO exts (name, downloads) VALUES (%s, %s)", (name, downloads))
    conn.commit()
    return redirect(url_for('show_exts'))

if __name__ == '__main__':
    app.run(debug=True)
