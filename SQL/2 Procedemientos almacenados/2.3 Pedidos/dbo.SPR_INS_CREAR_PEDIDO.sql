USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Crear un nuevo pedido y asociar productos al mismo.
Entradas:
    @PI_NUSUARIO_ID INT - ID del usuario que realiza el pedido.
    @PT_PRODUCTOS TVP_TPRODUCTOS READONLY - Tabla de productos con sus cantidades.
Salidas: Pedido creado con productos asociados.
Consideraciones:
    - Verificar disponibilidad de inventario antes de realizar el pedido.
Modificaciones: N/A
-----------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPR_INS_CREAR_PEDIDO]
    @PI_NUSUARIO_ID INT,                   -- ID del usuario que realiza el pedido
    @PT_PRODUCTOS TVP_TPRODUCTOS READONLY  -- Tabla de productos con sus cantidades
AS
BEGIN
    -- Verificar que el UsuarioId exista en la base de datos UsuariosDB
    IF NOT EXISTS (SELECT 1 FROM PRUEBA_USUARIOS.dbo.TBL_RUSUARIOS WHERE USU_NID = @PI_NUSUARIO_ID)
    BEGIN
        RAISERROR('El UsuarioId no existe.', 16, 1);
        RETURN;
    END

    -- Obtener el nombre del usuario
    DECLARE @NOMBRE_USUARIO NVARCHAR(150);
    SELECT @NOMBRE_USUARIO = USU_CNOMBRE_COMPLETO 
    FROM PRUEBA_USUARIOS.dbo.TBL_RUSUARIOS
    WHERE USU_NID = @PI_NUSUARIO_ID;

    -- Calcular la cantidad total de productos y el valor total antes de insertar el pedido
    DECLARE @TOTAL_CANTIDAD INT = 0;
    DECLARE @VALOR_TOTAL DECIMAL(18,2) = 0;

    -- Verificar disponibilidad de inventario para los productos solicitados
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

    -- Calcular la cantidad total de productos y el valor total del pedido
    SELECT 
        @TOTAL_CANTIDAD = SUM(PEDPROD_NCANTIDAD),
        @VALOR_TOTAL = SUM(PEDPROD_NCANTIDAD * P.PRO_NPRECIO)
    FROM @PT_PRODUCTOS PP
    INNER JOIN dbo.TBL_RPRODUCTOS P ON PP.PRO_NID = P.PRO_NID;

    -- Insertar el nuevo pedido
    DECLARE @PEDIDO_ID INT;
    INSERT INTO dbo.TBL_TPEDIDOS (PED_NUSUARIO_ID, PED_NCANTIDAD, PED_DFECHA_PEDIDO, PED_NVALOR_TOTAL)
    VALUES (@PI_NUSUARIO_ID, @TOTAL_CANTIDAD, GETDATE(), @VALOR_TOTAL);

    -- Obtener el ID del pedido recién creado
    SET @PEDIDO_ID = SCOPE_IDENTITY();

    -- Insertar los productos asociados al pedido
    INSERT INTO dbo.TBL_TPEDIDO_PRODUCTOS (PED_NID, PRO_NID, PEDPROD_NCANTIDAD)
    SELECT @PEDIDO_ID, PRO_NID, PEDPROD_NCANTIDAD
    FROM @PT_PRODUCTOS;

    -- Actualizar el inventario de los productos
    UPDATE P
    SET P.PRO_NINVENTARIO = P.PRO_NINVENTARIO - PP.PEDPROD_NCANTIDAD
    FROM dbo.TBL_RPRODUCTOS P
    INNER JOIN @PT_PRODUCTOS PP ON P.PRO_NID = PP.PRO_NID;

    -- Retornar los detalles del pedido creado
    SELECT 
        @NOMBRE_USUARIO AS Usuario,
        @PEDIDO_ID AS PedidoId,
        @VALOR_TOTAL AS ValorTotal,
        @TOTAL_CANTIDAD AS TotalProductos,
        (SELECT PED_DFECHA_PEDIDO FROM dbo.TBL_TPEDIDOS WHERE PED_NID = @PEDIDO_ID) AS FechaPedido;
END;
GO
