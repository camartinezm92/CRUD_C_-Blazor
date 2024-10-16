USE [PRUEBA_USUARIOS]
GO

/****** Object:  StoredProcedure [dbo].[SPR_GET_USUARIO_POR_NOMBRE]    Script Date: 15/10/2024 15:00:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_USUARIO_POR_NOMBRE]
    @PI_CUSUARIO NVARCHAR(100) -- Parámetro: nombre del usuario
AS
BEGIN
    SET NOCOUNT ON;

    -- Abrir la clave simétrica para desencriptar el nombre de usuario
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Seleccionar el usuario desencriptando el nombre
    SELECT 
        U.USU_NID AS IdUsuario, 
        @PI_CUSUARIO AS NombreIngresado, 
        CAST(CONVERT(NVARCHAR(100), DECRYPTBYKEY(U.USU_CUSUARIO)) AS VARBINARY(MAX)) AS NombreUsuario, 
        CAST(U.USU_CNOMBRE_COMPLETO AS VARBINARY(MAX)) AS NombreCompleto, 
        U.USU_NROL_ID AS RolId,
        ROL.ROL_CNOMBRE_ROL AS RolNombre,
        CAST(U.USU_CPASSWORD AS VARBINARY(MAX)) AS BContrasenaHash
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
            NULL AS RolNombre, 
            NULL AS BContrasenaHash; -- Mantiene el número de columnas
    END

    -- Cerrar la clave simétrica por seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;
END;
GO


