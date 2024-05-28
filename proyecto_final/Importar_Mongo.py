import decimal
from pymongo import MongoClient
import mysql.connector
from datetime import datetime, date

# Funcion para convertir Decimal a float y datetime.date a datetime.datetime
def convertir_tipos_de_datos(data):
    if isinstance(data, list):
        return [convertir_tipos_de_datos(item) for item in data]
    elif isinstance(data, dict):
        return {key: convertir_tipos_de_datos(value) for key, value in data.items()}
    elif isinstance(data, decimal.Decimal):
        return float(data)
    elif isinstance(data, date):
        return datetime.combine(data, datetime.min.time())
    else:
        return data

# Funcion para obtener datos de MySQL
def obtener_datos_de_mysql(mysql_conn, tabla):
    cursor = mysql_conn.cursor(dictionary=True)
    cursor.execute(f"SELECT * FROM {tabla}")
    filas = cursor.fetchall()
    cursor.close()
    return filas

# Funcion para migrar la tabla de MySQL a MongoDB
def migrar_tabla(mysql_conn, db, tabla):
    filas = obtener_datos_de_mysql(mysql_conn, tabla)

    # Convertir tipos de datos
    filas = [convertir_tipos_de_datos(row) for row in filas]

    # Insertar en MongoDB
    coleccion = db[tabla]
    coleccion.insert_many(filas)
    print(f"Tabla {tabla} migrada con exito a MongoDB.")

# Funcion para mostrar todas las colecciones y su contenido
def validar_migracion(db):
    colecciones = db.list_collection_names()
    print("Colecciones en la base de datos:")
    for nombre_coleccion in colecciones:
        print(f"- {nombre_coleccion}")
        coleccion = db[nombre_coleccion]
        documentos = coleccion.find()
        print(f"Contenido de la coleccion {nombre_coleccion}:")
        for doc in documentos:
            print(doc)

# Script principal
if __name__ == "__main__":
    # Conexion a MySQL
    mysql_conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Jt299143.',
        database='Metacritics'
    )

    # Conexion a MongoDB
    cliente = MongoClient('mongodb://localhost:27017/')
    db = cliente['Metacritics']

    # Lista de tablas a migrar
    tablas_a_migrar = [
        "Plataforma",
        "Desarrollador",
        "Publicado_por",
        "Genero",
        "Clasificacion_Edad",
        "Tipo_Plataforma",
        "Videojuegos",
        "Tipo_Venta",
        "Ventas",
        "Criticas"
    ]

    # Migracion de cada tabla
    for tabla in tablas_a_migrar:
        migrar_tabla(mysql_conn, db, tabla)

    mysql_conn.close()
    print("Migracion completada.")

    # Validacion de la migracion
    validar_migracion(db)
