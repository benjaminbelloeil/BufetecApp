from flask import Flask, request, jsonify
from pymongo import MongoClient
from bson import ObjectId
import bcrypt

app = Flask(__name__)

# MongoDB setup
client = MongoClient("mongodb://localhost:27017/Users")
db = client["Bufetec"]
users_collection = db["Users"]

# Helper function to hash passwords
def hash_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

# Helper function to check password
def check_password(hashed_password, password):
    return bcrypt.checkpw(password.encode('utf-8'), hashed_password)

# Sign-up route
@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    name = data['name']
    email = data['email']
    password = data['password']

    # Check if user already exists
    if users_collection.find_one({"email": email}):
        return jsonify({"message": "User already exists"}), 400

    # Hash the password and store user data
    hashed_password = hash_password(password)
    user_data = {"name": name, "email": email, "password": hashed_password}
    users_collection.insert_one(user_data)

    return jsonify({"message": "User created successfully"}), 201

# Login route
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']

    user = users_collection.find_one({"email": email})

    if user and check_password(user['password'], password):
        return jsonify({"message": "Login successful", "user_id": str(user['_id'])}), 200
    else:
        return jsonify({"message": "Invalid credentials"}), 401

if __name__ == '__main__':
    app.run(debug=True)
    