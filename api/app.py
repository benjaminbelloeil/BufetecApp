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
    app.logger.info("Conexión a MongoDB exitosa")
except Exception as e:
    app.logger.error(f"Fallo en la conexión a MongoDB: {str(e)}")

# Collections
users_collection = mongo.db.users
lawyers_collection = mongo.db.abogados
students_collection = mongo.db.alumnos
clients_collection = mongo.db.clientes

# Password hashing utility
def hash_password(contrasena):
    return generate_password_hash(contrasena)

def verify_password(contrasena_almacenada, contrasena_proporcionada):
    return check_password_hash(contrasena_almacenada, contrasena_proporcionada)

# Function to insert student data
def insert_student(student_data):
    student_data['contrasena'] = hash_password(student_data['contrasena'])
    student_data['user_id'] = None  # Initialize user_id as None
    result = students_collection.insert_one(student_data)
    return result.inserted_id

# Function to insert lawyer data
def insert_lawyer(lawyer_data):
    lawyer_data['contrasena'] = hash_password(lawyer_data['contrasena'])
    lawyer_data['user_id'] = None  # Initialize user_id as None
    result = lawyers_collection.insert_one(lawyer_data)
    return result.inserted_id

# Function to insert sample data
def insert_sample_data():
    try:
        # Sample student data
        estudiantes = [
            {
                "matricula": "A00838158",
                "nombre": "Benjamin Belloeil",
                "correo": "A00838158@tec.mx",
                "contrasena": "Benjamin2017",
                "ano_de_estudio": 3,
                "carrera": "ITC"
            }    
        ]

        # Sample lawyer data
        abogados = [
            {
                "id_abogado": "AB123",
                "nombre": "María Rodríguez",
                "correo": "maria.rodriguez@bufete.com",
                "contrasena": "abogado",
                "especializacion": "Derecho Civil",
                "anos_de_experiencia": 10
            },
            {
                "id_abogado": "AB124",
                "nombre": "Juan Pérez",
                "correo": "juan.perez@bufete.com",
                "contrasena": "abogado",
                "especializacion": "Derecho Penal",
                "anos_de_experiencia": 15
            }
        ]

        # Insert students
        for estudiante in estudiantes:
            if students_collection.count_documents({"matricula": estudiante["matricula"]}) == 0:
                insert_student(estudiante)
                app.logger.info(f"Sample student data inserted: {estudiante['nombre']}")
            else:
                app.logger.info(f"Student already exists: {estudiante['nombre']}")

        # Insert lawyers
        for abogado in abogados:
            if lawyers_collection.count_documents({"id_abogado": abogado["id_abogado"]}) == 0:
                insert_lawyer(abogado)
                app.logger.info(f"Sample lawyer data inserted: {abogado['nombre']}")
            else:
                app.logger.info(f"Lawyer already exists: {abogado['nombre']}")

    except Exception as e:
        app.logger.error(f"Error inserting sample data: {str(e)}")

# Sign-Up Route
@app.route('/signup', methods=['POST'])
def signup():
    try:
        datos = request.get_json()
        app.logger.info(f"Datos de registro recibidos: {datos}")

        # Extract sign-up details
        nombre = datos.get('nombre')
        correo_o_telefono = datos.get('correo_o_telefono')
        contrasena = datos.get('contrasena')

        # Validate input
        if not all([nombre, correo_o_telefono, contrasena]):
            return jsonify({"error": "Faltan campos requeridos"}), 400

        # Check if user already exists
        usuario_existente = users_collection.find_one({"correo_o_telefono": correo_o_telefono})
        if usuario_existente:
            return jsonify({"error": "El usuario ya existe"}), 409

        # Hash password
        contrasena_hasheada = hash_password(contrasena)

        # Insert into users collection
        nuevo_usuario = {
            "nombre": nombre,
            "correo_o_telefono": correo_o_telefono,
            "contrasena": contrasena_hasheada,
        }
        resultado = users_collection.insert_one(nuevo_usuario)
        
        if resultado.inserted_id:
            app.logger.info(f"Usuario creado con ID: {resultado.inserted_id}")
            return jsonify({"mensaje": "Registro exitoso", "user_id": str(resultado.inserted_id)}), 201
        else:
            app.logger.error("Fallo al insertar usuario en la base de datos")
            return jsonify({"error": "Fallo al crear usuario"}), 500

    except Exception as e:
        app.logger.error(f"Error en el registro: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Role Questionnaire Route
@app.route('/role', methods=['POST'])
def role():
    try:
        datos = request.get_json()
        app.logger.info(f"Datos de rol recibidos: {datos}")
        user_id = datos.get('user_id')
        rol = datos.get('rol')

        if not user_id or not rol:
            return jsonify({"error": "Falta user_id o rol"}), 400

        if rol == 'cliente':
            tipo_caso = datos.get('tipo_caso')
            if not tipo_caso:
                return jsonify({"error": "Falta tipo_caso para el cliente"}), 400
            resultado = clients_collection.insert_one({
                "user_id": ObjectId(user_id),
                "tipo_caso": tipo_caso
            })
        elif rol == 'abogado':
            id_abogado = datos.get('id_abogado')
            contrasena = datos.get('contrasena')
            if not id_abogado or not contrasena:
                return jsonify({"error": "Falta id_abogado o contrasena"}), 400
            
            # Verify lawyer credentials
            abogado = lawyers_collection.find_one({"id_abogado": id_abogado})
            if not abogado:
                return jsonify({"error": "Abogado no encontrado"}), 404
            if not verify_password(abogado['contrasena'], contrasena):
                return jsonify({"error": "Credenciales de abogado inválidas"}), 401
            
            # Link user account to lawyer credentials
            resultado = lawyers_collection.update_one(
                {"id_abogado": id_abogado},
                {"$set": {"user_id": ObjectId(user_id)}}
            )
        elif rol == 'estudiante':
            matricula = datos.get('matricula')
            contrasena = datos.get('contrasena')
            if not matricula or not contrasena:
                return jsonify({"error": "Falta matricula o contrasena"}), 400
            
            # Verify student credentials
            estudiante = students_collection.find_one({"matricula": matricula})
            if not estudiante:
                return jsonify({"error": "Estudiante no encontrado"}), 404
            if not verify_password(estudiante['contrasena'], contrasena):
                return jsonify({"error": "Credenciales de estudiante inválidas"}), 401
            
            # Link user account to student credentials
            resultado = students_collection.update_one(
                {"matricula": matricula},
                {"$set": {"user_id": ObjectId(user_id)}}
            )
        else:
            return jsonify({"error": "Rol inválido"}), 400

        if resultado.modified_count > 0 or (rol == 'cliente' and resultado.inserted_id):
            app.logger.info(f"Detalles del rol guardados para el user ID: {user_id}")
            return jsonify({"mensaje": "Rol y detalles adicionales guardados exitosamente"}), 200
        else:
            app.logger.error(f"Fallo al guardar detalles del rol para el user ID: {user_id}")
            return jsonify({"error": "Fallo al guardar detalles del rol"}), 500

    except Exception as e:
        app.logger.error(f"Error en la asignación de rol: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Login Route
@app.route('/login', methods=['POST'])
def login():
    try:
        datos = request.get_json()
        app.logger.info(f"Intento de inicio de sesión recibido para: {datos.get('correo_o_telefono')}")
        correo_o_telefono = datos.get('correo_o_telefono')
        contrasena = datos.get('contrasena')

        if not correo_o_telefono or not contrasena:
            return jsonify({"error": "Falta correo/teléfono o contrasena"}), 400

        # Fetch user from the database
        usuario = users_collection.find_one({"correo_o_telefono": correo_o_telefono})

        if usuario and verify_password(usuario['contrasena'], contrasena):
            app.logger.info(f"Inicio de sesión exitoso para el usuario: {correo_o_telefono}")
            return jsonify({"mensaje": "Inicio de sesión exitoso", "user_id": str(usuario['_id'])}), 200
        else:
            app.logger.warning(f"Intento de inicio de sesión fallido para el usuario: {correo_o_telefono}")
            return jsonify({"error": "Credenciales inválidas"}), 401
    except Exception as e:
        app.logger.error(f"Error en el inicio de sesión: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Test Database Connection Route
@app.route('/test_db', methods=['GET'])
def test_db():
    try:
        resultado = users_collection.insert_one({"test": "datos"})
        app.logger.info(f"Inserción de prueba exitosa. ID: {resultado.inserted_id}")
        users_collection.delete_one({"_id": resultado.inserted_id})
        return jsonify({"mensaje": "Conexión a la base de datos y operaciones exitosas"}), 200
    except Exception as e:
        app.logger.error(f"Prueba de base de datos fallida: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Running the Flask app
if __name__ == '__main__':
    insert_sample_data()  # Insert sample data when the app starts
    app.run(debug=True, host='0.0.0.0', port=5001)