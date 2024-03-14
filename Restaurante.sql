drop database chinatown;

CREATE DATABASE ChinaTown;
USE ChinaTown;

create table if not exists Tipo_cliente (
	ID_Tipocliente int primary key auto_increment,
    Nombre varchar(50) not null
    );
    
create table if not exists Clientes(
	ID_Cliente int primary key auto_increment,
    ID_Tipocliente int,
	foreign key (ID_Tipocliente) references Tipo_cliente(ID_Tipocliente),
    Nombre varchar(50),
    Telefono varchar(50)
    );
    
create table if not exists Rol(
	ID_Rol int primary key auto_increment,
    Nombre varchar (50)
    );

create table if not exists Sueldos(
	ID_Sueldos int primary key auto_increment,
    ID_Rol int not null,
    foreign key (ID_Rol) references Rol(ID_Rol),
    Sueldo float not null);

create table if not exists Personal(
	ID_Personal int primary key auto_increment,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    Telefono varchar(50),
    Fecha_ingreso datetime not null,
    ID_Rol int not null,
    foreign key (ID_Rol) references Rol(ID_Rol)
    );
 
create table Pesonal_Bitacora(
	ID_Bitacora int primary key auto_increment,
    ID_Anterior int not null,
    Nombre varchar(50) not null ,
    Fecha_renuncia datetime);

create table if not exists Tipo_Provedores(
	ID_Tipoprovedores int primary key auto_increment,
    Nombre varchar(50)
    );
    
create table if not exists Provedores(
	ID_Provedor int primary key auto_increment,
    Nombre varchar(50) not null,
    ID_Tipoprovedores int not null,
    foreign key (ID_Tipoprovedores) references Tipo_Provedores(ID_Tipoprovedores),
    Telefono varchar(50),
    Correo varchar(50) default "Sin correo"
    );

create table if not exists Materiales (
	ID_Material int primary key auto_increment,
    Nombre varchar(50) not null,
    Stock int not null,
    ID_Provedor int,
    foreign key (ID_Provedor) references Provedores(ID_Provedor)
    );

create table if not exists Ingredientes(
	ID_Ingredientes int primary key auto_increment,
    ID_Provedor int not null,
    Nombre varchar(50) not null,
    Fecha_Recepcion datetime not null,
    stock int default 0,
    Concervacion varchar(50) not null,
    foreign key (ID_Provedor) references Provedores(ID_Provedor)
    );

create table if not exists Categorias(
	ID_Categoria int primary key auto_increment,
    Nombre varchar(50)
    );
    
create table if not exists Platillos(
	ID_Platillo int primary key auto_increment,
	Nombre varchar(50) not null,
    Descripcion varchar(50) not null,
    Precio float not null,
    ID_Categoria int not null,
    ID_Ingredientes int not null,
    foreign key (ID_Categoria) references Categorias (ID_Categoria),
    foreign key (ID_Ingredientes) references Ingredientes(ID_Ingredientes)
    );
    
    create table if not exists Pedidos(
		ID_Pedido int primary key auto_increment,
        ID_Cliente int not null,
        ID_Personal int not null,
        ID_Platillo int not null,
        Total float not null ,
        Fecha datetime not null,
        Entregado varchar(2) not null default "No",
		foreign key (ID_Cliente) references Clientes(ID_Cliente),
		foreign key (ID_Personal) references Personal(ID_Personal),
		foreign key (ID_Platillo) references Platillos(ID_Platillo)
        );

create table if not exists Alertas(
		ID INT AUTO_INCREMENT PRIMARY KEY,
		Mensaje VARCHAR(255),
		Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
        
drop role if exists Administrador;
create role Administrador;
grant all privileges on chinatown.* to Administrador;

drop role if exists Auditor;
create role Auditor;
grant create ,update ,select on chinatown.* to Auditor;

drop role if exists Empleado;
create role Empleado;
grant select on chinatown.* to Empleado;


-- Roles del personal
CREATE VIEW Roles_Personal AS
SELECT p.nombre, p.apellido, r.nombre AS rol
FROM Personal p
JOIN Rol r ON p.ID_Rol = r.ID_Rol;

-- Platillos por categoria
CREATE VIEW Categorias_Platillos AS
SELECT c.nombre AS categoria, p.nombre, p.descripcion, p.precio
FROM Platillos p
JOIN Categorias c ON p.id_categoria = c.id_categoria;

-- Tipos de proveedores
CREATE VIEW Proveedor_Tipo AS
SELECT tp.nombre AS Tipo, p.nombre, p.telefono, p.correo
FROM Provedores p
JOIN Tipo_Provedores tp ON p.id_tipoprovedores = tp.id_tipoprovedores;

-- Informacion completa de pedidos
CREATE VIEW Info_Pedidos AS
SELECT pe.id_pedido, cl.nombre AS Cliente, pe.fecha, pe.total, pe.entregado, per.nombre AS atendido_por, pl.nombre AS platillo
FROM Pedidos pe
JOIN Clientes cl ON pe.id_cliente = cl.id_cliente
JOIN Personal per ON pe.id_personal = per.id_personal
JOIN Platillos pl ON pe.id_platillo = pl.id_platillo;

-- Ingresos por platillos
CREATE VIEW Ingresos_Platillos AS
SELECT pl.nombre, SUM(pe.total) AS Ingresos
FROM Pedidos pe
JOIN Platillos pl ON pe.id_platillo = pl.id_platillo
GROUP BY pl.nombre;


-- Rol
DELIMITER //
create procedure Insertar_Roles(
    in r_Nombre varchar(50)
)
begin
	insert into Rol(Nombre)
	values(r_Nombre);
end//
DELIMITER ;

-- call Insertar_Roles("Administrador");
-- call Insertar_Roles("Cocinero");
-- call Insertar_Roles("Mesero");
-- call Insertar_Roles("Ayudante de cocina");
-- call Insertar_Roles("Lider de meseros");

-- personal
DELIMITER //
create procedure Insertar_Personal(
    in p_Nombre varchar(50),
    in p_Apellido varchar(50),
    in p_Telefono varchar(50),
    in p_Fecha_ingreso datetime,
    in p_ID_Rol int
)
begin
    insert into Personal(Nombre, Apellido, Telefono, Fecha_ingreso, ID_Rol)
    values(p_Nombre, p_Apellido, p_Telefono, p_Fecha_ingreso, p_ID_Rol);
end//
DELIMITER ;

-- call Insertar_Personal("Marcos","Lopez",6643470809,now(),1);
-- call Insertar_Personal("Akira","Navarro",6643470810,now(),2);
-- call insertar_personal('Ana', 'Garcia', 6654398123, now(),2);
-- call insertar_personal('Juan', 'Martinez', 6675543210, now(),2);
-- call insertar_personal('Maria', 'Rodriguez', 6687654321, now(),3);
-- call insertar_personal('Carlos', 'Sanchez', 6698765432, now(),3);
-- call insertar_personal('Laura', 'Perez', 6609876543, now(),3);
-- call insertar_personal('Pedro', 'Gonzalez', 6610987654, now(),3);
-- call insertar_personal('Sofia', 'Diaz', 6621098765, now(),4);
-- call insertar_personal('Alejandro', 'Lopez', 6632109876, now(),4);
-- call insertar_personal('Elena', 'Hernandez', 6643210987, now(),4);
-- call insertar_personal('Aaron', 'Arteaga', 6648041046, now(),5);

-- Tipo cliente
DELIMITER //
create procedure Insertar_Tipo_Cliente(
    in tc_Nombre varchar(50))
begin
    insert into Tipo_cliente (Nombre)
    values(tc_Nombre);
    
end//
DELIMITER ;

-- call Insertar_Tipo_Cliente("Para llevar");
-- call Insertar_Tipo_Cliente("Para Comer Aqui");

-- Cliente 
describe Clientes;
DELIMITER //
create procedure Insertar_Clientes(
    in C_ID_Tipocliente int,
    in C_Nombre varchar(50),
    in C_Telefono varchar(50) 
)
begin
    insert into Clientes (ID_Tipocliente,Nombre,Telefono)
    values(C_ID_Tipocliente,C_Nombre,C_Telefono);
    
end//
DELIMITER ;

-- call Insertar_Clientes(1,"Jorge Torres",6643211029);
-- call insertar_clientes(1, 'Taro Sato', 1234567890);
-- call insertar_clientes(2, 'Yumi Suzuki', 2345678901);
-- call insertar_clientes(1, 'Jiro Takahashi', 3456789012);
-- call insertar_clientes(2, 'Mika Tanaka', 4567890123);
-- call insertar_clientes(1, 'Kazuo Ito', 5678901234);
-- call insertar_clientes(2, 'Sayuri Yamamoto', 6789012345);
-- call insertar_clientes(1, 'Shuichi Watanabe', 7890123456);
-- call insertar_clientes(2, 'Yuko Nakamura', 8901234567);
-- call insertar_clientes(1, 'Akiko Kobayashi', 9012345678);
-- call insertar_clientes(2, 'Takashi Kato', 9123456789);

Delimiter //
create procedure Insertar_sueldos(
	in S_ID_Rol int ,
	in S_Sueldo float 
)
begin
	insert into Sueldos (ID_Rol,Sueldo)
    values(S_ID_Rol,S_Sueldo);
end //
Delimiter ;

-- Call Insertar_sueldos(1,4200);
-- Call Insertar_sueldos(2,4000);
-- Call Insertar_sueldos(3,1800);
-- Call Insertar_sueldos(4,2600);
-- Call Insertar_sueldos(5,2500);

-- Tipo Provedores
Delimiter //
create procedure Insertar_Tipo_Provedores(
	in tp_Nombre varchar(50)
)
begin
	insert into Tipo_Provedores(Nombre)
    values (tp_Nombre);
end//Insertar_Tipo_Provedores
Delimiter ;

-- call Insertar_Tipo_Provedores("Servicio al Cliente");
-- call Insertar_Tipo_Provedores("Verduras");
-- call Insertar_Tipo_Provedores("Carnes");
-- call Insertar_Tipo_Provedores("Mariscos");
-- call Insertar_Tipo_Provedores("Materiales inmuebles");
-- call Insertar_Tipo_Provedores("Materiales cosina");
-- call Insertar_Tipo_Provedores("Otros");

-- Provedores
Delimiter //
create procedure Insertar_Provedores(
    in P_Nombre varchar(50),
    in P_ID_Tipoprovedores int,
    in P_Telefono varchar(50),
    in P_Correo varchar(50)
)
begin
	insert into Provedores(Nombre,ID_Tipoprovedores,Telefono,Correo) 
    values(P_Nombre,P_ID_Tipoprovedores,P_Telefono,P_Correo);
end//
Delimiter //

-- call Insertar_Provedores("Carnes The Dog",3,"6618974656","Juan.Carnes@gmail.com");
-- call insertar_provedores("Verduras López", 2, "6671234567", "laura.lopez@frutas.com");
-- call insertar_provedores("Productos Lácteos García", 7, "6682345678", "pedro.garcia@lacteos.com");
-- call insertar_provedores("Pescadería Martínez", 4, "6693456789", "ana.martinez@pescaderia.com");
-- call insertar_provedores("Cerdos Piggy",3, "6604567890", "carlos.gonzalez@panaderia.com");
-- call insertar_provedores("Dulcería Sánchez", 7, "6615678901", "sofia.sanchez@dulceria.com");
-- call insertar_provedores("Ferretería Rodríguez", 6, "6626789012", "alejandro.rodriguez@ferreteria.com");
-- call insertar_provedores("IKEA", 5, "6648901234", "pablo.diaz@IKEA.com");
-- call insertar_provedores("SR.Yamato", 2 , "6659012345", "luisa.martin@takataka.com");
-- call insertar_provedores("IKEA", 6, "6660123456", "ana.fernandez@electrodomesticos.com");
-- call insertar_provedores("Mueblería Ruiz", 6, "6671234567", "javier.ruiz@muebleria.com");
-- call insertar_provedores("Mar profundo", 4, "6615678901", "sofia.herrera@example.com");
-- call insertar_provedores("Todo X Comensales", 1, "6643679864", "sofia.herrera@example.com");

Delimiter //
create procedure Insertar_Material(
	in M_Nombre varchar(50),
    in M_Stock int ,
    in M_ID_Provedor int
)
begin
	insert into Materiales(Nombre,Stock,ID_Provedor)
    values(M_Nombre,M_Stock,M_ID_Provedor);
end//
Delimiter ;

-- Materiales
-- CALL Insertar_Material("Mesa de Banquete", 2, 7);
-- CALL Insertar_Material("Silla de Banquete", 2, 7);
-- CALL Insertar_Material("Carrito de Servicio", 2, 11);
-- CALL Insertar_Material("Mostrador de Bar", 2, 12);
-- CALL Insertar_Material("Refrigerador de Bebidas", 2, 12);
-- CALL Insertar_Material("Mesa de Banquete", 2, 12);
-- CALL Insertar_Material("Silla de Banquete", 2, 11);
-- CALL Insertar_Material("Carrito de Servicio", 2, 7);
-- CALL Insertar_Material("Mostrador de Bar", 2, 11);
-- CALL Insertar_Material("Refrigerador de Bebidas", 2, 11);

Delimiter //
create procedure Insertar_Ingredientes(
	in I_ID_Provedor int,
    in I_Nombre varchar(50),
    in I_Fecha_Recepcion datetime,
    in I_stock int,
    in I_Concervacion varchar(50)
)
begin
	insert into Ingredientes(ID_Provedor,Nombre,Fecha_Recepcion,stock,Concervacion)
    values (I_ID_Provedor,I_Nombre,I_Fecha_Recepcion,I_stock,I_Concervacion);
    
end//
Delimiter ;

-- CALL Insertar_Ingredientes(1, 'pechuga de pollo', NOW(), 30, 'Refrigerado');
-- CALL Insertar_Ingredientes(1, 'pierna de cerdo', NOW(), 25, 'Refrigerado');
-- CALL Insertar_Ingredientes(1, 'carne de res', NOW(), 28, 'Refrigerado');
-- CALL Insertar_Ingredientes(5, 'carne de pato', NOW(), 35, 'Refrigerado');
-- CALL Insertar_Ingredientes(5, 'camarones', NOW(), 40, 'Refrigerado');
-- CALL Insertar_Ingredientes(1, 'ternera', NOW(), 32, 'Refrigerado');
-- CALL Insertar_Ingredientes(1, 'pato', NOW(), 37, 'Refrigerado');
-- CALL Insertar_Ingredientes(5, 'cerdo', NOW(), 29, 'Refrigerado');
-- CALL Insertar_Ingredientes(5, 'carne de cordero', NOW(), 33, 'Refrigerado');
-- CALL Insertar_Ingredientes(5, 'carne de buey', NOW(), 36, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'col china', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'brócoli chino', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'judías verdes chinas', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'pimiento chino', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'berenjena china', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'calabacín chino', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'nabo chino', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'repollo chino', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'espárragos chinos', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'col rizada china', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'zanahoria', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'cebolla', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'pimiento', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'tomate', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'espinacas', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'calabacín', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'pepino', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'patata', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(9, 'calabaza', NOW(), 50, 'Refrigerado');
-- CALL Insertar_Ingredientes(2, 'berenjena', NOW(), 50, 'Refrigerado');
-- Lácteos
-- CALL Insertar_Ingredientes(3, 'queso', NOW(), 10, 'Refrigerado');
-- CALL Insertar_Ingredientes(3, 'yogur', NOW(), 15, 'Refrigerado');
-- CALL Insertar_Ingredientes(3, 'crema', NOW(), 8, 'Refrigerado');
-- CALL Insertar_Ingredientes(3, 'mantequilla', NOW(), 7, 'Refrigerado');
-- CALL Insertar_Ingredientes(3, 'helado', NOW(), 20, 'Refrigerado');
-- Pescadería
-- CALL Insertar_Ingredientes(4, 'camarones', NOW(), 20, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'calamares', NOW(), 15, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'pulpo', NOW(), 18, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'langostinos', NOW(), 12, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'almejas', NOW(), 10, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'salmón', NOW(), 22, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'atún', NOW(), 25, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'bacalao', NOW(), 17, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'ostras', NOW(), 8, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'trucha', NOW(), 14, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'mejillones', NOW(), 11, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'vieiras', NOW(), 13, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'tilapia', NOW(), 16, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'rape', NOW(), 19, 'Refrigerado');
-- CALL Insertar_Ingredientes(4, 'anguila', NOW(), 21, 'Refrigerado');
-- CALL Insertar_Ingredientes(12, 'cangrejo', NOW(), 23, 'Refrigerado');
-- Dulcería
-- CALL Insertar_Ingredientes(6, 'helado', NOW(), 5, 'Refrigerado');
-- CALL Insertar_Ingredientes(6, 'galletas', NOW(), 200, 'Refrigerado');

-- Categorias
Delimiter //
create procedure Insertar_Categorias(
	in Cat_Nombre varchar(50)
) 
begin
	insert into Categorias (Nombre) 
    values (Cat_Nombre);

end //
Delimiter ;

-- call Insertar_Categorias("Normal");
-- call Insertar_Categorias("Frio");
-- call Insertar_Categorias("Especial");

describe pedidos;

Delimiter //
create procedure Insertar_platillo(
	in pla_Nombre varchar(50),
    in pla_Descripcion varchar(50),
    in pla_Precio float,
    in pla_ID_Categoria int,
	in pla_ID_Ingredientes int
)
begin
	insert into platillos (Nombre,Descripcion,Precio,ID_Categoria,ID_Ingredientes)
    values (pla_Descripcion,pla_Precio,pla_ID_Categoria, pla_ID_Ingredientes);
end//
Delimiter ;

-- CALL Insertar_platillo('Pollo agridulce', 'Delicioso pollo agridulce con trozos de pimiento y piña.', 9.99, 1, 1);
-- CALL Insertar_platillo('Arroz frito', 'Arroz salteado con vegetales, huevo y trozos de carne.', 8.50, 1, 2);
-- CALL Insertar_platillo('Rollitos de primavera', 'Rollos crujientes rellenos de vegetales y carne.', 7.25, 1, 3);
-- CALL Insertar_platillo('Chow mein de pollo', 'Fideos fritos con pollo, verduras y salsa de soja.', 10.75, 1, 4);
-- CALL Insertar_platillo('Wantán frito', 'Dumplings rellenos de carne de cerdo, fritos hasta que estén crujientes.', 6.99, 1, 5);
-- CALL Insertar_platillo('Cerdo a la naranja', 'Trozos de cerdo salteados en salsa de naranja con vegetales.', 12.50, 1, 6);
-- CALL Insertar_platillo('Camarones al estilo cantonés', 'Camarones frescos salteados con vegetales en salsa de ostras.', 13.99, 1, 7);
-- CALL Insertar_platillo('Ternera con brócoli', 'Ternera tierna y brócoli en una salsa de ajo y jengibre.', 11.25, 1, 8);
-- CALL Insertar_platillo('Sopa de wonton', 'Caldo de pollo con wontons rellenos de cerdo y camarones.', 5.50, 1, 9);
-- CALL Insertar_platillo('Pato laqueado', 'Pato crujiente con piel dorada servido con salsa hoisin y crepes.', 15.99, 1, 10);
-- CALL Insertar_platillo('Tofu mapo', 'Tofu suave y picante con carne de cerdo en una salsa de frijol picante.', 9.75, 1, 11);


-- Aqui empesemos con los 5 triggers:
--1 Caducidad
--2 stock
--3 Empleados antiguos 
--4 mensajes o no se tu 

-- Actualiza Stock
DELIMITER //
CREATE TRIGGER ActualizarStock AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Ingredientes
    SET Stock = Stock - 1
    WHERE ID_Ingredientes IN (SELECT ID_Ingredientes FROM Platillos WHERE ID_Platillo = NEW.ID_Platillo);
END//
DELIMITER ;

-- Cambio de Personal
DELIMITER //
CREATE TRIGGER RegistrarCambioPersonal
AFTER UPDATE ON Personal
FOR EACH ROW
BEGIN
    INSERT INTO Pesonal_Bitacora (ID_Anterior, Nombre, Fecha_renuncia)
    VALUES (OLD.ID_Personal, CONCAT(OLD.Nombre, ' ', OLD.Apellido), NOW());
END//
DELIMITER ;

-- Stock de un producto llega a cero
DELIMITER //
CREATE TRIGGER notificar AFTER UPDATE ON Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.Stock = 0 THEN
        INSERT INTO Alertas (Mensaje) VALUES ('El stock de un ingrediente está por debajo de 10 unidades.');
    END IF;
END//
DELIMITER //

-- Alerta Stock Bajo
DELIMITER //
CREATE TRIGGER ChecaStock AFTER UPDATE ON Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.stock < 10 THEN
        INSERT INTO Alertas (Mensaje) VALUES ('El stock de un ingrediente ha llegado a cero.');
    END IF;
END//
DELIMITER //

-- Telefono de provedor con stock bajo
DELIMITER //
CREATE TRIGGER telefono AFTER UPDATE ON Ingredientes
FOR EACH ROW
BEGIN
	DECLARE proveedor_msg VARCHAR(255);
    DECLARE proveedor_telefono VARCHAR(50);
    IF NEW.Stock = 0 THEN
        SELECT telefono INTO proveedor_telefono
        FROM Provedores
        WHERE ID_Provedor = (
            SELECT ID_Provedor
            FROM Ingredientes
            WHERE ID_Ingredientes = NEW.ID_Ingredientes
        );
        SET proveedor_msg = CONCAT('Llame al proveedor para conseguir mas ingredientes: ', proveedor_telefono);
        INSERT INTO Alertas (Mensaje) VALUES (proveedor_msg);
    END IF;
END;
//
DELIMITER ;

--Aqui empecemos con las funciones unas 5 

-- Calcular Total de Pedido
DELIMITER //
CREATE FUNCTION CalcularTotalPedido(ID_Platillo INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE precioPlatillo FLOAT;
    SELECT Precio INTO precioPlatillo FROM Platillos WHERE ID_Platillo = ID_Platillo;
    RETURN precioPlatillo;
END //
DELIMITER ;

-- Marcar Pedido Como Entregado
DELIMITER //
CREATE FUNCTION MarcarPedidoEntregado(ID_Pedido INT) RETURNS VARCHAR(50)
BEGIN
    UPDATE Pedidos SET Entregado = 'Sí' WHERE ID_Pedido = ID_Pedido;
    RETURN 'Pedido marcado como entregado';
END //
DELIMITER ;

-- Pedidos Por Cliente
DELIMITER //

CREATE FUNCTION ContarPedidosPorCliente(ID_Cliente INT) RETURNS INT
BEGIN
    DECLARE totalPedidos INT;
    
    SELECT COUNT(*) INTO totalPedidos FROM Pedidos WHERE ID_Cliente = ID_Cliente;
    
    RETURN totalPedidos;
END //
DELIMITER ;

-- Vistas hacer vistas referentes a
-- 1 los platillos 
-- 2 Empleados
-- 3 provedores con where 
