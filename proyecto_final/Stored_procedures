use Metacritics;

CALL CrearPlataforma('nombre_plataforma');
CALL GetAllPlataformas();
CALL UpdateByIdPlataforma(11, 'nuevo_nombre_plataforma');
CALL GetByIdPlataforma(11);
CALL DeleteByIdPlataforma(11);
CALL DeleteAllPlataformas();

CALL CrearDesarrollador('nombre_desarrollador');
CALL GetAllDesarrolladores();
CALL UpdateByIdDesarrollador(11, 'nuevo_nombre_desarrollador');
CALL GetByIdDesarrollador(11);
CALL DeleteByIdDesarrollador(11);
CALL DeleteAllDesarrolladores();

CALL CrearPublicadoPor('nombre_publicado_por');
CALL GetAllPublicadoPor();
CALL UpdateByIdPublicadoPor(11, 'nuevo_nombre_publicado_por');
CALL GetByIdPublicadoPor(11);
CALL DeleteByIdPublicadoPor(11);
CALL DeleteAllPublicadoPor();

CALL CrearGenero('nombre_genero');
CALL GetAllGeneros();
CALL UpdateByIdGenero(11, 'nuevo_nombre_genero');
CALL GetByIdGenero(11);
CALL DeleteGeneroById(11);
CALL DeleteAllGeneros();

CALL CrearClasificacionEdad('nombre_edad');
CALL GetAllClasificacionEdad();
CALL UpdateByIdClasificacionEdad(11, 'nuevo_nombre_edad');
CALL GetClasificacionEdadById(11);
CALL DeleteByIdClasificacionEdad(11);
CALL DeleteAllClasificacionEdad();

CALL CrearTipoPlataforma('nombre_tipo_plataforma');
CALL GetAllTipoPlataforma();
CALL UpdateByIdTipoPlataforma(11, 'nuevo_nombre_tipo_plataforma');
CALL GetTipoPlataformaById(11);
CALL DeleteByIdTipoPlataforma(11);
CALL DeleteAllTipoPlataforma();

CALL CrearVideojuego('nombre_videojuego', '2024-05-26', 80, 'Meta', 8.5, 'Usuario', 1, 1, 1, 1, 1, 1); -- Se tiene que ejecutar anter de eliminar las FKs
CALL GetAllVideojuegos();
CALL UpdateByIdVideojuego(11, 'nuevo_nombre_videojuego', '2024-05-27', 85, 'Meta', 9.0, 'Usuario', 2, 2, 2, 2, 2, 2);
CALL GetVideojuegoById(11);
CALL DeleteByIdVideojuego(11);
CALL DeleteAllVideojuegos(); -- Se debe de eliminar Criticas primero

CALL CrearTipoVenta('nombre_tipo_venta'); 
CALL GetAllTiposVenta();
CALL UpdateByIdTipoVenta(3, 'nuevo_nombre_tipo_venta');
CALL GetByIdTipoVenta(3);
CALL DeleteByIdTipoVenta(3);
CALL DeleteAllTiposVenta();

CALL CrearVenta(1, 1, '2024-05-26', 10, 50.00); -- Se tiene que ejecutar anter de eliminar las FKs
CALL GetAllVentas();
CALL UpdateByIdVenta(21, 2, 2, '2024-05-27', 20, 100.00);
CALL GetByIdVenta(21);
CALL DeleteByIdVenta(21);
CALL DeleteAllVentas();

CALL CrearCritica(1, 'Buena');
CALL GetAllCriticas();
CALL UpdateByIdCritica(6, 2, 'Mala');
CALL GetByIdCritica(6);
CALL DeleteByIdCritica(6);
CALL DeleteAllCriticas();

Select * from Registro_Operaciones;
