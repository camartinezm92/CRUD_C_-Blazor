USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Eliminar un usuario de la tabla USUARIOS.
Entradas:
    @PI_NID INT - ID del usuario a eliminar.
Salidas:
    Mensaje de éxito o error según el resultado de la operación.
Consideraciones:
    - El usuario debe existir en la tabla para poder eliminarlo.
    - Se muestra un mensaje de error si el usuario no existe.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Actualización de nombres.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_DEL_ELIMINAR_USUARIO] 
    @PI_NID INT -- ID del usuario
AS
BEGIN
    -- Verificar que el usuario existe
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_RUSUARIOS WHERE USU_NID = @PI_NID)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar el usuario
    DELETE FROM dbo.TBL_RUSUARIOS WHERE USU_NID = @PI_NID;

    -- Devolver un mensaje de éxito
    PRINT 'Usuario eliminado exitosamente.';
END;
GO
