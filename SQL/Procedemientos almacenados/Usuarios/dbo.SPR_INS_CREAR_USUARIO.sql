USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Creación de un nuevo usuario con encriptación del nombre de usuario y hasheo de la contraseña utilizando SHA2_256. 
            Se valida la existencia de usuarios duplicados.
Entradas: 
    @PI_CUSUARIO NVARCHAR(100) - Nombre de usuario a crear (será encriptado)
    @PI_CNOMBRE_COMPLETO NVARCHAR(150) - Nombre completo del usuario
    @PI_CCONTRASENA NVARCHAR(100) - Contraseña en texto plano (se encriptará con SHA2_256)
    @PI_NROL_ID INT - ID del rol asignado al usuario
Salidas:
    - Retorna el ID del nuevo usuario creado
    - Nombre de usuario y nombre completo
    - Hash de la contraseña
    - Rol asignado
Consideraciones: 
    - Requiere que la clave simétrica y el certificado de encriptación estén creados previamente
    - Verifica si el usuario ya existe antes de crear uno nuevo
Modificaciones:
    Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_INS_CREAR_USUARIO]
    @PI_CUSUARIO NVARCHAR(100), 
    @PI_CNOMBRE_COMPLETO NVARCHAR(150), 
    @PI_CCONTRASENA NVARCHAR(100), 
    @PI_NROL_ID INT 
AS
BEGIN
    DECLARE @cantidad INT;
    DECLARE @hashedPassword VARBINARY(256);

    -- Abrir la clave simétrica para desencriptar los datos
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Contar usuarios existentes con el mismo nombre
    SELECT 
        @cantidad = COUNT(*)
    FROM 
        dbo.TBL_RUSUARIOS
    WHERE 
        CONVERT(NVARCHAR(100), DECRYPTBYKEY(USU_CUSUARIO)) = @PI_CUSUARIO;

    -- Cerrar la clave simétrica por seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;

    -- Si el usuario ya existe, manejar el error
    IF @cantidad > 0
    BEGIN
        RAISERROR('El nombre de usuario ya existe.', 16, 1);
        RETURN;
    END

    -- Obtener el hash de la contraseña
    SELECT @hashedPassword = HASHBYTES('SHA2_256', @PI_CCONTRASENA);

    -- Abrir la clave simétrica para encriptar los datos
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Insertar el nuevo usuario con los datos encriptados
    INSERT INTO dbo.TBL_RUSUARIOS (USU_CUSUARIO, USU_CNOMBRE_COMPLETO, USU_BCONTRASENA_HASH, USU_NROL_ID)
    VALUES (
        ENCRYPTBYKEY(KEY_GUID('ClaveEncriptacion'), @PI_CUSUARIO), 
        @PI_CNOMBRE_COMPLETO, 
        @hashedPassword, 
        @PI_NROL_ID
    );

    -- Obtener el ID del nuevo usuario
    DECLARE @nuevoUsuarioId INT = SCOPE_IDENTITY();

    -- Cerrar la clave simétrica por seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;

    -- Devolver el nuevo usuario, su rol y el rol ID
    SELECT 
        @nuevoUsuarioId AS NuevoUsuarioId, 
        @PI_CUSUARIO AS NombreUsuario, 
        @PI_CNOMBRE_COMPLETO AS NombreCompleto,
        @hashedPassword AS BContrasenaHash,
        @PI_NROL_ID AS RolId,
        ROL.ROL_CNOMBRE_ROL AS RolNombre
    FROM 
        dbo.TBL_RUSUARIOS U
    JOIN 
        dbo.TBL_RROLES ROL ON U.USU_NROL_ID = ROL.ROL_NID
    WHERE 
        U.USU_NID = @nuevoUsuarioId;

    PRINT 'Usuario agregado exitosamente.';
END;
GO
