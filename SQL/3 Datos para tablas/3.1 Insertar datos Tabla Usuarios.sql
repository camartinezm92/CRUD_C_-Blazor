USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 25/09/2024
Propósito: Inserción de 30 usuarios en la base de datos utilizando el procedimiento almacenado SPR_INS_CREAR_USUARIO
Consideraciones: El nombre de usuario se encripta y la contraseña se almacena como un hash SHA256.
Modificaciones:
Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

/* Limpieza de la tabla TBL_RUSUARIOS antes de insertar nuevos usuarios */
DELETE FROM TBL_RUSUARIOS;  -- Elimina todos los registros existentes
TRUNCATE TABLE TBL_RUSUARIOS;  -- Reinicia los IDs de la tabla

/* Inserción de 30 usuarios utilizando el procedimiento almacenado SPR_INS_CREAR_USUARIO */
EXEC dbo.SPR_INS_CREAR_USUARIO 'admin', 'Administrador del Sistema', 'admin123', 1;  -- Admin
EXEC dbo.SPR_INS_CREAR_USUARIO 'empleado1', 'Empleado Uno', 'empleado123', 2;  -- Empleado
EXEC dbo.SPR_INS_CREAR_USUARIO 'cliente1', 'Cliente Regular', 'cliente123', 3;  -- Cliente
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario1', 'Usuario Uno', 'usuario123', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario2', 'Usuario Dos', 'usuario456', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario3', 'Usuario Tres', 'usuario789', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario4', 'Usuario Cuatro', 'usuarioABC', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario5', 'Usuario Cinco', 'usuarioDEF', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario6', 'Usuario Seis', 'usuarioGHI', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario7', 'Usuario Siete', 'usuarioJKL', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario8', 'Usuario Ocho', 'usuarioMNO', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario9', 'Usuario Nueve', 'usuarioPQR', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario10', 'Usuario Diez', 'usuarioSTU', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario11', 'Usuario Once', 'usuarioVWX', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario12', 'Usuario Doce', 'usuarioYZA', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario13', 'Usuario Trece', 'usuarioBCD', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario14', 'Usuario Catorce', 'usuarioEFG', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario15', 'Usuario Quince', 'usuarioHIJ', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario16', 'Usuario Dieciseis', 'usuarioKLM', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario17', 'Usuario Diecisiete', 'usuarioNOP', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario18', 'Usuario Dieciocho', 'usuarioQRS', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario19', 'Usuario Diecinueve', 'usuarioTUV', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario20', 'Usuario Veinte', 'usuarioWXY', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario21', 'Usuario Veintiuno', 'usuarioZAB', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario22', 'Usuario Veintidos', 'usuarioCDE', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario23', 'Usuario Veintitres', 'usuarioFGH', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario24', 'Usuario Veinticuatro', 'usuarioIJK', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario25', 'Usuario Veinticinco', 'usuarioLMN', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario26', 'Usuario Veintiseis', 'usuarioOPQ', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario27', 'Usuario Veintisiete', 'usuarioRST', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario28', 'Usuario Veintiocho', 'usuarioUVW', 3;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario29', 'Usuario Veintinueve', 'usuarioXYZ', 2;
EXEC dbo.SPR_INS_CREAR_USUARIO 'usuario30', 'Usuario Treinta', 'usuarioABC123', 3;

PRINT 'Todos los usuarios fueron creados exitosamente.';