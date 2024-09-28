USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Eliminar un pedido y restaurar el inventario de los productos asociados.
Entradas:
    @PI_NPEDIDO_ID INT - ID del pedido a eliminar.
Salidas: N/A
Consideraciones: 
    - Restaurar inventario de productos antes de eliminar el pedido y sus productos asociados.
    - Verificación de existencia del pedido antes de proceder con la eliminación.
Modificaciones:
    Fecha modificación: 26/09/2024 – Manejo de inventario al eliminar un pedido.
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_DEL_ELIMINAR_PEDIDO]
    @PI_NPEDIDO_ID INT -- ID del pedido a eliminar
AS
BEGIN
    -- Verificar que el pedido exista
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_TPEDIDOS WHERE PED_NID = @PI_NPEDIDO_ID)
    BEGIN
        RAISERROR('El Pedido no existe.', 16, 1);
        RETURN;
    END

    -- Restaurar el inventario de los productos asociados al pedido antes de eliminarlos
    UPDATE P
    SET P.PRO_NINVENTARIO = P.PRO_NINVENTARIO + PP.PEDPROD_NCANTIDAD
    FROM dbo.TBL_RPRODUCTOS P
    INNER JOIN dbo.TBL_TPEDIDO_PRODUCTOS PP ON P.PRO_NID = PP.PRO_NID
    WHERE PP.PED_NID = @PI_NPEDIDO_ID;

    -- Eliminar los productos asociados al pedido
    DELETE FROM dbo.TBL_TPEDIDO_PRODUCTOS WHERE PED_NID = @PI_NPEDIDO_ID;

    -- Eliminar el pedido
    DELETE FROM dbo.TBL_TPEDIDOS WHERE PED_NID = @PI_NPEDIDO_ID;

    -- Verificación final para asegurarse de que se eliminó el pedido
    IF NOT EXISTS (SELECT 1 FROM dbo.TBL_TPEDIDOS WHERE PED_NID = @PI_NPEDIDO_ID)
    BEGIN
        PRINT 'Pedido eliminado exitosamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El Pedido no pudo ser eliminado.', 16, 1);
    END
END;
GO
