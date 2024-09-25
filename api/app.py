from flask import Flask, request, jsonify
from flask_pymongo import PyMongo  # type: ignore
from werkzeug.security import generate_password_hash, check_password_hash
from bson.objectid import ObjectId
from flask_cors import CORS  # type: ignore
import logging


app: Flask = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# MongoDB configuration
app.config["MONGO_URI"] = "mongodb://10.14.255.54:27017/BufetecDB"
mongo = PyMongo(app)

# Test MongoDB connection
try:
    mongo.db.command('ping')
    app.logger.info("MongoDB connection successful")
except Exception as e:
    app.logger.error(f"MongoDB connection failed: {str(e)}")

# Collections
users_collection = mongo.db.users
lawyers_collection = mongo.db.abogados
students_collection = mongo.db.alumnos
clients_collection = mongo.db.clientes

# Password hashing utility
def hash_password(password):
    return generate_password_hash(password)

def verify_password(stored_password, provided_password):
    return check_password_hash(stored_password, provided_password)

# Sign-Up Route
@app.route('/signup', methods=['POST'])
def signup():
    try:
        data = request.get_json()
        app.logger.info(f"Received signup data: {data}")

        # Extract sign-up details
        name = data.get('name')
        email_or_phone = data.get('email_or_phone')
        password = data.get('password')

        # Validate input
        if not all([name, email_or_phone, password]):
            return jsonify({"error": "Missing required fields"}), 400

        # Check if user already exists
        existing_user = users_collection.find_one({"email_or_phone": email_or_phone})
        if existing_user:
            return jsonify({"error": "User already exists"}), 409

        # Hash password
        hashed_password = hash_password(password)

        # Insert into users collection
        new_user = {
            "name": name,
            "email_or_phone": email_or_phone,
            "password": hashed_password,
        }
        result = users_collection.insert_one(new_user)
        
        if result.inserted_id:
            app.logger.info(f"User created with ID: {result.inserted_id}")
            return jsonify({"message": "Signup successful", "user_id": str(result.inserted_id)}), 201
        else:
            app.logger.error("Failed to insert user into database")
            return jsonify({"error": "Failed to create user"}), 500

    except Exception as e:
        app.logger.error(f"Error in signup: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Role Questionnaire Route
@app.route('/role', methods=['POST'])
def role():
    try:
        data = request.get_json()
        app.logger.info(f"Received role data: {data}")
        user_id = data.get('user_id')
        role = data.get('role')

        if not user_id or not role:
            return jsonify({"error": "Missing user_id or role"}), 400

        if role == 'client':
            case_type = data.get('case_type')
            if not case_type:
                return jsonify({"error": "Missing case_type for client"}), 400
            result = clients_collection.insert_one({
                "user_id": ObjectId(user_id),
                "case_type": case_type
            })
        elif role == 'lawyer':
            lawyer_id = data.get('lawyer_id')
            password = data.get('password')
            if not lawyer_id or not password:
                return jsonify({"error": "Missing lawyer_id or password"}), 400
            result = lawyers_collection.insert_one({
                "user_id": ObjectId(user_id),
                "lawyer_id": lawyer_id,
                "password": hash_password(password),
            })
        elif role == 'student':
            matricula = data.get('matricula')
            password = data.get('password')
            if not matricula or not password:
                return jsonify({"error": "Missing matricula or password"}), 400
            result = students_collection.insert_one({
                "user_id": ObjectId(user_id),
                "matricula": matricula,
                "password": hash_password(password),
            })
        else:
            return jsonify({"error": "Invalid role"}), 400

        if result.inserted_id:
            app.logger.info(f"Role details saved for user ID: {user_id}")
            return jsonify({"message": "Role and additional details saved successfully"}), 200
        else:
            app.logger.error(f"Failed to save role details for user ID: {user_id}")
            return jsonify({"error": "Failed to save role details"}), 500

    except Exception as e:
        app.logger.error(f"Error in role assignment: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Login Route
@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        app.logger.info(f"Received login attempt for: {data.get('email_or_phone')}")
        email_or_phone = data.get('email_or_phone')
        password = data.get('password')

        if not email_or_phone or not password:
            return jsonify({"error": "Missing email/phone or password"}), 400

        # Fetch user from the database
        user = users_collection.find_one({"email_or_phone": email_or_phone})

        if user and verify_password(user['password'], password):
            app.logger.info(f"Successful login for user: {email_or_phone}")
            return jsonify({"message": "Login successful", "user_id": str(user['_id'])}), 200
        else:
            app.logger.warning(f"Failed login attempt for user: {email_or_phone}")
            return jsonify({"error": "Invalid credentials"}), 401
    except Exception as e:
        app.logger.error(f"Error in login: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Test Database Connection Route
@app.route('/test_db', methods=['GET'])
def test_db():
    try:
        result = users_collection.insert_one({"test": "data"})
        app.logger.info(f"Test insertion successful. ID: {result.inserted_id}")
        users_collection.delete_one({"_id": result.inserted_id})
        return jsonify({"message": "Database connection and operations successful"}), 200
    except Exception as e:
        app.logger.error(f"Database test failed: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Running the Flask app
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)