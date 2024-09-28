USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 18/09/2024
Propósito: Obtener los detalles de un producto por su ID.
Entradas: 
    @PI_NID INT - ID del producto que se desea consultar.
Salidas: 
    - Detalles del producto, incluyendo su ID, nombre, descripción, precio, inventario, y URL o archivo de imagen.
Consideraciones: 
    - La imagen puede ser proporcionada como URL o estar almacenada como archivo.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Actualización de nombres de columnas y estructura de la tabla.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_OBTENER_PRODUCTO_POR_ID]
    @PI_NID INT
AS
BEGIN
    SELECT 
        PRO_NID AS Id, 
        PRO_CNOMBRE AS Nombre, 
        PRO_CDESCRIPCION AS Descripcion, 
        PRO_NPRECIO AS Precio, 
        PRO_NINVENTARIO AS Inventario,
        CASE 
            WHEN PRO_CIMAGEN_URL IS NOT NULL THEN PRO_CIMAGEN_URL
            ELSE 'Imagen almacenada como archivo'
        END AS Imagen
    FROM dbo.TBL_RPRODUCTOS
    WHERE PRO_NID = @PI_NID;
END;
GO
