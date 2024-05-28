drop database if exists Metacritics;
create database Metacritics;
use Metacritics;


CREATE ROLE usuario;
CREATE ROLE administrador;
CREATE ROLE critico;


-- Asignar permisos a los roles
GRANT SELECT ON Metacritics.* TO usuario;
GRANT INSERT, UPDATE, DELETE ON Metacritics.* TO administrador;
GRANT SELECT, INSERT, UPDATE ON Metacritics.* TO critico;


CREATE TABLE Plataforma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) UNIQUE
);

CREATE TABLE Desarrollador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) UNIQUE
);

CREATE TABLE Publicado_por (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) UNIQUE
);

CREATE TABLE Genero (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) UNIQUE
);

CREATE TABLE Clasificacion_Edad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) UNIQUE
);

CREATE TABLE Tipo_Plataforma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(255) UNIQUE
);

CREATE TABLE Videojuegos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255),
    Fecha_Lanzamiento varchar(100),
    Meta_Score INT,
    Catalogado_por_Meta VARCHAR(255),
    User_Score DECIMAL(3, 1),
    Catalogado_por_Usuario VARCHAR(255),
    Plataforma_ID INT,
    Desarrollador_ID INT,
    Publicado_por_ID INT,
    Genero_ID INT,
    Clasificacion_Edad_ID INT,
    Tipo_Plataforma_ID INT,
    FOREIGN KEY (Plataforma_ID) REFERENCES Plataforma(id) ON DELETE SET NULL,
    FOREIGN KEY (Desarrollador_ID) REFERENCES Desarrollador(id) ON DELETE SET NULL,
    FOREIGN KEY (Publicado_por_ID) REFERENCES Publicado_por(id) ON DELETE SET NULL,
    FOREIGN KEY (Genero_ID) REFERENCES Genero(id) ON DELETE SET NULL,
    FOREIGN KEY (Clasificacion_Edad_ID) REFERENCES Clasificacion_Edad(id) ON DELETE SET NULL,
    FOREIGN KEY (Tipo_Plataforma_ID) REFERENCES Tipo_Plataforma(id) ON DELETE SET NULL
);

CREATE TABLE Tipo_Venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(255) UNIQUE
);

CREATE TABLE Ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Videojuego_ID INT,
    Tipo_Venta_ID INT,
    Fecha DATE,
    Cantidad INT,
    Precio DECIMAL(10, 2),
    FOREIGN KEY (Videojuego_ID) REFERENCES Videojuegos(id) ON DELETE SET NULL,
    FOREIGN KEY (Tipo_Venta_ID) REFERENCES Tipo_Venta(id) ON DELETE SET NULL
);

CREATE TABLE Criticas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    videojuego_id INT,
    critica_calidad_precio ENUM('Buena', 'Mala'),
    FOREIGN KEY (videojuego_id) REFERENCES Videojuegos(id)
);

CREATE TABLE Registro_Operaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Tabla VARCHAR(255),
    Operacion VARCHAR(50),
    Detalles TEXT,
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Procedimientos para la tabla Plataforma
DELIMITER //
CREATE PROCEDURE CrearPlataforma(IN platform_name VARCHAR(255))
BEGIN
    INSERT INTO Plataforma (Nombre) VALUES (platform_name);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllPlataformas()
BEGIN
    SELECT * FROM Plataforma;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdPlataforma(IN platform_id INT)
BEGIN
    SELECT * FROM Plataforma WHERE id = platform_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdPlataforma(IN platform_id INT, IN platform_name VARCHAR(255))
BEGIN
    UPDATE Plataforma SET Nombre = platform_name WHERE id = platform_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllPlataformas()
BEGIN
    DELETE FROM Plataforma;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdPlataforma(IN platform_id INT)
BEGIN
    DELETE FROM Plataforma WHERE id = platform_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Desarrollador
DELIMITER //
CREATE PROCEDURE CrearDesarrollador(IN developer_name VARCHAR(255))
BEGIN
    INSERT INTO Desarrollador (Nombre) VALUES (developer_name);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllDesarrolladores()
BEGIN
    SELECT * FROM Desarrollador;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdDesarrollador(IN developer_id INT)
BEGIN
    SELECT * FROM Desarrollador WHERE id = developer_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdDesarrollador(IN developer_id INT, IN developer_name VARCHAR(255))
BEGIN
    UPDATE Desarrollador SET Nombre = developer_name WHERE id = developer_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdDesarrollador(IN developer_id INT)
BEGIN
    DELETE FROM Desarrollador WHERE id = developer_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllDesarrolladores()
BEGIN
    DELETE FROM Desarrollador;
END //
DELIMITER ;

-- Procedimientos para la tabla Publicado_por
DELIMITER //
CREATE PROCEDURE CrearPublicadoPor(IN publisher_name VARCHAR(255))
BEGIN
    INSERT INTO Publicado_por (Nombre) VALUES (publisher_name);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllPublicadoPor()
BEGIN
    SELECT * FROM Publicado_por;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdPublicadoPor(IN publisher_id INT)
BEGIN
    SELECT * FROM Publicado_por WHERE id = publisher_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdPublicadoPor(IN publisher_id INT, IN publisher_name VARCHAR(255))
BEGIN
    UPDATE Publicado_por SET Nombre = publisher_name WHERE id = publisher_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllPublicadoPor()
BEGIN
    DELETE FROM Publicado_por;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdPublicadoPor(IN publisher_id INT)
BEGIN
    DELETE FROM Publicado_por WHERE id = publisher_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Genero
DELIMITER //
CREATE PROCEDURE CrearGenero(IN genre_name VARCHAR(255))
BEGIN
    INSERT INTO Genero (Nombre) VALUES (genre_name);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllGeneros()
BEGIN
    SELECT * FROM Genero;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdGenero(IN genre_id INT)
BEGIN
    SELECT * FROM Genero WHERE id = genre_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdGenero(IN genre_id INT, IN genre_name VARCHAR(255))
BEGIN
    UPDATE Genero SET Nombre = genre_name WHERE id = genre_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllGeneros()
BEGIN
    DELETE FROM Genero;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteGeneroById(IN genre_id INT)
BEGIN
    DELETE FROM Genero WHERE id = genre_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Clasificacion_Edad
DELIMITER //
CREATE PROCEDURE CrearClasificacionEdad(IN edad_nombre VARCHAR(255))
BEGIN
    INSERT INTO Clasificacion_Edad (Nombre) VALUES (edad_nombre);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllClasificacionEdad()
BEGIN
    SELECT * FROM Clasificacion_Edad;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetClasificacionEdadById(IN edad_id INT)
BEGIN
    SELECT * FROM Clasificacion_Edad WHERE id = edad_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdClasificacionEdad(IN edad_id INT, IN edad_nombre VARCHAR(255))
BEGIN
    UPDATE Clasificacion_Edad SET Nombre = edad_nombre WHERE id = edad_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllClasificacionEdad()
BEGIN
    DELETE FROM Clasificacion_Edad;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdClasificacionEdad(IN edad_id INT)
BEGIN
    DELETE FROM Clasificacion_Edad WHERE id = edad_id;
END //
DELIMITER ;


-- Procedimientos para la tabla Tipo_Plataforma
DELIMITER //
CREATE PROCEDURE CrearTipoPlataforma(IN tipo_nombre VARCHAR(255))
BEGIN
    INSERT INTO Tipo_Plataforma (Tipo) VALUES (tipo_nombre);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllTipoPlataforma()
BEGIN
    SELECT * FROM Tipo_Plataforma;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetTipoPlataformaById(IN tipo_id INT)
BEGIN
    SELECT * FROM Tipo_Plataforma WHERE id = tipo_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdTipoPlataforma(IN tipo_id INT, IN tipo_nombre VARCHAR(255))
BEGIN
    UPDATE Tipo_Plataforma SET Tipo = tipo_nombre WHERE id = tipo_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllTipoPlataforma()
BEGIN
    DELETE FROM Tipo_Plataforma;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdTipoPlataforma(IN tipo_id INT)
BEGIN
    DELETE FROM Tipo_Plataforma WHERE id = tipo_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Videojuegos
DELIMITER //
CREATE PROCEDURE CrearVideojuego(
    IN game_name VARCHAR(255),
    IN release_date VARCHAR(100),
    IN meta_score INT,
    IN rated_by_meta VARCHAR(255),
    IN user_score DECIMAL(3, 1),
    IN rated_by_user VARCHAR(255),
    IN platform_id INT,
    IN developer_id INT,
    IN publisher_id INT,
    IN genre_id INT,
    IN clasificacion_edad_id INT,
    IN tipo_plataforma_id INT
)
BEGIN
    INSERT INTO Videojuegos (
        Nombre, Fecha_Lanzamiento, Meta_Score, Catalogado_por_Meta, 
        User_Score, Catalogado_por_Usuario, Plataforma_ID, Desarrollador_ID, 
        Publicado_por_ID, Genero_ID, Clasificacion_Edad_ID, Tipo_Plataforma_ID
    ) VALUES (
        game_name, release_date, meta_score, rated_by_meta, 
        user_score, rated_by_user, platform_id, developer_id, 
        publisher_id, genre_id, clasificacion_edad_id, tipo_plataforma_id
    );
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllVideojuegos()
BEGIN
    SELECT * FROM Videojuegos;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetVideojuegoById(IN game_id INT)
BEGIN
    SELECT * FROM Videojuegos WHERE id = game_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdVideojuego(
    IN game_id INT,
    IN game_name VARCHAR(255),
    IN release_date VARCHAR(100),
    IN meta_score INT,
    IN rated_by_meta VARCHAR(255),
    IN user_score DECIMAL(3, 1),
    IN rated_by_user VARCHAR(255),
    IN platform_id INT,
    IN developer_id INT,
    IN publisher_id INT,
    IN genre_id INT,
    IN clasificacion_edad_id INT,
    IN tipo_plataforma_id INT
)
BEGIN
    UPDATE Videojuegos
    SET 
        Nombre = game_name,
        Fecha_Lanzamiento = release_date,
        Meta_Score = meta_score,
        Catalogado_por_Meta = rated_by_meta,
        User_Score = user_score,
        Catalogado_por_Usuario = rated_by_user,
        Plataforma_ID = platform_id,
        Desarrollador_ID = developer_id,
        Publicado_por_ID = publisher_id,
        Genero_ID = genre_id,
        Clasificacion_Edad_ID = clasificacion_edad_id,
        Tipo_Plataforma_ID = tipo_plataforma_id
    WHERE id = game_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllVideojuegos()
BEGIN
    DELETE FROM Videojuegos;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdVideojuego(IN game_id INT)
BEGIN
    DELETE FROM Videojuegos WHERE id = game_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Tipo_Venta
DELIMITER //
CREATE PROCEDURE CrearTipoVenta(IN sale_type VARCHAR(255))
BEGIN
    INSERT INTO Tipo_Venta (Tipo) VALUES (sale_type);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllTiposVenta()
BEGIN
    SELECT * FROM Tipo_Venta;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdTipoVenta(IN sale_type_id INT)
BEGIN
    SELECT * FROM Tipo_Venta WHERE id = sale_type_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdTipoVenta(IN sale_type_id INT, IN sale_type VARCHAR(255))
BEGIN
    UPDATE Tipo_Venta SET Tipo = sale_type WHERE id = sale_type_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllTiposVenta()
BEGIN
    DELETE FROM Tipo_Venta;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdTipoVenta(IN sale_type_id INT)
BEGIN
    DELETE FROM Tipo_Venta WHERE id = sale_type_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Ventas
DELIMITER //
CREATE PROCEDURE CrearVenta(
    IN videojuego_id INT, IN tipo_venta_id INT, IN fecha DATE, 
    IN cantidad INT, IN precio DECIMAL(10, 2))
BEGIN
    INSERT INTO Ventas (Videojuego_ID, Tipo_Venta_ID, Fecha, Cantidad, Precio) 
    VALUES (videojuego_id, tipo_venta_id, fecha, cantidad, precio);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllVentas()
BEGIN
    SELECT * FROM Ventas;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdVenta(IN venta_id INT)
BEGIN
    SELECT * FROM Ventas WHERE id = venta_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdVenta(
    IN venta_id INT, IN videojuego_id INT, IN tipo_venta_id INT, 
    IN fecha DATE, IN cantidad INT, IN precio DECIMAL(10, 2))
BEGIN
    UPDATE Ventas 
    SET Videojuego_ID = videojuego_id, Tipo_Venta_ID = tipo_venta_id, 
        Fecha = fecha, Cantidad = cantidad, Precio = precio 
    WHERE id = venta_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllVentas()
BEGIN
    DELETE FROM Ventas;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdVenta(IN venta_id INT)
BEGIN
    DELETE FROM Ventas WHERE id = venta_id;
END //
DELIMITER ;

-- Procedimientos para la tabla Criticas
DELIMITER //
CREATE PROCEDURE CrearCritica(IN videojuego_id INT, IN critica_calidad_precio ENUM('Buena', 'Mala'))
BEGIN
    INSERT INTO Criticas (videojuego_id, critica_calidad_precio) VALUES (videojuego_id, critica_calidad_precio);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAllCriticas()
BEGIN
    SELECT * FROM Criticas;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetByIdCritica(IN critica_id INT)
BEGIN
    SELECT * FROM Criticas WHERE id = critica_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateByIdCritica(IN critica_id INT, IN videojuego_id INT, IN critica_calidad_precio ENUM('Buena', 'Mala'))
BEGIN
    UPDATE Criticas SET videojuego_id = videojuego_id, critica_calidad_precio = critica_calidad_precio WHERE id = critica_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAllCriticas()
BEGIN
    DELETE FROM Criticas;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteByIdCritica(IN critica_id INT)
BEGIN
    DELETE FROM Criticas WHERE id = critica_id;
END //
DELIMITER ;

-- Trigger para la tabla Plataforma
DELIMITER //
CREATE TRIGGER Plataforma_Insert_Trigger
AFTER INSERT ON Plataforma
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Plataforma', 'Insert', CONCAT('Se inserto la plataforma con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Plataforma_Update_Trigger
AFTER UPDATE ON Plataforma
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Plataforma', 'Update', CONCAT('Se actualizo la plataforma con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Plataforma_Delete_Trigger
AFTER DELETE ON Plataforma
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Plataforma', 'Delete', CONCAT('Se elimino la plataforma con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Desarrollador
DELIMITER //
CREATE TRIGGER Desarrollador_Insert_Trigger
AFTER INSERT ON Desarrollador
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Desarrollador', 'Insert', CONCAT('Se inserto el desarrollador con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Desarrollador_Update_Trigger
AFTER UPDATE ON Desarrollador
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Desarrollador', 'Update', CONCAT('Se actualizo el desarrollador con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Desarrollador_Delete_Trigger
AFTER DELETE ON Desarrollador
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Desarrollador', 'Delete', CONCAT('Se elimino el desarrollador con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Publicado_por
DELIMITER //
CREATE TRIGGER PublicadoPor_Insert_Trigger
AFTER INSERT ON Publicado_por
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Publicado_por', 'Insert', CONCAT('Se inserto el publicador con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER PublicadoPor_Update_Trigger
AFTER UPDATE ON Publicado_por
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Publicado_por', 'Update', CONCAT('Se actualizo el publicador con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER PublicadoPor_Delete_Trigger
AFTER DELETE ON Publicado_por
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Publicado_por', 'Delete', CONCAT('Se elimino el publicador con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Genero
DELIMITER //
CREATE TRIGGER Genero_Insert_Trigger
AFTER INSERT ON Genero
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Genero', 'Insert', CONCAT('Se inserto el genero con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Genero_Update_Trigger
AFTER UPDATE ON Genero
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Genero', 'Update', CONCAT('Se actualizo el genero con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Genero_Delete_Trigger
AFTER DELETE ON Genero
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Genero', 'Delete', CONCAT('Se elimino el genero con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Clasificacion_Edad
DELIMITER //
CREATE TRIGGER Clasificacion_Edad_Insert_Trigger
AFTER INSERT ON Clasificacion_Edad
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Clasificacion_Edad', 'Insert', CONCAT('Se inserto la clasificacion de edad con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Clasificacion_Edad_Update_Trigger
AFTER UPDATE ON Clasificacion_Edad
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Clasificacion_Edad', 'Update', CONCAT('Se actualizo la clasificacion de edad con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Clasificacion_Edad_Delete_Trigger
AFTER DELETE ON Clasificacion_Edad
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Clasificacion_Edad', 'Delete', CONCAT('Se elimino la clasificacion de edad con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Tipo_Plataforma
DELIMITER //
CREATE TRIGGER Tipo_Plataforma_Insert_Trigger
AFTER INSERT ON Tipo_Plataforma
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Tipo_Plataforma', 'Insert', CONCAT('Se inserto el tipo de plataforma con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tipo_Plataforma_Update_Trigger
AFTER UPDATE ON Tipo_Plataforma
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Tipo_Plataforma', 'Update', CONCAT('Se actualizo el tipo de plataforma con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tipo_Plataforma_Delete_Trigger
AFTER DELETE ON Tipo_Plataforma
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Tipo_Plataforma', 'Delete', CONCAT('Se elimino el tipo de plataforma con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Videojuegos
DELIMITER //
CREATE TRIGGER Videojuegos_Insert_Trigger
AFTER INSERT ON Videojuegos
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Videojuegos', 'Insert', CONCAT('Se inserto el videojuego con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Videojuegos_Update_Trigger
AFTER UPDATE ON Videojuegos
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Videojuegos', 'Update', CONCAT('Se actualizo el videojuego con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Videojuegos_Delete_Trigger
AFTER DELETE ON Videojuegos
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Videojuegos', 'Delete', CONCAT('Se elimino el videojuego con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Tipo_Venta
DELIMITER //
CREATE TRIGGER Tipo_Venta_Insert_Trigger
AFTER INSERT ON Tipo_Venta
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Tipo_Venta', 'Insert', CONCAT('Se inserto el tipo de venta con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tipo_Venta_Update_Trigger
AFTER UPDATE ON Tipo_Venta
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Tipo_Venta', 'Update', CONCAT('Se actualizo el tipo de venta con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tipo_Venta_Delete_Trigger
AFTER DELETE ON Tipo_Venta
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Tipo_Venta', 'Delete', CONCAT('Se elimino el tipo de venta con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Ventas
DELIMITER //
CREATE TRIGGER Ventas_Insert_Trigger
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Ventas', 'Insert', CONCAT('Se inserto una venta con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Ventas_Update_Trigger
AFTER UPDATE ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Ventas', 'Update', CONCAT('Se actualizo una venta con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Ventas_Delete_Trigger
AFTER DELETE ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Ventas', 'Delete', CONCAT('Se elimino una venta con ID: ', OLD.id));
END //
DELIMITER ;

-- Trigger para la tabla Criticas
DELIMITER //
CREATE TRIGGER Criticas_Insert_Trigger
AFTER INSERT ON Criticas
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Criticas', 'Insert', CONCAT('Se inserto una critica con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Criticas_Update_Trigger
AFTER UPDATE ON Criticas
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Criticas', 'Update', CONCAT('Se actualizo una critica con ID: ', NEW.id));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Criticas_Delete_Trigger
AFTER DELETE ON Criticas
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Operaciones (Tabla, Operacion, Detalles) VALUES ('Criticas', 'Delete', CONCAT('Se elimino una critica con ID: ', OLD.id));
END //
DELIMITER ;

CALL CrearPlataforma('PlayStation 5');
CALL CrearPlataforma('Xbox Series X');
CALL CrearPlataforma('Nintendo Switch');
CALL CrearPlataforma('PC');
CALL CrearPlataforma('PlayStation 4');
CALL CrearPlataforma('Xbox One');
CALL CrearPlataforma('iOS');
CALL CrearPlataforma('Android');
CALL CrearPlataforma('Stadia');
CALL CrearPlataforma('PlayStation 3');

CALL CrearDesarrollador('Naughty Dog');
CALL CrearDesarrollador('CD Projekt Red');
CALL CrearDesarrollador('Rockstar Games');
CALL CrearDesarrollador('Ubisoft');
CALL CrearDesarrollador('Bungie');
CALL CrearDesarrollador('Bethesda');
CALL CrearDesarrollador('Square Enix');
CALL CrearDesarrollador('Capcom');
CALL CrearDesarrollador('Valve');
CALL CrearDesarrollador('Insomniac Games');

CALL CrearPublicadoPor('Sony Interactive Entertainment');
CALL CrearPublicadoPor('Microsoft');
CALL CrearPublicadoPor('Nintendo');
CALL CrearPublicadoPor('Ubisoft');
CALL CrearPublicadoPor('Bethesda Softworks');
CALL CrearPublicadoPor('Square Enix');
CALL CrearPublicadoPor('Activision');
CALL CrearPublicadoPor('Electronic Arts');
CALL CrearPublicadoPor('Capcom');
CALL CrearPublicadoPor('Warner Bros. Interactive Entertainment');

CALL CrearGenero('Accion');
CALL CrearGenero('Aventura');
CALL CrearGenero('RPG');
CALL CrearGenero('Shooter');
CALL CrearGenero('Plataformas');
CALL CrearGenero('Estrategia');
CALL CrearGenero('Deportes');
CALL CrearGenero('Carreras');
CALL CrearGenero('Lucha');
CALL CrearGenero('Simulacion');

CALL CrearClasificacionEdad('E (Everyone)');
CALL CrearClasificacionEdad('E10+ (Everyone 10 and older)');
CALL CrearClasificacionEdad('T (Teen)');
CALL CrearClasificacionEdad('M (Mature 17+)');
CALL CrearClasificacionEdad('AO (Adults Only 18+)');
CALL CrearClasificacionEdad('RP (Rating Pending)');
CALL CrearClasificacionEdad('C (Children)');
CALL CrearClasificacionEdad('GA (General Audience)');
CALL CrearClasificacionEdad('MA (Mature Audience)');
CALL CrearClasificacionEdad('A (Adults)');

CALL CrearTipoPlataforma('Consola');
CALL CrearTipoPlataforma('PC');
CALL CrearTipoPlataforma('Movil');
CALL CrearTipoPlataforma('Nube');
CALL CrearTipoPlataforma('VR');
CALL CrearTipoPlataforma('AR');
CALL CrearTipoPlataforma('Web');
CALL CrearTipoPlataforma('Hibrido');
CALL CrearTipoPlataforma('Portatil');
CALL CrearTipoPlataforma('Arcade');

CALL CrearTipoVenta('Fisica');
CALL CrearTipoVenta('En Linea');

CALL CrearVideojuego(
    'The Last of Us Part II', '2020-06-19', 93, 'Metacritic', 9.3, 'Usuarios', 1, 1, 1, 1, 4, 1
);
CALL CrearVideojuego(
    'Cyberpunk 2077', '2020-12-10', 86, 'Metacritic', 7.0, 'Usuarios', 2, 2, 2, 3, 4, 2
);
CALL CrearVideojuego(
    'Red Dead Redemption 2', '2018-10-26', 97, 'Metacritic', 9.7, 'Usuarios', 4, 3, 2, 2, 4, 2
);
CALL CrearVideojuego(
    'Assassins Creed Valhalla', '2020-11-10', 84, 'Metacritic', 8.2, 'Usuarios', 2, 4, 4, 2, 4, 1
);
CALL CrearVideojuego(
    'Destiny 2', '2017-09-06', 85, 'Metacritic', 8.5, 'Usuarios', 1, 5, 7, 4, 3, 1
);
CALL CrearVideojuego(
    'The Elder Scrolls V: Skyrim', '2011-11-11', 94, 'Metacritic', 9.4, 'Usuarios', 4, 6, 5, 3, 4, 2
);
CALL CrearVideojuego(
    'Final Fantasy VII Remake', '2020-04-10', 87, 'Metacritic', 8.7, 'Usuarios', 1, 7, 6, 3, 3, 1
);
CALL CrearVideojuego(
    'Resident Evil 3', '2020-04-03', 79, 'Metacritic', 7.9, 'Usuarios', 1, 8, 9, 2, 4, 1
);
CALL CrearVideojuego(
    'Half-Life: Alyx', '2020-03-23', 92, 'Metacritic', 9.2, 'Usuarios', 4, 9, 10, 1, 4, 5
);
CALL CrearVideojuego(
    'Marvels Spider-Man', '2018-09-07', 87, 'Metacritic', 8.7, 'Usuarios', 1, 10, 1, 2, 3, 1
);

CALL CrearVenta(1, 1, '2021-01-15', 5000, 59.99);
CALL CrearVenta(1, 2, '2021-01-20', 2000, 59.99);
CALL CrearVenta(2, 1, '2021-02-10', 4000, 59.99);
CALL CrearVenta(2, 2, '2021-02-12', 3000, 59.99);
CALL CrearVenta(3, 1, '2021-03-05', 3500, 59.99);
CALL CrearVenta(3, 2, '2021-03-10', 2500, 59.99);
CALL CrearVenta(4, 1, '2021-04-15', 2200, 59.99);
CALL CrearVenta(4, 2, '2021-04-20', 2800,59.99);
CALL CrearVenta(5, 1, '2021-05-10', 3000, 59.99);
CALL CrearVenta(5, 2, '2021-05-12', 2000, 59.99);
CALL CrearVenta(6, 1, '2021-06-01', 5000, 59.99);
CALL CrearVenta(6, 2, '2021-06-05', 4500, 59.99);
CALL CrearVenta(7, 1, '2021-07-15', 3500, 59.99);
CALL CrearVenta(7, 2, '2021-07-20', 3000, 59.99);
CALL CrearVenta(8, 1, '2021-08-10', 2000, 59.99);
CALL CrearVenta(8, 2, '2021-08-12', 1500, 59.99);
CALL CrearVenta(9, 1, '2021-09-01', 1800, 59.99);
CALL CrearVenta(9, 2, '2021-09-05', 2200, 59.99);
CALL CrearVenta(10, 1, '2021-10-10', 4000, 59.99);
CALL CrearVenta(10, 2, '2021-10-15', 3000, 59.99);

CALL CrearCritica(1, 'Buena');
CALL CrearCritica(2, 'Mala');
CALL CrearCritica(3, 'Buena');
CALL CrearCritica(4, 'Mala');
CALL CrearCritica(5, 'Buena');

CALL GetAllPlataformas();
CALL GetAllDesarrolladores();
CALL GetAllPublicadoPor();
CALL GetAllGeneros();
CALL GetAllClasificacionEdad();
CALL GetAllTipoPlataforma();
CALL GetAllVideojuegos();
CALL GetAllTiposVenta();
CALL GetAllVentas();
CALL GetAllCriticas();
