USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 18/09/2024
Propósito: Eliminar un producto específico de la base de datos.
Entradas:
    @PI_NID INT - ID del producto a eliminar.
Salidas: N/A
Consideraciones: 
    - El producto debe existir en la base de datos para ser eliminado.
    - Si el producto no existe, se devuelve un mensaje de error.
Modificaciones:
    Fecha modificación: 18/09/2024 – Camilo Martinez
    Cambio realizado: Se actualizan los nombres de los parámetros y la tabla de productos.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_DEL_ELIMINAR_PRODUCTO]
    @PI_NID INT
AS
BEGIN
    -- Verificar que el producto existe
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_RPRODUCTOS WHERE PRO_NID = @PI_NID)
    BEGIN
        RAISERROR('El producto no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar el producto
    DELETE FROM dbo.TBL_RPRODUCTOS WHERE PRO_NID = @PI_NID;
END;
GO
