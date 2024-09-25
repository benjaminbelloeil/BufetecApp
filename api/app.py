from flask import Flask, request, jsonify
from pymongo import MongoClient
from bson import ObjectId
from flask_pymongo import PyMongo
import bcrypt

app = Flask(__name__)

# MongoDB setup
app.config["MONGO_URI"] = "mongodb://10.14.255.54:27017/BufetecDB"
mongo = PyMongo(app)
users_collection = mongo.db.users
abogados_collection = mongo.db.abogados

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

@app.route("/abogados",methods=['GET'])
def get_all_abogados():
    #Solo los disponibles
    abogados = abogados_collection.find({"disponibilidad": True})
    abogados_list = []
    for item in abogados:
        abogados_dict = {
            "nombre": str(item.get('nombre')),  
            "maestria": item.get('maestria'),
            "casosAsociados": item.get('casos_asignados'),           
        }
        abogados_list.append(abogados_dict)
    return jsonify(abogados_list)

@app.route("/abogado/<abogado_id>",methods=['GET'])
def get_one_abogado(abogado_id):
    try:
        if ObjectId.is_valid(abogado_id):
            abogado = abogados_collection.find_one({'_id': ObjectId(abogado_id)})  # Suponiendo que el user_id es un string
        else:
            return jsonify({'message': "El id proporcionado no es válido"}), 400
        # Convertir el abogado_id a ObjectId si es necesario
        if abogado:
            abogado_dict = {
                "user_id": str(abogado.get("user_id")),  
                "especialidad": abogado.get("especialidad"),
                "experiencia_profesional": abogado.get("experiencia_profesional"),
                "disponibilidad": abogado.get("disponibilidad"),
                "casos_asignados": abogado.get("casos_asignados"),
                "telefono": abogado.get("telefono"),
                "correo": abogado.get("correo"),
                "casos_atendidos":abogado.get("casos_atendidos"),
                "casos_con_sentencia_a_favor":abogado.get("casos_con_sentencia_a_favor"),
                "direccion": {
                    "calle": abogado.get("direccion", {}).get("calle"),
                    "ciudad": abogado.get("direccion", {}).get("ciudad"),
                    "estado": abogado.get("direccion", {}).get("estado"),
                    "codigo_postal": abogado.get("direccion", {}).get("codigo_postal")
                },             
            }
            return jsonify(abogado_dict)  # Agregar jsonify para asegurar que la respuesta sea JSON
        else:
            return jsonify({'message': f"No se encontró el abogado con el id {abogado_id}"}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)