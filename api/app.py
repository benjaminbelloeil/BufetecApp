from flask import Flask, request, jsonify
from pymongo import MongoClient
from bson import ObjectId
from flask_pymongo import PyMongo
import bcrypt
from datetime import datetime, timedelta
from pytz import timezone
import pytz
import re
from bson import ObjectId  # Importar para convertir a ObjectId

app = Flask(__name__)

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

# MongoDB setup
app.config["MONGO_URI"] = "mongodb://10.14.255.54:27017/BufetecDB"
mongo = PyMongo(app)
clientes_collection = mongo.db.clientes
users_collection = mongo.db.users
abogados_collection = mongo.db.abogados
casos_collection = mongo.db.casos_legales

@app.route("/abogadoSelect",methods=['GET'])
#Solo los disponibles
def abogadosSelect():
    abogados = abogados_collection.find({"disponibilidad": True})
    abogados_list = []
    for item in abogados:
        abogados_dict = {
            "nombre": str(item.get('nombre')),     
        }
        abogados_list.append(abogados_dict)
    return jsonify(abogados_list)

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
    cliente = clientes_collection.find_one({'_id':cliente_id_obj})
    if not cliente:
        return {'message': 'Cliente no encontrado'}, 404
    
    try:
        abogado_id_obj = ObjectId(abogado_id)
    except:
        return {'message': 'abogado no valido'}, 400
    
    #Buscar si existe
    abogado = abogados_collection.find_one({'_id':abogado_id_obj})
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
    abogados_collection.update_one(
        {'_id': abogado_id_obj},
        {'$push': {'casos_asignados': case_id}}  # Agregar el ID del nuevo caso al campo casos_asignados
    )
    
    return {'message': 'Nuevo caso creado', 'case_id': str(case_id)}, 201
     
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