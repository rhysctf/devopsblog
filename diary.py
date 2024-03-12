from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# MySQL database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'diary'
}

# Establish a connection to the database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Create a table if it doesn't exist
cursor.execute("""
    CREATE TABLE IF NOT EXISTS diary (
        id INT AUTO_INCREMENT PRIMARY KEY,
        feature VARCHAR(255),
        description VARCHAR(255)
    )
""")

# Define route to display extensions
@app.route('/')
def show_diary():
    
    # Retrieve data from the database
    cursor.execute("SELECT feature, description FROM diary")
    diaries = cursor.fetchall()
    return render_template('diary.html', diaries=diaries)

# Define route to add new feature
@app.route('/add_feature', methods=['POST'])
def add_feature():
    feature = request.form['feature']
    description = request.form['description']

    # Insert data into the database
    cursor.execute("INSERT INTO diary (feature, description) VALUES (%s, %s)", (feature, description))
    conn.commit()
    return redirect(url_for('show_diary'))

if __name__ == '__main__':
    app.run(debug=True)
