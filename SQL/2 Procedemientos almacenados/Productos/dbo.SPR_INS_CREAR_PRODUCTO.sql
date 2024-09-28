USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 14/09/2024
Propósito: Procedimiento almacenado para insertar un nuevo producto.
Entradas:
    @PI_CNOMBRE NVARCHAR(100) - Nombre del producto.
    @PI_CDESCRIPCION NVARCHAR(500) - Descripción del producto.
    @PI_NPRECIO DECIMAL(18,2) - Precio del producto.
    @PI_NINVENTARIO INT - Cantidad en inventario.
    @PI_CIMAGEN_URL NVARCHAR(MAX) - URL de la imagen del producto (opcional).
Salidas: N/A
Consideraciones:
    - Se permite almacenar la imagen en formato URL. Si no se proporciona, puede quedar como NULL.
Modificaciones:
    Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para crear un nuevo producto
CREATE PROCEDURE [dbo].[SPR_INS_CREAR_PRODUCTO]
    @PI_CNOMBRE NVARCHAR(100),
    @PI_CDESCRIPCION NVARCHAR(500),
    @PI_NPRECIO DECIMAL(18,2),
    @PI_NINVENTARIO INT,
    @PI_CIMAGEN_URL NVARCHAR(MAX) = NULL  -- URL opcional
AS
BEGIN
    -- Insertar el nuevo producto
    INSERT INTO dbo.TBL_RPRODUCTOS (PRO_CNOMBRE, PRO_CDESCRIPCION, PRO_NPRECIO, PRO_NINVENTARIO, PRO_CIMAGEN_URL)
    VALUES (@PI_CNOMBRE, @PI_CDESCRIPCION, @PI_NPRECIO, @PI_NINVENTARIO, @PI_CIMAGEN_URL);
END;
GO
