USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 18/09/2024
Propósito: Obtener los datos desencriptados de los usuarios para validar la integridad de los datos y le funcionamiento del KEY.
Entradas: N/A
Salidas:
    - IdUsuario: ID del usuario.
    - UsuarioDesencriptado: Nombre de usuario desencriptado.
    - NombreCompleto: Nombre completo del usuario.
    - FechaCreacion: Fecha de creación del usuario.
    - IdRol: ID del rol del usuario.
    - NombreRol: Nombre del rol asociado.
Consideraciones:
    - Este procedimiento solo debe ejecutarse para fines de auditoría y verificación de datos.
    - No se desencripta la contraseña.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Se agregó la desencriptación completa y la relación con la tabla de roles.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_USUARIOS_DESENCRIPTADOS] 
AS
BEGIN
    -- Abrir la clave simétrica para desencriptar los datos
    OPEN SYMMETRIC KEY ClaveEncriptacion DECRYPTION BY CERTIFICATE CertificadoEncriptacion;

    -- Hacer la consulta desencriptando los campos necesarios (excluyendo la contraseña)
    SELECT 
        U.USU_NID AS IdUsuario,
        CONVERT(nvarchar(100), DECRYPTBYKEY(U.USU_CUSUARIO)) AS UsuarioDesencriptado,
        U.USU_CNOMBRE_COMPLETO AS NombreCompleto,
        -- La contraseña no se desencripta ya que fue encriptada con HASHBYTES
        U.USU_DCREACION AS FechaCreacion,
        U.USU_NROL_ID AS IdRol,
        R.ROL_CNOMBRE_ROL AS NombreRol 
    FROM dbo.TBL_RUSUARIOS U
    JOIN dbo.TBL_RROLES R ON U.USU_NROL_ID = R.ROL_NID;

    -- Cerrar la clave simétrica para seguridad
    CLOSE SYMMETRIC KEY ClaveEncriptacion;
END;
GO
