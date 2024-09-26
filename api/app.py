from flask import Flask, request, jsonify
from flask_pymongo import PyMongo #type: ignore
from werkzeug.security import generate_password_hash, check_password_hash
from bson.objectid import ObjectId
from flask_cors import CORS #type: ignore
import logging
import uuid
import datetime
import threading
import time

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# MongoDB configuration
app.config["MONGO_URI"] = "mongodb://localhost:27017/BufetecDB"
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

# Temporary storage for user signup data
temp_users = {} #type: ignore

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
                "contrasena": "abogado123",
                "especializacion": "Derecho Civil",
                "anos_de_experiencia": 10
            },
            {
                "id_abogado": "AB124",
                "nombre": "Juan Pérez",
                "correo": "juan.perez@bufete.com",
                "contrasena": "Abogado124",
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

        nombre = datos.get('nombre')
        correo_o_telefono = datos.get('correo_o_telefono')
        contrasena = datos.get('contrasena')

        if not all([nombre, correo_o_telefono, contrasena]):
            return jsonify({"error": "Faltan campos requeridos"}), 400

        usuario_existente = users_collection.find_one({"correo_o_telefono": correo_o_telefono})
        if usuario_existente:
            return jsonify({"error": "El usuario ya existe"}), 409

        # Generate a temporary user ID
        temp_user_id = str(uuid.uuid4())

        # Store user data temporarily
        temp_users[temp_user_id] = {
            "nombre": nombre,
            "correo_o_telefono": correo_o_telefono,
            "contrasena": contrasena,
            "timestamp": datetime.datetime.utcnow()
        }

        app.logger.info(f"Datos de usuario temporales almacenados con ID: {temp_user_id}")
        return jsonify({"mensaje": "Registro iniciado", "temp_user_id": temp_user_id}), 200

    except Exception as e:
        app.logger.error(f"Error en el registro: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Role Questionnaire Route
@app.route('/role', methods=['POST'])
def role():
    try:
        datos = request.get_json()
        app.logger.info(f"Datos de rol recibidos: {datos}")
        temp_user_id = datos.get('temp_user_id')
        rol = datos.get('rol')

        if not temp_user_id or not rol:
            return jsonify({"error": "Falta temp_user_id o rol"}), 400

        # Retrieve temporary user data
        temp_user_data = temp_users.get(temp_user_id)
        if not temp_user_data:
            return jsonify({"error": "Datos de usuario temporal no encontrados"}), 404

        # Create user in the database
        contrasena_hasheada = hash_password(temp_user_data['contrasena'])
        nuevo_usuario = {
            "nombre": temp_user_data['nombre'],
            "correo_o_telefono": temp_user_data['correo_o_telefono'],
            "contrasena": contrasena_hasheada,
        }
        resultado_usuario = users_collection.insert_one(nuevo_usuario)
        user_id = resultado_usuario.inserted_id

        if rol == 'cliente':
            tipo_caso = datos.get('tipo_caso')
            if not tipo_caso:
                return jsonify({"error": "Falta tipo_caso para el cliente"}), 400
            resultado = clients_collection.insert_one({
                "user_id": user_id,
                "tipo_caso": tipo_caso
            })
        elif rol == 'abogado':
            id_abogado = datos.get('id_abogado')
            contrasena = datos.get('contrasena')
            if not id_abogado or not contrasena:
                return jsonify({"error": "Falta id_abogado o contrasena"}), 400
            
            abogado = lawyers_collection.find_one({"id_abogado": {"$regex": f"^{id_abogado}$", "$options": "i"}})
            if not abogado:
                return jsonify({"error": "Abogado no encontrado"}), 404
            
            if not verify_password(abogado['contrasena'], contrasena):
                return jsonify({"error": "Credenciales de abogado inválidas"}), 401
            
            resultado = lawyers_collection.update_one(
                {"_id": abogado['_id']},
                {"$set": {"user_id": user_id}}
            )
        elif rol == 'estudiante':
            matricula = datos.get('matricula')
            contrasena = datos.get('contrasena')
            if not matricula or not contrasena:
                return jsonify({"error": "Falta matricula o contrasena"}), 400
            
            estudiante = students_collection.find_one({"matricula": matricula})
            if not estudiante:
                return jsonify({"error": "Estudiante no encontrado"}), 404
            if not verify_password(estudiante['contrasena'], contrasena):
                return jsonify({"error": "Credenciales de estudiante inválidas"}), 401
            
            resultado = students_collection.update_one(
                {"matricula": matricula},
                {"$set": {"user_id": user_id}}
            )
        else:
            return jsonify({"error": "Rol inválido"}), 400

        # Remove temporary user data
        del temp_users[temp_user_id]

        app.logger.info(f"Usuario creado y rol asignado para el user ID: {user_id}")
        return jsonify({"mensaje": "Usuario creado y rol asignado exitosamente", "user_id": str(user_id)}), 200

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

# Cleanup function for temporary users
def cleanup_temp_users():
    current_time = datetime.datetime.utcnow()
    expired_users = [uid for uid, data in temp_users.items() 
                     if (current_time - data['timestamp']).total_seconds() > 3600]  # 1 hour expiration
    for uid in expired_users:
        del temp_users[uid]
    app.logger.info(f"Cleaned up {len(expired_users)} expired temporary users")

# Background thread for cleanup
def run_cleanup():
    while True:
        cleanup_temp_users()
        time.sleep(3600)  # Run every hour

@app.route('/biblioteca', methods=['GET'])
def get_all_biblioteca():
    try:
        recursos = mongo.db.biblioteca.find()
        result = []
        for recurso in recursos:
            result.append({
                "id": str(recurso["_id"]),
                "titulo": recurso["titulo"],
                "descripcion": recurso.get("descripcion", ""),
                "tipoRecurso": recurso["tipo_recurso"],
                "categoria": recurso["categoria"],
                "autor": recurso["autor"],
                "fechaCreacion": recurso["fecha_creacion"],
                "urlRecurso": recurso["url_recurso"],
                "portada": recurso.get("portada", ""),
                "status": recurso["status"]
            })
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/biblioteca/<biblioteca_id>', methods=['GET'])
def get_biblioteca_by_id(biblioteca_id):
    try:
        recurso = mongo.db.biblioteca.find_one({"_id": ObjectId(biblioteca_id)})
        if recurso:
            result = {
                "id": str(recurso["_id"]),
                "titulo": recurso["titulo"],
                "descripcion": recurso.get("descripcion", ""),
                "tipoRecurso": recurso["tipo_recurso"],
                "categoria": recurso["categoria"],
                "autor": recurso["autor"],
                "fechaCreacion": recurso["fecha_creacion"],
                "urlRecurso": recurso["url_recurso"],
                "portada": recurso.get("portada", ""),
                "status": recurso["status"]
            }
            return jsonify(result), 200
        else:
            return jsonify({"error": "Recurso no encontrado"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/biblioteca', methods=['POST'])
def create_biblioteca():
    try:
        datos = request.get_json()
        nuevo_recurso = {
            "titulo": datos["titulo"],
            "descripcion": datos.get("descripcion", ""),
            "tipo_recurso": datos["tipo_recurso"],
            "categoria": datos["categoria"],
            "autor": datos["autor"],
            "fecha_creacion": datos.get("fecha_creacion", datetime.datetime.utcnow()),
            "url_recurso": datos["url_recurso"],
            "portada": datos.get("portada", ""),
            "status": datos["status"]
        }
        resultado = mongo.db.biblioteca.insert_one(nuevo_recurso)
        return jsonify({"id": str(resultado.inserted_id)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/documentos', methods=['GET'])
def get_all_documents():
    try:
        documentos = mongo.db.documentos.find()
        result = []
        for documento in documentos:
            result.append({
                "id": str(documento["_id"]),
                "casoId": documento["caso_id"],
                "userId": documento["user_id"],
                "nombreDocumento": documento["nombre_documento"],
                "tipoDocumento": documento["tipo_documento"],
                "urlDocumento": documento["url_documento"],
                "status": documento["status"],
                "createdAt": documento["created_at"]
            })
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/documentos/<user_id>', methods=['GET'])
def get_documents_by_user(user_id):
    try:
        documentos = mongo.db.documentos.find({"user_id": user_id})
        result = []
        for documento in documentos:
            result.append({
                "id": str(documento["_id"]),
                "casoId": documento["caso_id"],
                "userId": documento["user_id"],
                "nombreDocumento": documento["nombre_documento"],
                "tipoDocumento": documento["tipo_documento"],
                "urlDocumento": documento["url_documento"],
                "status": documento["status"],
                "createdAt": documento["fecha_creacion"]
            })
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/documento/<documento_id>', methods=['GET'])
def get_document_by_id(documento_id):
    try:
        documento = mongo.db.documentos.find_one({"_id": ObjectId(documento_id)})
        if documento:
            result = {
                "id": str(documento["_id"]),
                "casoId": documento["casoId"],
                "nombre_documento": documento["nombre_documento"],
                "tipo_documento": documento["tipo_documento"],
                "url_documento": documento["url_documento"],
                "status": documento["status"],
                "fecha_creacion": documento["fecha_creacion"]
            }
            return jsonify(result), 200
        else:
            return jsonify({"error": "Documento no encontrado"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/documento', methods=['POST'])
def create_document():
    try:
        datos = request.get_json()
        nuevo_documento = {
            "casoId": datos["casoId"],
            "nombre_documento": datos["nombre_documento"],
            "tipo_documento": datos["tipo_documento"],
            "url_documento": datos["url_documento"],
            "status": datos["status"],
            "fecha_creacion": datos.get("fecha_creacion", datetime.datetime.utcnow())
        }
        resultado = mongo.db.documentos.insert_one(nuevo_documento)
        return jsonify({"id": str(resultado.inserted_id)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/chats/<user_id>', methods=['GET'])
def get_chats_by_user(user_id):
    try:
        chats = mongo.db.chats.find({"user_id": user_id})
        result = []
        for chat in chats:
            result.append({
                "id": str(chat["_id"]),
                "chat_id": chat["chat_id"],
                "user_id": chat["user_id"],
                "document_id": chat["document_id"],
                "assistant_id": chat["assistant_id"],
                "messages": chat["messages"]
            })
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/chat/<chat_id>', methods=['GET'])
def get_chat_by_id(chat_id):
    try:
        chat = mongo.db.chats.find_one({"_id": ObjectId(chat_id)})
        if chat:
            result = {
                "id": str(chat["_id"]),
                "chat_id": chat["chat_id"],
                "user_id": chat["user_id"],
                "document_id": chat["document_id"],
                "assistant_id": chat["assistant_id"],
                "messages": chat["messages"]
            }
            return jsonify(result), 200
        else:
            return jsonify({"error": "Chat no encontrado"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/chat', methods=['POST'])
def create_chat():
    try:
        datos = request.get_json()
        nuevo_chat = {
            "chat_id": str(uuid.uuid4()),
            "user_id": datos["user_id"],
            "document_id": datos["document_id"],
            "assistant_id": datos["assistant_id"],
            "messages": datos.get("messages", [])
        }
        resultado = mongo.db.chats.insert_one(nuevo_chat)
        return jsonify({"id": str(resultado.inserted_id)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/chat/<chat_id>/messages', methods=['POST'])
def add_message_to_chat(chat_id):
    try:
        datos = request.get_json()
        nuevo_mensaje = {
            "id": str(uuid.uuid4()),
            "sender": datos["sender"],
            "message": datos["message"],
            "timestamp": datetime.datetime.utcnow()
        }
        resultado = mongo.db.chats.update_one(
            {"_id": ObjectId(chat_id)},
            {"$push": {"messages": nuevo_mensaje}}
        )
        if resultado.modified_count > 0:
            return jsonify({"mensaje": "Mensaje agregado correctamente"}), 200
        else:
            return jsonify({"error": "Chat no encontrado"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Running the Flask app
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)