# Imports
from flask import Flask, request, jsonify
from flask_pymongo import PyMongo #type: ignore
from werkzeug.security import generate_password_hash, check_password_hash
from bson.objectid import ObjectId
from flask_cors import CORS #type: ignore
import logging
import uuid
import datetime 
from datetime import timedelta
from pytz import timezone
import re
import threading
import time

# App Configuration
app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.DEBUG)
app.config["MONGO_URI"] = "mongodb://10.14.255.54:27017/BufetecDB"
mongo = PyMongo(app)

# Collections
users_collection = mongo.db.users
lawyer_collection = mongo.db.abogados
students_collection = mongo.db.alumnos
clients_collection = mongo.db.clientes
casos_collection = mongo.db.casos_legales

# Temporary storage
temp_users = {} #type: ignore

# Utility Functions
def hash_password(contrasena):
    return generate_password_hash(contrasena)

def verify_password(contrasena_almacenada, contrasena_proporcionada):
    return check_password_hash(contrasena_almacenada, contrasena_proporcionada)

def insert_student(student_data):
    student_data['contrasena'] = hash_password(student_data['contrasena'])
    student_data['user_id'] = None
    result = students_collection.insert_one(student_data)
    return result.inserted_id

def insert_lawyer(lawyer_data):
    lawyer_data['contrasena'] = hash_password(lawyer_data['contrasena'])
    lawyer_data['user_id'] = None
    result = lawyer_collection.insert_one(lawyer_data)
    return result.inserted_id

def cleanup_temp_users():
    current_time = datetime.datetime.utcnow()
    expired_users = [uid for uid, data in temp_users.items() 
                    if (current_time - data['timestamp']).total_seconds() > 3600]
    for uid in expired_users:
        del temp_users[uid]
    app.logger.info(f"Cleaned up {len(expired_users)} expired temporary users")

def run_cleanup():
    while True:
        cleanup_temp_users()
        time.sleep(3600)

# Sample Data Insertion Functions
def insert_sample_lawyers():
    try:
        # Clear existing lawyers
        print(f"Cleared {result.deleted_count} existing lawyers from the collection.")

        sample_lawyers = [
            {
                "id_abogado": "AB123",
                "abogado_contrasena": hash_password("abogado123"),  # This will be hashed before insertion
                "nombre": "María Rodríguez",
                "especializacion": "Derecho Civil",
                "experiencia_profesional": "15 años en litigios civiles",
                "disponibilidad": True,
                "maestria": "Maestría en Derecho Corporativo",
                "direccion": {
                    "calle": "Av. Revolución 123",
                    "ciudad": "Monterrey",
                    "estado": "Nuevo León",
                    "codigo_postal": "64000"
                },
                "casos_asignados": [],
                "telefono": "8181234567",
                "correo": "maria.rodriguez@bufete.com",
                "casos_atendidos": 120,
                "casos_con_sentencia_a_favor": 95,
            },
            {
                "id_abogado": "AB124",
                "abogado_contrasena": hash_password("abogado124"),  # This will be hashed before insertion
                "nombre": "Juan Pérez",
                "especializacion": "Derecho Penal",
                "experiencia_profesional": "10 años en defensa penal",
                "disponibilidad": True,
                "maestria": "Maestría en Criminología",
                "direccion": {
                    "calle": "Calle Morelos 456",
                    "ciudad": "Guadalajara",
                    "estado": "Jalisco",
                    "codigo_postal": "44100"
                },
                "casos_asignados": [],
                "telefono": "3339876543",
                "correo": "juan.perez@bufete.com",
                "casos_atendidos": 80,
                "casos_con_sentencia_a_favor": 60,
            },
            {
                "id_abogado": "AB125",
                "abogado_contrasena": hash_password("abogado125"),  # This will be hashed before insertion
                "nombre": "Ana López",
                "especializacion": "Derecho Laboral",
                "experiencia_profesional": "12 años en conflictos laborales",
                "disponibilidad": True,
                "maestria": "Maestría en Derecho del Trabajo",
                "direccion": {
                    "calle": "Paseo de la Reforma 789",
                    "ciudad": "Ciudad de México",
                    "estado": "CDMX",
                    "codigo_postal": "06500"
                },
                "casos_asignados": [],
                "telefono": "5551234567",
                "correo": "ana.lopez@bufete.com",
                "casos_atendidos": 150,
                "casos_con_sentencia_a_favor": 130,
            }
        ]
        for lawyer in sample_lawyers:
            result = lawyer_collection.insert_one(lawyer)
            print(f"Inserted lawyer: {lawyer['nombre']} (ID: {result.inserted_id})")

        # Check final count
        final_count = lawyer_collection.count_documents({})
        print(f"Final number of documents in lawyers_collection: {final_count}")

    except Exception as e:
        print(f"Error in insert_sample_lawyers: {str(e)}")
        raise

def insert_sample_clients():
    try:
        # Clear existing clients
        result = clients_collection.delete_many({})
        print(f"Cleared {result.deleted_count} existing clients from the collection.")

        sample_clients = [ ]

        for client in sample_clients:
            result = clients_collection.insert_one(client)
            print(f"Inserted client: {client['nombre']} (ID: {result.inserted_id})")

        # Check final count
        final_count = clients_collection.count_documents({})
        print(f"Final number of documents in client_collection: {final_count}")

    except Exception as e:
        print(f"Error in insert_sample_clients: {str(e)}")
        raise

# Routes
# Authentication Routes
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

@app.route('/role', methods=['POST'])
def role():
    try:
        datos = request.get_json()
        temp_user_id = datos.get('temp_user_id')
        rol = datos.get('rol')

        if not temp_user_id or not rol:
            return jsonify({"error": "Falta temp_user_id o rol"}), 400

        temp_user_data = temp_users.get(temp_user_id)
        if not temp_user_data:
            return jsonify({"error": "Datos de usuario temporal no encontrados"}), 404

        if rol == 'abogado':
            id_abogado = datos.get('id_abogado')
            abogado_contrasena = datos.get('abogado_contrasena')
            
            if not id_abogado or not abogado_contrasena:
                return jsonify({"error": "Falta id_abogado o contraseña"}), 400
            
            # Find lawyer by id_abogado
            abogado = lawyer_collection.find_one({"id_abogado": id_abogado})
            if not abogado:
                return jsonify({"error": "Abogado no encontrado"}), 404
            
            # Verify password
            if not verify_password(abogado['abogado_contrasena'], abogado_contrasena):
                return jsonify({"error": "Credenciales de abogado inválidas"}), 401
            
            # Create new user account
            nuevo_usuario = {
                "nombre": abogado['nombre'],
                "correo_o_telefono": abogado['correo'],
                "contrasena": hash_password(temp_user_data['contrasena']),
            }
            resultado_usuario = users_collection.insert_one(nuevo_usuario)
            user_id = resultado_usuario.inserted_id

            # Update lawyer document with new user_id
            lawyer_collection.update_one(
                {"_id": abogado['_id']},
                {"$set": {"user_id": user_id}}
            )

        elif rol == 'cliente':
            # Handle client role assignment
            nuevo_usuario = {
                "nombre": temp_user_data['nombre'],
                "correo_o_telefono": temp_user_data['correo_o_telefono'],
                "contrasena": hash_password(temp_user_data['contrasena']),
            }
            resultado_usuario = users_collection.insert_one(nuevo_usuario)
            user_id = resultado_usuario.inserted_id

            cliente_data = {
                "user_id": user_id,
                "nombre": temp_user_data['nombre'],
                "caso_tipo": datos.get('tipo_caso'),
                "estado_caso": "Nuevo",
                "contacto": temp_user_data['correo_o_telefono'],
                "fecha_inicio": datetime.now(),
                "proxima_audiencia": None,
                "direccion": {
                    "calle": None,
                    "ciudad": None,
                    "estado": None,
                    "codigo_postal": None
                },
                "telefono": temp_user_data['correo_o_telefono'],
                "correo": temp_user_data['correo_o_telefono']
            }
            clients_collection.insert_one(cliente_data)

        elif rol == 'estudiante':
            # Handle student role assignment
            matricula = datos.get('matricula')
            contrasena = datos.get('contrasena')
            
            if not matricula or not contrasena:
                return jsonify({"error": "Falta matricula o contraseña"}), 400
            
            estudiante = students_collection.find_one({"matricula": matricula})
            if not estudiante:
                return jsonify({"error": "Estudiante no encontrado"}), 404
            
            if not verify_password(estudiante['contrasena'], contrasena):
                return jsonify({"error": "Credenciales de estudiante inválidas"}), 401
            
            nuevo_usuario = {
                "nombre": estudiante['nombre'],
                "correo_o_telefono": estudiante['correo'],
                "contrasena": hash_password(temp_user_data['contrasena']),
            }
            resultado_usuario = users_collection.insert_one(nuevo_usuario)
            user_id = resultado_usuario.inserted_id

            # Update student document with new user_id
            students_collection.update_one(
                {"_id": estudiante['_id']},
                {"$set": {"user_id": user_id}}
            )

        else:
            return jsonify({"error": "Rol inválido"}), 400

        # Remove temporary user data
        del temp_users[temp_user_id]

        return jsonify({
            "mensaje": "Usuario creado y rol asignado exitosamente", 
            "user_id": str(user_id)
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
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

# User Routes
@app.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = users_collection.find_one({"_id": ObjectId(user_id)})
        if not user:
            return jsonify({"error": "User not found"}), 404

        # Check if the user is a client
        client = clients_collection.find_one({"user_id": ObjectId(user_id)})
        if client:
            return jsonify({"rol": "cliente"}), 200

        # Check if the user is a lawyer
        lawyer = lawyer_collection.find_one({"user_id": ObjectId(user_id)})
        if lawyer:
            return jsonify({"rol": "abogado"}), 200

        # Check if the user is a student
        student = students_collection.find_one({"user_id": ObjectId(user_id)})
        if student:
            return jsonify({"rol": "estudiante"}), 200

        return jsonify({"error": "User role not found"}), 404

    except Exception as e:
        app.logger.error(f"Error fetching user data: {str(e)}")
        return jsonify({"error": str(e)}), 500

# Lawyer Routes
@app.route('/abogados', methods=['GET'])
def get_all_abogados():
    try:
        abogados = lawyer_collection.find()
        result = []
        for abogado in abogados:
            result.append({
                "id": str(abogado["_id"]),
                "userId": str(abogado.get("user_id", "")),
                "nombre": abogado.get("nombre", ""),
                "especializacion": abogado.get("especializacion", abogado.get("especialidad", "")),
                "experiencia_profesional": abogado.get("experiencia_profesional", ""),
                "disponibilidad": abogado.get("disponibilidad", True),
                "maestria": abogado.get("maestria", ""),
                "direccion": {
                    "calle": abogado.get("direccion", {}).get("calle", ""),
                    "ciudad": abogado.get("direccion", {}).get("ciudad", ""),
                    "estado": abogado.get("direccion", {}).get("estado", ""),
                    "codigo_postal": abogado.get("direccion", {}).get("codigo_postal", "")
                },
                "casos_asignados": abogado.get("casos_asignados", []),
                "telefono": abogado.get("telefono", ""),
                "correo": abogado.get("correo", ""),
                "casos_atendidos": abogado.get("casos_atendidos", 0),
                "casos_con_sentencia_a_favor": abogado.get("casos_con_sentencia_a_favor", 0),
                "url_recurso": abogado.get("url_recurso", "")
            })
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/abogado/<abogado_id>", methods=['GET'])
def get_one_abogado(abogado_id):
    try:
        if ObjectId.is_valid(abogado_id):
            abogado = lawyer_collection.find_one({'_id': ObjectId(abogado_id)})
        else:
            return jsonify({'message': "El id proporcionado no es válido"}), 400
        if abogado:
            abogado_dict = {
                "userId": str(abogado.get("user_id", "")),
                "nombre": abogado.get("nombre", ""),
                "especializacion": abogado.get("especializacion", abogado.get("especialidad", "")),
                "especialidad": abogado.get("especialidad", ""),
                "experienciaProfesional": abogado.get("experiencia_profesional", ""),
                "experiencia_profesional": abogado.get("experiencia_profesional", ""),
                "disponibilidad": abogado.get("disponibilidad", ""),
                "maestria": abogado.get("maestria", ""),
                "direccion": {
                    "calle": abogado.get("direccion", {}).get("calle", ""),
                    "ciudad": abogado.get("direccion", {}).get("ciudad", ""),
                    "estado": abogado.get("direccion", {}).get("estado", ""),
                    "codigo_postal": abogado.get("direccion", {}).get("codigo_postal", "")
                },
                "casos_asignados": abogado.get("casos_asignados", ""),
                "telefono": abogado.get("telefono", ""),
                "correo": abogado.get("correo", ""),
                "casos_atendidos": abogado.get("casos_atendidos", ""),
                "casos_con_sentencia_a_favor": abogado.get("casos_con_sentencia_a_favor", ""),
                "imageName": "abogado_placeholder"
            }
            return jsonify(abogado_dict), 200
        else:
            return jsonify({'message': f"No se encontró el abogado con el id {abogado_id}"}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@app.route('/insert_sample_lawyers', methods=['GET'])
def insert_sample_lawyers_route():
    insert_sample_lawyers()
    return jsonify({"message": "Sample lawyers inserted successfully"}), 200

# Client Routes
@app.route('/clientes', methods=['GET'])
def get_all_clientes():
    try:
        clientes = clients_collection.find()
        result = []
        for cliente in clientes:
            result.append({
                "id": str(cliente["_id"]),
                "nombre": cliente["nombre"],
                "caso_tipo": cliente["caso_tipo"],
                "estado_caso": cliente["estado_caso"],
                "contacto": cliente["contacto"],
                "fecha_inicio": cliente["fecha_inicio"],
                "proxima_audiencia": cliente["proxima_audiencia"],
                "direccion": cliente["direccion"],
                "telefono": cliente["telefono"],
                "correo": cliente["correo"]
            })
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/insert_sample_clients', methods=['GET'])
def insert_sample_clients_route():
    insert_sample_clients()
    return jsonify({"message": "Sample clients inserted successfully"}), 200

# Library Routes
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

# Document Routes
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

# Chat Routes
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

#urls
def es_url_valida(url):
    # Expresión regular para verificar el formato de una URL
    regex = re.compile(
        r'^(?:http|ftp)s?://' # Esquema (http, https, ftp)
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' # Dominio
        r'localhost|' # Localhost
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|' # IP
        r'\[?[A-F0-9]*:[A-F0-9:]+\]?)' # IPv6
        r'(?::\d+)?' # Puerto
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)

    return re.match(regex, url) is not None

@app.route("/abogadoSelect",methods=['GET'])
#Solo los disponibles
def abogadosSelect():
    abogados = lawyer_collection.find({"disponibilidad": True})
    abogados_list = []
    for item in abogados:
        abogados_dict = {
            "nombre": str(item.get('nombre')),     
        }
        abogados_list.append(abogados_dict)
    return jsonify(abogados_list)

@app.route("/clienteSelect",methods=['GET'])
#Solo los disponibles
def clientesSelect():
    clientes = clients_collection.find({"disponibilidad": True})
    clientes_list = []
    for item in clientes:
        clientes_dict = {
            "nombre": str(item.get('nombre')),     
        }
        clientes_list.append(clientes_dict)
    return jsonify(clientes_list)

@app.route("/nuevoCaso", methods=['POST'])
def nuevo_caso():
    nombreCaso = request.json['nombre_caso']
    nExpediente = request.json['numero_expediente']
    tipo_proceso = request.json['tipo_proceso']
    estado_proceso = request.json['estado_proceso']
    prioridad = request.json['prioridad']
    #obtener objetos con su id
    cliente_id = request.json['cliente_id']
    abogado_id = request.json['abogado_id']
    documentos = request.json.get('documentos',[])
    responsable = request.json.get('responsable',[])
    
    for doc in documentos:
        if not es_url_valida(doc['url']):
            return {'message': f'Documento inválido: {doc}. Se esperaba una URL válida.'}, 400

    if cliente_id == None:
        return {'message':'Es necesario asignar un clinte'}
    elif abogado_id == None:
        return {'message':'Es necesario asignar un abogado'}
    
    # Verificar que el cliente_id sea válido
    try:
        cliente_id_obj = ObjectId(cliente_id)  # Convertir el cliente_id a ObjectId
    except:
        return {'message': 'cliente_id no válido'}, 400
    
    #busco si existe
    cliente = clients_collection.find_one({'_id':cliente_id_obj})
    if not cliente:
        return {'message': 'Cliente no encontrado'}, 404
    
    try:
        abogado_id_obj = ObjectId(abogado_id)
    except:
        return {'message': 'abogado no valido'}, 400
    
    #Buscar si existe
    abogado = lawyer_collection.find_one({'_id':abogado_id_obj})
    if not abogado:
        return {'message':'abogado no valido'},400
    
    #current time in Monterrey time zone
    monterrey_tz = timezone('America/Monterrey')
    created_at = datetime.now(monterrey_tz)
    adjusted_time = created_at - timedelta(hours=6)
    # Nuevo Caso
    nuevo_caso_data = {
        'nombre_caso': nombreCaso,
        'numero_expediente': nExpediente,
        'tipo_proceso': tipo_proceso,
        'estado_proceso': estado_proceso,
        'prioridad': prioridad,
        'cliente_id': cliente_id_obj,
        'abogado_id': abogado_id_obj,
        'created_at': adjusted_time,  
        'documentos': documentos,
        'responsable':responsable,
    }
    case_id = casos_collection.insert_one(nuevo_caso_data).inserted_id
    lawyer_collection.update_one(
        {'_id': abogado_id_obj},
        {'$push': {'casos_asignados': case_id}}  # Agregar el ID del nuevo caso al campo casos_asignados
    )
    return {'message': 'Nuevo caso creado', 'case_id': str(case_id)}, 201


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

# Test Routes
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

# Main execution block
if __name__ == '__main__':
    try:
        # Test MongoDB connection
        mongo.db.command('ping')
        app.logger.info("Conexión a MongoDB exitosa")
    except Exception as e:
        app.logger.error(f"Fallo en la conexión a MongoDB: {str(e)}")

    # Insert sample lawyers
    insert_sample_lawyers()

    # Start the cleanup thread
    cleanup_thread = threading.Thread(target=run_cleanup)
    cleanup_thread.start()

    # Run the Flask app
    app.run(debug=True, host='0.0.0.0', port=5001)