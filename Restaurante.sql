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

-- Me faltan 8 store Procedure los subo para manana antes de las 7am
-- comente por ahora los roles se me hace que se cual es el problema es por que quito permisos lo hare de la forma larga
