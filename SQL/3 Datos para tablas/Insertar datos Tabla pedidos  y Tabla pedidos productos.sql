-- Reiniciar los valores de ID en las tablas relacionadas
DBCC CHECKIDENT ('dbo.TBL_TPEDIDO_PRODUCTOS', RESEED, 0);
DBCC CHECKIDENT ('dbo.TBL_TPEDIDOS', RESEED, 0);

-- Inserción de pedidos y productos en la tabla de TBL_TPEDIDOS y TBL_TPEDIDO_PRODUCTOS
-- Autor: Camilo Martínez
-- Fecha: 17/09/2024
-- Propósito: Insertar datos ficticios en las tablas de pedidos y productos pedidos
-- Notas: Los productos seleccionados corresponden a la tabla TBL_RPRODUCTOS actualizada.

-- Inserción de 30 pedidos en la tabla TBL_TPEDIDOS con PED_NCANTIDAD correctamente calculado
-- Cada pedido tiene al menos 2 productos asociados
INSERT INTO [dbo].[TBL_TPEDIDOS] (PED_NUSUARIO_ID, PED_DFECHA_PEDIDO, PED_NCANTIDAD, PED_NVALOR_TOTAL)
VALUES
-- Pedido 1
(1, GETDATE(), 3, 450000 + 300000),  -- Usuario 1 con dos productos
-- Pedido 2
(2, GETDATE(), 3, 1100000 + 1500000), -- Usuario 2 con dos productos
-- Pedido 3
(3, GETDATE(), 3, 2000000 + 1000000), -- Usuario 3 con dos productos
-- Pedido 4
(4, GETDATE(), 2, 600000 + 3000000), -- Usuario 4 con dos productos
-- Pedido 5
(5, GETDATE(), 3, 1800000 + 350000), -- Usuario 5 con dos productos
-- Pedido 6
(6, GETDATE(), 3, 2800000 + 400000), -- Usuario 6 con dos productos
-- Pedido 7
(7, GETDATE(), 3, 2500000 + 1200000), -- Usuario 7 con dos productos
-- Pedido 8
(8, GETDATE(), 3, 1300000 + 350000), -- Usuario 8 con dos productos
-- Pedido 9
(9, GETDATE(), 3, 900000 + 200000), -- Usuario 9 con dos productos
-- Pedido 10
(10, GETDATE(), 3, 800000 + 500000), -- Usuario 10 con dos productos
-- Pedido 11
(11, GETDATE(), 3, 1100000 + 1300000), -- Usuario 11 con dos productos
-- Pedido 12
(12, GETDATE(), 3, 400000 + 3000000), -- Usuario 12 con dos productos
-- Pedido 13
(13, GETDATE(), 3, 1800000 + 800000), -- Usuario 13 con dos productos
-- Pedido 14
(14, GETDATE(), 3, 1500000 + 200000), -- Usuario 14 con dos productos
-- Pedido 15
(15, GETDATE(), 3, 250000 + 1200000), -- Usuario 15 con dos productos
-- Pedido 16
(16, GETDATE(), 3, 300000 + 900000), -- Usuario 16 con dos productos
-- Pedido 17
(17, GETDATE(), 3, 600000 + 2900000), -- Usuario 17 con dos productos
-- Pedido 18
(18, GETDATE(), 3, 300000 + 2000000), -- Usuario 18 con dos productos
-- Pedido 19
(19, GETDATE(), 3, 1000000 + 800000), -- Usuario 19 con dos productos
-- Pedido 20
(20, GETDATE(), 3, 1300000 + 1200000), -- Usuario 20 con dos productos
-- Pedido 21
(21, GETDATE(), 3, 350000 + 2900000), -- Usuario 21 con dos productos
-- Pedido 22
(22, GETDATE(), 3, 1500000 + 350000), -- Usuario 22 con dos productos
-- Pedido 23
(23, GETDATE(), 3, 2200000 + 350000), -- Usuario 23 con dos productos
-- Pedido 24
(24, GETDATE(), 3, 1200000 + 350000), -- Usuario 24 con dos productos
-- Pedido 25
(25, GETDATE(), 3, 2500000 + 400000), -- Usuario 25 con dos productos
-- Pedido 26
(26, GETDATE(), 3, 1800000 + 500000), -- Usuario 26 con dos productos
-- Pedido 27
(27, GETDATE(), 3, 1100000 + 300000), -- Usuario 27 con dos productos
-- Pedido 28
(28, GETDATE(), 3, 400000 + 1000000), -- Usuario 28 con dos productos
-- Pedido 29
(29, GETDATE(), 3, 350000 + 600000), -- Usuario 29 con dos productos
-- Pedido 30
(30, GETDATE(), 3, 1200000 + 2800000); -- Usuario 30 con dos productos

-- Insertar los productos asociados a cada pedido en la tabla TBL_TPEDIDO_PRODUCTOS
-- Relacionar correctamente los pedidos con los productos
INSERT INTO [dbo].[TBL_TPEDIDO_PRODUCTOS] (PED_NID, PRO_NID, PEDPROD_NCANTIDAD)
VALUES
-- Pedido 1
(1, 1, 1), (1, 5, 2),
-- Pedido 2
(2, 6, 1), (2, 2, 1),
-- Pedido 3
(3, 3, 2), (3, 4, 1),
-- Pedido 4
(4, 9, 1), (4, 7, 1),
-- Pedido 5
(5, 10, 1), (5, 11, 2),
-- Pedido 6
(6, 12, 1), (6, 13, 1),
-- Pedido 7
(7, 14, 1), (7, 15, 1),
-- Pedido 8
(8, 16, 1), (8, 17, 2),
-- Pedido 9
(9, 18, 2), (9, 19, 1),
-- Pedido 10
(10, 20, 1), (10, 21, 1),
-- Pedido 11
(11, 22, 2), (11, 23, 1),
-- Pedido 12
(12, 24, 1), (12, 25, 2),
-- Pedido 13
(13, 5, 1), (13, 7, 1),
-- Pedido 14
(14, 9, 1), (14, 11, 1),
-- Pedido 15
(15, 13, 2), (15, 15, 1),
-- Pedido 16
(16, 17, 1), (16, 18, 1),
-- Pedido 17
(17, 19, 2), (17, 20, 1),
-- Pedido 18
(18, 21, 1), (18, 22, 2),
-- Pedido 19
(19, 23, 1), (19, 24, 1),
-- Pedido 20
(20, 25, 2), (20, 1, 1),
-- Pedido 21
(21, 2, 2), (21, 3, 1),
-- Pedido 22
(22, 4, 1), (22, 5, 2),
-- Pedido 23
(23, 6, 1), (23, 7, 1),
-- Pedido 24
(24, 8, 2), (24, 9, 1),
-- Pedido 25
(25, 10, 1), (25, 11, 1),
-- Pedido 26
(26, 12, 1), (26, 13, 2),
-- Pedido 27
(27, 14, 1), (27, 15, 1),
-- Pedido 28
(28, 16, 2), (28, 17, 1),
-- Pedido 29
(29, 18, 1), (29, 19, 1),
-- Pedido 30
(30, 20, 1), (30, 21, 2);
