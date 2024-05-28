import decimal
from pymongo import MongoClient
import mysql.connector
from datetime import datetime, date

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

def obtener_datos_de_mysql(mysql_conn, tabla):
    cursor = mysql_conn.cursor(dictionary=True)
    cursor.execute(f"SELECT * FROM {tabla}")
    filas = cursor.fetchall()
    cursor.close()
    return filas

def migrar_tabla(mysql_conn, db, tabla):
    filas = obtener_datos_de_mysql(mysql_conn, tabla)

    filas = [convertir_tipos_de_datos(row) for row in filas]

    coleccion = db[tabla]
    coleccion.insert_many(filas)
    print(f"Tabla {tabla} migrada con exito a MongoDB.")

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

if __name__ == "__main__":
    mysql_conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Jt299143.',
        database='Metacritics'
    )

    cliente = MongoClient('mongodb://localhost:27017/')
    db = cliente['Metacritics']

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

    for tabla in tablas_a_migrar:
        migrar_tabla(mysql_conn, db, tabla)

    mysql_conn.close()
    print("Migracion completada.")

    validar_migracion(db)
