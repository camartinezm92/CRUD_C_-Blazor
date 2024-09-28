USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Actualizar los datos de un usuario en la tabla USUARIOS.
Entradas:
    @PI_NID INT - ID del usuario a actualizar.
    @PI_CUSUARIO NVARCHAR(100) - Nombre de usuario en texto plano.
    @PI_CNOMBRE_COMPLETO NVARCHAR(150) - Nombre completo del usuario.
    @PI_CCONTRASENA NVARCHAR(100) - Contraseña en texto plano (opcional para actualizar).
    @PI_NROL_ID INT - ID del rol del usuario.
Salidas:
    Mensaje de éxito o error según el resultado de la operación.
Consideraciones:
    - El ID no se modifica.
    - El usuario debe existir en la tabla.
    - Se encripta el nombre de usuario y la nueva contraseña (si se proporciona).
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Encriptación de los datos del usuario.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_UPD_ACTUALIZAR_USUARIO] 
    @PI_NID INT, -- ID del usuario
    @PI_CUSUARIO NVARCHAR(100), -- Nombre de usuario en texto plano
    @PI_CNOMBRE_COMPLETO NVARCHAR(150), -- Nombre completo del usuario
    @PI_CCONTRASENA NVARCHAR(100), -- Nueva contraseña en texto plano (opcional)
    @PI_NROL_ID INT -- Rol del usuario
AS
BEGIN
    -- Verificar que el usuario existe
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_RUSUARIOS WHERE USU_NID = @PI_NID)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Abrir la clave simétrica para encriptar los datos
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Actualizar los detalles del usuario, incluyendo la encriptación del nombre de usuario y la nueva contraseña
    UPDATE dbo.TBL_RUSUARIOS
    SET USU_CUSUARIO = ENCRYPTBYKEY(KEY_GUID('ClaveEncriptacion'), @PI_CUSUARIO), 
        USU_CNOMBRE_COMPLETO = @PI_CNOMBRE_COMPLETO, 
        USU_BCONTRASENA_HASH = HASHBYTES('SHA2_256', @PI_CCONTRASENA), -- Actualización de la contraseña
        USU_NROL_ID = @PI_NROL_ID
    WHERE USU_NID = @PI_NID;

    -- Cerrar la clave simétrica por seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;

    -- Devolver un mensaje de éxito
    PRINT 'Usuario actualizado exitosamente.';
END;
GO
