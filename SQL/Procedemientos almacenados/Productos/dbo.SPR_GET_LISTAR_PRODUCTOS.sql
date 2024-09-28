USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 18/09/2024
Propósito: Obtener la lista de productos con detalles, incluyendo la imagen.
Entradas: N/A
Salidas: 
    - Lista de productos con ID, nombre, descripción, precio, inventario y imagen.
Consideraciones: 
    - Si la URL de la imagen está disponible, se muestra. De lo contrario, se indica que la imagen está almacenada como archivo.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Actualización de nombres de columnas y estructura de la tabla.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_LISTAR_PRODUCTOS]
AS
BEGIN
    SELECT 
		PRO_NID AS ID,
        PRO_CNOMBRE AS Nombre, 
        PRO_CDESCRIPCION AS Descripcion, 
        PRO_NPRECIO AS Precio, 
        PRO_NINVENTARIO AS Inventario,
        CASE 
            WHEN PRO_CIMAGEN_URL IS NOT NULL THEN PRO_CIMAGEN_URL
            ELSE 'Imagen almacenada como archivo'
        END AS Imagen
    FROM dbo.TBL_RPRODUCTOS;
END;
GO
