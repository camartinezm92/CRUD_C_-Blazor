USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Generar el hash de una contraseña utilizando el algoritmo SHA2_256.
Entradas: 
    @PI_CCONTRASENA NVARCHAR(100) - Contraseña en texto plano que será hasheada.
Salidas:
    - HashedPassword: El hash de la contraseña utilizando SHA2_256.
Consideraciones: 
    - Solo se realiza el hasheo de la contraseña, no hay encriptación adicional.
Modificaciones: N/A
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GI__HASH_CONTRASENA]
    @PI_CCONTRASENA NVARCHAR(100)
AS
BEGIN
    -- Devolver el hash de la contraseña
    SELECT HASHBYTES('SHA2_256', @PI_CCONTRASENA) AS HashedPassword;
END;
GO
