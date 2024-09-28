USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Actualizar un pedido existente y los productos asociados al mismo.
Entradas:
    @PI_NPEDIDO_ID INT - ID del pedido a actualizar.
    @PI_NUSUARIO_ID INT - ID del usuario que realiza el pedido.
    @PT_PRODUCTOS TVP_TPRODUCTOS READONLY - Tabla de productos con sus cantidades a actualizar.
Salidas: Pedido actualizado con sus productos.
Consideraciones: 
    - Relación uno a muchos entre pedidos y productos.
    - Se actualiza el inventario al modificar el pedido.
Modificaciones:
    Fecha modificación: 26/09/2024 – Manejo de inventario al actualizar el pedido.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_UPD_ACTUALIZAR_PEDIDO]
    @PI_NPEDIDO_ID INT,                  -- ID del pedido
    @PI_NUSUARIO_ID INT,                 -- ID del usuario que realiza el pedido
    @PT_PRODUCTOS TVP_TPRODUCTOS READONLY -- Tabla de productos con sus cantidades (TVP)
AS
BEGIN
    -- Verificar que el pedido exista
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_TPEDIDOS WHERE PED_NID = @PI_NPEDIDO_ID)
    BEGIN
        RAISERROR('El Pedido no existe.', 16, 1);
        RETURN;
    END

    -- Verificar que el UsuarioId exista en la base de datos UsuariosDB
    IF NOT EXISTS (SELECT 1 FROM PRUEBA_USUARIOS.dbo.TBL_RUSUARIOS WHERE USU_NID = @PI_NUSUARIO_ID)
    BEGIN
        RAISERROR('El UsuarioId no existe.', 16, 1);
        RETURN;
    END

    -- Restaurar el inventario de los productos existentes asociados al pedido
    UPDATE P
    SET P.PRO_NINVENTARIO = P.PRO_NINVENTARIO + PP.PEDPROD_NCANTIDAD
    FROM dbo.TBL_RPRODUCTOS P
    INNER JOIN dbo.TBL_TPEDIDO_PRODUCTOS PP ON P.PRO_NID = PP.PRO_NID
    WHERE PP.PED_NID = @PI_NPEDIDO_ID;

    -- Eliminar los productos existentes asociados a este pedido
    DELETE FROM dbo.TBL_TPEDIDO_PRODUCTOS WHERE PED_NID = @PI_NPEDIDO_ID;

    -- Verificar disponibilidad de inventario para los nuevos productos solicitados
    IF EXISTS (
        SELECT 1
        FROM @PT_PRODUCTOS PP
        INNER JOIN dbo.TBL_RPRODUCTOS P ON PP.PRO_NID = P.PRO_NID
        WHERE P.PRO_NINVENTARIO < PP.PEDPROD_NCANTIDAD
    )
    BEGIN
        RAISERROR('No hay suficiente inventario para uno o más productos.', 16, 1);
        RETURN;
    END

    -- Insertar los nuevos productos asociados al pedido
    INSERT INTO dbo.TBL_TPEDIDO_PRODUCTOS (PED_NID, PRO_NID, PEDPROD_NCANTIDAD)
    SELECT @PI_NPEDIDO_ID, PRO_NID, PEDPROD_NCANTIDAD
    FROM @PT_PRODUCTOS;

    -- Actualizar el inventario de los productos
    UPDATE P
    SET P.PRO_NINVENTARIO = P.PRO_NINVENTARIO - PP.PEDPROD_NCANTIDAD
    FROM dbo.TBL_RPRODUCTOS P
    INNER JOIN @PT_PRODUCTOS PP ON P.PRO_NID = PP.PRO_NID;

    -- Calcular el nuevo valor total del pedido
    DECLARE @NuevoValorTotal DECIMAL(18,2);
    SELECT @NuevoValorTotal = SUM(PP.PEDPROD_NCANTIDAD * PR.PRO_NPRECIO)
    FROM dbo.TBL_TPEDIDO_PRODUCTOS PP
    INNER JOIN dbo.TBL_RPRODUCTOS PR ON PP.PRO_NID = PR.PRO_NID
    WHERE PP.PED_NID = @PI_NPEDIDO_ID;

    -- Actualizar el valor total en la tabla TBL_TPEDIDOS
    UPDATE dbo.TBL_TPEDIDOS
    SET PED_NVALOR_TOTAL = @NuevoValorTotal
    WHERE PED_NID = @PI_NPEDIDO_ID;

    -- Retornar los detalles del pedido actualizado
    SELECT 
        P.PED_NID AS PedidoId,
        U.USU_CNOMBRE_COMPLETO AS Usuario,
        SUM(PP.PEDPROD_NCANTIDAD) AS TotalProductos,
        P.PED_NVALOR_TOTAL AS ValorTotal,
        P.PED_DFECHA_PEDIDO AS FechaPedido
    FROM dbo.TBL_TPEDIDOS P
    INNER JOIN PRUEBA_USUARIOS.dbo.TBL_RUSUARIOS U ON P.PED_NUSUARIO_ID = U.USU_NID
    INNER JOIN dbo.TBL_TPEDIDO_PRODUCTOS PP ON P.PED_NID = PP.PED_NID
    WHERE P.PED_NID = @PI_NPEDIDO_ID
    GROUP BY P.PED_NID, U.USU_CNOMBRE_COMPLETO, P.PED_NVALOR_TOTAL, P.PED_DFECHA_PEDIDO;
END;
GO
