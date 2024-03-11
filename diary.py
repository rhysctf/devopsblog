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
    CREATE TABLE IF NOT EXISTS diarys (
        id INT AUTO_INCREMENT PRIMARY KEY,
        feature VARCHAR(255),
        description INT(15)
    )
""")

# Define route to display extensions
@app.route('/')
def show_exts():
    
    # Retrieve data from the database
    cursor.execute("SELECT feature, description FROM diarys")
    diarys = cursor.fetchall()
    return render_template('diarys.html', diarys=diarys)

# Define route to add new extension
@app.route('/add_extension', methods=['POST'])
def add_extension():
    feature = request.form['feature']
    description = int(request.form['description'])

    # Insert data into the database
    cursor.execute("INSERT INTO diarys (feature, description) VALUES (%s, %s)", (feature, description))
    conn.commit()
    return redirect(url_for('show_exts'))

if __name__ == '__main__':
    app.run(debug=True)
