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
    Telefono int 
    );
    
create table if not exists Rol(
	ID_Rol int primary key auto_increment,
    Nombre varchar (50)
    );

show TABLES;

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

create role Administrador;
grant all privileges on chinatown.* to Administrador;

create role Auditor;
grant create ,update ,select on chinatown.* to Auditor;

create role Empleado;
grant create , update , select on chinatown.* to Empleado;
revoke create ,update , drop on chinatown.personal from Empleados;

-- Roles del personal
CREATE VIEW Roles_Personal AS
SELECT p.nombre, p.apellido, p.sueldo, r.nombre AS rol
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

-- Inventario Bajo Materiales
CREATE VIEW Inventario_Bajo_Materiales AS
SELECT m.nombre AS materiales, m.stock AS materiales_stock
FROM Materiales m
JOIN Provedores p ON m.ID_Provedor = p.ID_Provedor
WHERE m.Stock < 10;

-- Inventario Bajo Ingredientes
CREATE VIEW Inventario_Bajo_Ingredientes AS
SELECT i.nombre AS ingredientes, i.stock AS ingredientes_stock
FROM Ingredientes i
JOIN Provedores p ON i.ID_Provedor = p.ID_Provedor
WHERE i.Stock < 10;

-- Store Procedure

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
  



