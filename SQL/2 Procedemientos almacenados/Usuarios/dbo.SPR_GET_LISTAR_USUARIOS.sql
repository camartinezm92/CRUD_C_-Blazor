USE [PRUEBA_USUARIOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Obtener la lista de usuarios con su ID, nombre completo y rol.
Entradas: N/A
Salidas:
    - Id: ID del usuario.
    - NombreCompleto: Nombre completo del usuario.
    - Rol: Nombre del rol asociado al usuario.
Consideraciones: Este procedimiento no requiere desencriptación de los datos.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Simplificación del procedimiento para no incluir desencriptación.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_LISTAR_USUARIOS]
AS
BEGIN
    SELECT 
        USU_NID AS Id,
        USU_CNOMBRE_COMPLETO AS NombreCompleto,
        ROL_CNOMBRE_ROL AS Rol 
    FROM dbo.TBL_RUSUARIOS U
    JOIN dbo.TBL_RROLES R ON U.USU_NROL_ID = R.ROL_NID;
END;
GO
