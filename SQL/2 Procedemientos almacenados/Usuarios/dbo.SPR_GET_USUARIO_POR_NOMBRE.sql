USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Obtener información de un usuario basado en su nombre de usuario desencriptado.
Entradas: 
    @PI_CUSUARIO NVARCHAR(100) - Nombre de usuario encriptado.
Salidas:
    - IdUsuario: ID del usuario encontrado.
    - NombreIngresado: Nombre de usuario ingresado (sin desencriptar).
    - NombreUsuario: Nombre desencriptado del usuario.
    - NombreCompleto: Nombre completo del usuario.
    - RolId: ID del rol del usuario.
    - RolNombre: Nombre del rol del usuario.
    - BContrasenaHash: Hash de la contraseña (no desencriptada).
Consideraciones: 
    - Si el usuario no existe, se devuelven valores NULL.
    - Es necesario que la clave simétrica y el certificado estén creados y disponibles.
Modificaciones: N/A
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_USUARIO_POR_NOMBRE]
    @PI_CUSUARIO NVARCHAR(100) -- Parámetro: nombre del usuario
AS
BEGIN
    -- Abrir la clave simétrica para desencriptar el nombre de usuario
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Seleccionar el usuario desencriptando el nombre
    SELECT 
        U.USU_NID AS IdUsuario, 
        @PI_CUSUARIO AS NombreIngresado, 
        CONVERT(NVARCHAR(100), DECRYPTBYKEY(U.USU_CUSUARIO)) AS NombreUsuario, 
        U.USU_CNOMBRE_COMPLETO AS NombreCompleto, 
        U.USU_NROL_ID AS RolId,
        ROL.ROL_CNOMBRE_ROL AS RolNombre,
		U.USU_BCONTRASENA_HASH AS BContrasenaHash
    FROM 
        dbo.TBL_RUSUARIOS U
    JOIN 
        dbo.TBL_RROLES ROL ON U.USU_NROL_ID = ROL.ROL_NID
    WHERE 
        CONVERT(NVARCHAR(100), DECRYPTBYKEY(U.USU_CUSUARIO)) = @PI_CUSUARIO;

    -- Si no se encuentra el usuario, devolver NULL para los campos de usuario
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 
            NULL AS IdUsuario, 
            @PI_CUSUARIO AS NombreIngresado, 
            NULL AS NombreUsuario, 
            NULL AS NombreCompleto, 
            NULL AS RolId,
            NULL AS RolNombre; -- Todos los campos NULL si no se encuentra
    END

    -- Cerrar la clave simétrica por seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;
END;
GO
