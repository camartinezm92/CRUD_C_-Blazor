USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Obtener los detalles de un pedido, incluyendo múltiples productos y calcular el valor total.
Entradas:
    @PI_NPEDIDO_ID INT - ID del pedido a consultar.
Salidas: Detalles del pedido, incluyendo los productos, cantidades y valor total.
Consideraciones:
    - Relación uno a muchos entre pedidos y productos.
Modificaciones:
    Fecha modificación: 19/09/2024 – Ajuste para incluir la cantidad total de productos.
    Fecha modificación: 25/09/2024 – Incluir el UsuarioId en la salida.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_PEDIDO_POR_ID]
    @PI_NPEDIDO_ID INT -- ID del pedido
AS
BEGIN
    -- Obtener los detalles del pedido, incluyendo productos y cantidades, y calcular la cantidad total de productos
    SELECT 
        P.PED_NID AS PedidoId,
        P.PED_NUSUARIO_ID AS UsuarioId, -- Agregamos el UsuarioId
        U.USU_CNOMBRE_COMPLETO AS Usuario,  -- Nombre del usuario que hizo el pedido
        PR.PRO_CNOMBRE AS Producto,  -- Nombre del producto
        PP.PRO_NID AS ProductoId,  -- ID del producto
        PP.PEDPROD_NCANTIDAD AS Cantidad,  -- Cantidad de este producto en el pedido
        PR.PRO_NPRECIO AS PrecioUnitario,  -- Precio unitario del producto
        (PP.PEDPROD_NCANTIDAD * PR.PRO_NPRECIO) AS ValorTotalPorProducto, -- Cálculo del valor total por producto
        P.PED_NVALOR_TOTAL AS ValorTotal, -- Valor total del pedido
        P.PED_DFECHA_PEDIDO AS FechaPedido, -- Fecha en que se hizo el pedido
        SUM(PP.PEDPROD_NCANTIDAD) OVER (PARTITION BY P.PED_NID) AS CantidadTotalProductos  -- Cantidad total de productos
    FROM 
        TBL_TPEDIDOS P
    INNER JOIN 
        PRUEBA_USUARIOS.dbo.TBL_RUSUARIOS U ON P.PED_NUSUARIO_ID = U.USU_NID  -- Relación con usuarios
    INNER JOIN 
        TBL_TPEDIDO_PRODUCTOS PP ON P.PED_NID = PP.PED_NID  -- Relación con la tabla intermedia
    INNER JOIN 
        TBL_RPRODUCTOS PR ON PP.PRO_NID = PR.PRO_NID  -- Relación con los productos
    WHERE 
        P.PED_NID = @PI_NPEDIDO_ID;
END;
GO
