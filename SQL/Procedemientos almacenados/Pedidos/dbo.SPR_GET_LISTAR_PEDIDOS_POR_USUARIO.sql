USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 25/09/2024
Propósito: Listar los pedidos filtrados por el ID del usuario, con la cantidad total de productos y el costo total del pedido.
Entradas:
    @PI_NUSUARIO_ID INT - ID del usuario para filtrar los pedidos.
Salidas: Listado de pedidos asociados al usuario con la cantidad total de productos y costo total.
Consideraciones:
    - Mostrar el resumen de cada pedido realizado por el usuario.
Modificaciones: N/A
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_GET_LISTAR_PEDIDOS_POR_USUARIO]
    @PI_NUSUARIO_ID INT -- ID del usuario
AS
BEGIN
    -- Seleccionar el resumen de los pedidos filtrados por el ID del usuario
    SELECT 
        P.PED_NID AS PedidoId,
        U.USU_CNOMBRE_COMPLETO AS Usuario,
        SUM(PP.PEDPROD_NCANTIDAD) AS CantidadTotalProductos,  -- Cantidad total de productos en el pedido
        SUM(PP.PEDPROD_NCANTIDAD * PR.PRO_NPRECIO) AS CostoTotal,  -- Cálculo del costo total del pedido
        P.PED_DFECHA_PEDIDO AS FechaPedido
    FROM 
        dbo.TBL_TPEDIDOS P
    INNER JOIN 
        PRUEBA_USUARIOS.dbo.TBL_RUSUARIOS U ON P.PED_NUSUARIO_ID = U.USU_NID  -- Relación con usuarios
    INNER JOIN 
        dbo.TBL_TPEDIDO_PRODUCTOS PP ON P.PED_NID = PP.PED_NID  -- Relación con la tabla intermedia
    INNER JOIN 
        dbo.TBL_RPRODUCTOS PR ON PP.PRO_NID = PR.PRO_NID  -- Relación con productos
    WHERE 
        P.PED_NUSUARIO_ID = @PI_NUSUARIO_ID  -- Filtrar los pedidos por el ID del usuario
    GROUP BY 
        P.PED_NID, U.USU_CNOMBRE_COMPLETO, P.PED_DFECHA_PEDIDO;
END;
GO
