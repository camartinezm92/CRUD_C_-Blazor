USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Obtener la información completa del usuario, desencriptando el nombre de usuario.
Entradas: 
    @PI_NID INT - ID del usuario.
Salidas:
    - Id: ID del usuario.
    - NombreUsuario: Nombre desencriptado del usuario.
    - NombreCompleto: Nombre completo del usuario.
    - Rol: Nombre del rol asociado al usuario.
    - FechaCreacion: Fecha de creación del usuario.
Consideraciones: 
    - La contraseña no se desencripta, solo se muestra un marcador de que está encriptada.
    - Es necesario que la clave simétrica y el certificado estén creados y disponibles.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Desencriptación de nombre de usuario y omisión de la contraseña.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_OBTENER_USUARIO_POR_ID]
    @PI_NID INT -- ID del usuario
AS
BEGIN
    -- Abrir la clave simétrica para desencriptar los datos
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Seleccionar los campos necesarios, desencriptando el nombre de usuario
    SELECT 
        U.USU_NID AS Id, 
        CONVERT(NVARCHAR(100), DECRYPTBYKEY(U.USU_CUSUARIO)) AS NombreUsuario, 
        U.USU_CNOMBRE_COMPLETO AS NombreCompleto, 
        R.ROL_CNOMBRE_ROL AS Rol, 
        U.USU_DCREACION AS FechaCreacion
    FROM dbo.TBL_RUSUARIOS U
    JOIN dbo.TBL_RROLES R ON U.USU_NROL_ID = R.ROL_NID
    WHERE U.USU_NID = @PI_NID;

    -- Cerrar la clave simétrica por seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;
END;
GO
