USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 18/09/2024
Propósito: Actualizar los detalles de un producto específico en la base de datos.
Entradas:
    @PI_NID INT - ID del producto a actualizar.
    @PI_CNOMBRE NVARCHAR(100) - Nombre del producto.
    @PI_CDESCRIPCION NVARCHAR(500) - Descripción del producto.
    @PI_NPRECIO DECIMAL(18,2) - Precio del producto.
    @PI_NINVENTARIO INT - Cantidad de inventario disponible.
    @PI_CIMAGEN_URL NVARCHAR(MAX) - URL de la imagen del producto.
Salidas: N/A
Consideraciones: 
    - El producto debe existir en la base de datos para ser actualizado.
    - Si el producto no existe, se devuelve un mensaje de error.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Se actualizan los nombres de los parámetros y la tabla de productos.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para actualizar un producto
CREATE PROCEDURE [dbo].[SPR_UPD_ACTUALIZAR_PRODUCTO]
    @PI_NID INT,
    @PI_CNOMBRE NVARCHAR(100),
    @PI_CDESCRIPCION NVARCHAR(500),
    @PI_NPRECIO DECIMAL(18,2),
    @PI_NINVENTARIO INT,
    @PI_CIMAGEN_URL NVARCHAR(MAX)
AS
BEGIN
    -- Verificar que el producto existe
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_RPRODUCTOS WHERE PRO_NID = @PI_NID)
    BEGIN
        RAISERROR('El producto no existe.', 16, 1);
        RETURN;
    END

    -- Actualizar los detalles del producto
    UPDATE dbo.TBL_RPRODUCTOS
    SET PRO_CNOMBRE = @PI_CNOMBRE,
        PRO_CDESCRIPCION = @PI_CDESCRIPCION,
        PRO_NPRECIO = @PI_NPRECIO,
        PRO_NINVENTARIO = @PI_NINVENTARIO,
        PRO_CIMAGEN_URL = @PI_CIMAGEN_URL
    WHERE PRO_NID = @PI_NID;
END;
GO
