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
    Telefono int not null,
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
        
show tables;

-- create role Administrador;
-- grant all privileges on chinatown.* to Administrador;

-- create role Auditor;
-- grant create ,update ,select on chinatown.* to Auditor;

-- create role Empleado;
-- grant create , update , select on chinatown.* to Empleado;
-- revoke create ,update , drop on chinatown.personal from Empleados;


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

call Insertar_Roles("Administrador");
call Insertar_Roles("Cocinero");
call Insertar_Roles("Mesero");
call Insertar_Roles("Ayudante de cocina");
call Insertar_Roles("Lider de meseros");

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

call Insertar_Personal("Marcos","Lopez",6643470809,now(),1);
call Insertar_Personal("Akira","Navarro",6643470810,now(),2);
call insertar_personal('Ana', 'Garcia', 6654398123, now(),2);
call insertar_personal('Juan', 'Martinez', 6675543210, now(),2);
call insertar_personal('Maria', 'Rodriguez', 6687654321, now(),3);
call insertar_personal('Carlos', 'Sanchez', 6698765432, now(),3);
call insertar_personal('Laura', 'Perez', 6609876543, now(),3);
call insertar_personal('Pedro', 'Gonzalez', 6610987654, now(),3);
call insertar_personal('Sofia', 'Diaz', 6621098765, now(),4);
call insertar_personal('Alejandro', 'Lopez', 6632109876, now(),4);
call insertar_personal('Elena', 'Hernandez', 6643210987, now(),4);
call insertar_personal('Aaron', 'Arteaga', 6648041046, now(),5);

-- Tipo cliente
DELIMITER //
create procedure Insertar_Tipo_Cliente(
    in tc_Nombre varchar(50))
begin
    insert into Tipo_cliente (Nombre)
    values(tc_Nombre);
    
end//
DELIMITER ;

call Insertar_Tipo_Cliente("Para llevar");
call Insertar_Tipo_Cliente("Para Comer Aqui");

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

call Insertar_Clientes(1,"Jorge Torres",6643211029);
call insertar_clientes(1, 'Taro Sato', 1234567890);
call insertar_clientes(2, 'Yumi Suzuki', 2345678901);
call insertar_clientes(1, 'Jiro Takahashi', 3456789012);
call insertar_clientes(2, 'Mika Tanaka', 4567890123);
call insertar_clientes(1, 'Kazuo Ito', 5678901234);
call insertar_clientes(2, 'Sayuri Yamamoto', 6789012345);
call insertar_clientes(1, 'Shuichi Watanabe', 7890123456);
call insertar_clientes(2, 'Yuko Nakamura', 8901234567);
call insertar_clientes(1, 'Akiko Kobayashi', 9012345678);
call insertar_clientes(2, 'Takashi Kato', 9123456789);

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

Call Insertar_sueldos(1,4200);
Call Insertar_sueldos(2,4000);
Call Insertar_sueldos(3,1800);
Call Insertar_sueldos(4,2600);
Call Insertar_sueldos(5,2500);

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

call Insertar_Tipo_Provedores("Servicio al Cliente");
call Insertar_Tipo_Provedores("Verduras");
call Insertar_Tipo_Provedores("Carnes");
call Insertar_Tipo_Provedores("Mariscos");
call Insertar_Tipo_Provedores("Materiales inmuebles");
call Insertar_Tipo_Provedores("Materiales cosina");
call Insertar_Tipo_Provedores("Otros");

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
select * from Provedores;
call Insertar_Provedores("Carnes The Dog",3,"6618974656","Juan.Carnes@gmail.com");
call insertar_provedores("Verduras López", 2, "6671234567", "laura.lopez@frutas.com");
call insertar_provedores("Productos Lácteos García", 7, "6682345678", "pedro.garcia@lacteos.com");
call insertar_provedores("Pescadería Martínez", 4, "6693456789", "ana.martinez@pescaderia.com");
call insertar_provedores("Cerdos Piggy",3, "6604567890", "carlos.gonzalez@panaderia.com");
call insertar_provedores("Dulcería Sánchez", 7, "6615678901", "sofia.sanchez@dulceria.com");
call insertar_provedores("Ferretería Rodríguez", 6, "6626789012", "alejandro.rodriguez@ferreteria.com");
call insertar_provedores("IKEA", 5, "6648901234", "pablo.diaz@IKEA.com");
call insertar_provedores("SR.Yamato", 2 , "6659012345", "luisa.martin@takataka.com");
call insertar_provedores("IKEA", 6, "6660123456", "ana.fernandez@electrodomesticos.com");
call insertar_provedores("Mueblería Ruiz", 6, "6671234567", "javier.ruiz@muebleria.com");
call insertar_provedores("Mar profundo", 4, "6615678901", "sofia.herrera@example.com");
call insertar_provedores("Todo X Comensales", 1, "6643679864", "sofia.herrera@example.com");

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

call insertar_material('pechuga de pollo', 30, 1);
call insertar_material('pierna de cerdo', 25, 1);
call insertar_material('carne de res', 28, 1);
call insertar_material('carne de pato', 35, 5);
call insertar_material('camarones', 40, 5);
call insertar_material('ternera', 32, 1);
call insertar_material('pato', 37, 1);
call insertar_material('cerdo', 29, 5);
call insertar_material('carne de cordero', 33, 5);
call insertar_material('carne de buey', 36, 5);
-- verduras
call insertar_material('col china', 50, 2);
call insertar_material('brócoli chino', 50, 2);
call insertar_material('judías verdes chinas', 50, 2);
call insertar_material('pimiento chino', 50, 9);
call insertar_material('berenjena china', 50, 9);
call insertar_material('calabacín chino', 50, 9);
call insertar_material('nabo chino', 50, 2);
call insertar_material('repollo chino', 50, 9);
call insertar_material('espárragos chinos', 50, 2);
call insertar_material('col rizada china', 50, 2);
call insertar_material('zanahoria', 50, 2);
call insertar_material('cebolla', 50, 2);
call insertar_material('pimiento', 50, 2);
call insertar_material('tomate', 50, 2);
call insertar_material('espinacas', 50, 2);
call insertar_material('calabacín', 50, 9);
call insertar_material('pepino', 50, 9);
call insertar_material('patata', 50, 9);
call insertar_material('calabaza', 50, 9);
call insertar_material('berenjena', 50, 2);
-- Lacteos
call insertar_material('queso', 10, 3);
call insertar_material('yogur', 15, 3);
call insertar_material('crema', 8, 3);
call insertar_material('mantequilla', 7, 3);
call insertar_material('helado', 20, 3);
-- pescaderia 
call insertar_material('camarones', 20, 4);
call insertar_material('calamares', 15, 15);
call insertar_material('pulpo', 18, 4);
call insertar_material('langostinos', 12, 15);
call insertar_material('almejas', 10, 4);
call insertar_material('salmón', 22, 15);
call insertar_material('atún', 25, 4);
call insertar_material('bacalao', 17, 15);
call insertar_material('ostras', 8, 4);
call insertar_material('trucha', 14, 15);
call insertar_material('mejillones', 11, 4);
call insertar_material('vieiras', 13, 15);
call insertar_material('tilapia', 16, 4);
call insertar_material('rape', 19, 15);
call insertar_material('anguila', 21, 4);
call insertar_material('cangrejo', 23, 15);
-- Dulceria
call insertar_material("helado",5,6);
call insertar_material("galletas",200,6);
--  Ferreteria
call insertar_material('freidora eléctrica', 2, 7);
call insertar_material('cesta de freír', 2, 7);
call insertar_material('espumadera', 1, 7);
call insertar_material('papel absorbente', 1, 7);
call insertar_material('tapadera para freír', 2, 7);
call insertar_material('aceite para freír', 3, 7);
call insertar_material('termómetro para aceite', 2, 7);
call insertar_material('plato escurridor', 1, 10);
call insertar_material('pinzas de cocina', 3, 10);
call insertar_material('pala para freír', 2, 7);
call insertar_material('bandeja para escurrir', 1, 10);
call insertar_material('papel pergamino', 1, 7);
call insertar_material('soporte para cucharas', 2, 7);
call insertar_material('guantes resistentes al calor', 3, 10);
-- Muebles de local
call insertar_material('mesas', 30, 8);
call insertar_material('mostradores', 15, 8);
call insertar_material('estantes', 20,11);
call insertar_material('sillones', 10,11);
call insertar_material('escritorios', 25, 8);
call insertar_material('vitrinas', 12, 11);
call insertar_material('cajas registradoras', 8, 8);
call insertar_material('sillas de espera', 10, 11);
call insertar_material('archivadores', 15, 11);
call insertar_material('bancos', 18, 8);
call insertar_material('carteles', 25, 8);
call insertar_material('luces de techo', 30, 8);
call insertar_material('alfombras', 20, 8);
call insertar_material('sistemas de seguridad', 15, 8);
call insertar_material('mostradores de exhibición', 12, 8);
-- servivio al cliente
call Insertar_material("servilletas",300,16);
call Insertar_material('platos', 200, 16);
call Insertar_material('vasos', 150, 16);
call Insertar_material('cucharas', 500, 16);
call Insertar_material('tenedores', 400, 16);
call Insertar_material('tazas', 100, 16);
call Insertar_material('servilletas', 300, 16);
call Insertar_material('mantelería', 50, 16);
call Insertar_material('bandejas', 80, 16);
call Insertar_material('copas', 120, 16);
call Insertar_material('cuchillos', 350, 16);

select * from Materiales;
select * from Provedores;
select * from Tipo_provedores;

-- Me faltan 8 store Procedure los subo para manana antes de las 7am
-- comente por ahora los roles se me hace que se cual es el problema es por que quito permisos lo hare de la forma larga
