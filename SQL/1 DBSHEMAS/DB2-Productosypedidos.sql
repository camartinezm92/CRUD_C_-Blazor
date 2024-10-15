/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Creación de Base de datos Productos y Pedidos, con tablas para manejo de productos, pedidos y la relación entre ellos.
Consideraciones: Se crea un tipo de tabla TVP_TPRODUCTOS para procedimientos almacenados relacionados con pedidos y productos.
Modificaciones:
Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

/* Creación de la base de datos */
USE [master]
GO

/* =============================================
   Paso 1: Crear la Base de Datos PRUEBA_PRODUCTOS
   ============================================= */
IF DB_ID('PRUEBA_PRODUCTOS') IS NULL
BEGIN
    CREATE DATABASE [PRUEBA_PRODUCTOS];
    PRINT 'Base de datos PRUEBA_PRODUCTOS creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La base de datos PRUEBA_PRODUCTOS ya existe.';
END
GO

/* =============================================
   Paso 2: Crear la Tabla TBL_RPRODUCTOS
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

IF OBJECT_ID('dbo.TBL_RPRODUCTOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TBL_RPRODUCTOS](
        [PRO_NID] INT IDENTITY(1,1) NOT NULL,
        [PRO_CNOMBRE] NVARCHAR(100) NOT NULL,           -- Nombre del producto
        [PRO_CDESCRIPCION] NVARCHAR(255) NULL,         -- Descripción del producto
        [PRO_NPRECIO] DECIMAL(18, 2) NOT NULL,          -- Precio del producto
        [PRO_NINVENTARIO] INT NOT NULL,                 -- Cantidad en inventario
        [PRO_CIMAGEN_URL] NVARCHAR(MAX) NULL,           -- URL de la imagen del producto
        CONSTRAINT PK_TBL_RPRODUCTOS PRIMARY KEY CLUSTERED ([PRO_NID] ASC),
        CONSTRAINT UQ_PRO_CNOMBRE UNIQUE NONCLUSTERED ([PRO_CNOMBRE] ASC)
    );
    PRINT 'Tabla TBL_RPRODUCTOS creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla TBL_RPRODUCTOS ya existe.';
END
GO

/* =============================================
   Paso 3: Agregar Restricciones CHECK a TBL_RPRODUCTOS
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

-- Restricción CHECK para INVENTARIO >= 0
IF NOT EXISTS (
    SELECT 1 
    FROM sys.check_constraints 
    WHERE name = 'CK_PRO_NINVENTARIO' 
      AND parent_object_id = OBJECT_ID('dbo.TBL_RPRODUCTOS')
)
BEGIN
    ALTER TABLE [dbo].[TBL_RPRODUCTOS] 
    ADD CONSTRAINT [CK_PRO_NINVENTARIO] CHECK ([PRO_NINVENTARIO] >= 0);
    PRINT 'Restricción CHECK CK_PRO_NINVENTARIO agregada exitosamente a TBL_RPRODUCTOS.';
END
ELSE
BEGIN
    PRINT 'La restricción CHECK CK_PRO_NINVENTARIO ya existe en TBL_RPRODUCTOS.';
END
GO

-- Restricción CHECK para PRECIO >= 0
IF NOT EXISTS (
    SELECT 1 
    FROM sys.check_constraints 
    WHERE name = 'CK_PRO_NPRECIO' 
      AND parent_object_id = OBJECT_ID('dbo.TBL_RPRODUCTOS')
)
BEGIN
    ALTER TABLE [dbo].[TBL_RPRODUCTOS] 
    ADD CONSTRAINT [CK_PRO_NPRECIO] CHECK ([PRO_NPRECIO] >= 0);
    PRINT 'Restricción CHECK CK_PRO_NPRECIO agregada exitosamente a TBL_RPRODUCTOS.';
END
ELSE
BEGIN
    PRINT 'La restricción CHECK CK_PRO_NPRECIO ya existe en TBL_RPRODUCTOS.';
END
GO

/* =============================================
   Paso 4: Crear la Tabla TBL_TPEDIDOS
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

IF OBJECT_ID('dbo.TBL_TPEDIDOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TBL_TPEDIDOS](
        [PED_NID] INT IDENTITY(1,1) NOT NULL,
        [PED_NUSUARIO_ID] INT NOT NULL,                 -- ID del usuario que realiza el pedido
        [PED_NCANTIDAD] INT NOT NULL,                   -- Cantidad de productos en el pedido
        [PED_DFECHA_PEDIDO] DATETIME NOT NULL DEFAULT (GETDATE()), -- Fecha del pedido
        [PED_NVALOR_TOTAL] DECIMAL(18, 2) NULL,         -- Valor total del pedido
        CONSTRAINT PK_TBL_TPEDIDOS PRIMARY KEY CLUSTERED ([PED_NID] ASC)
    );
    PRINT 'Tabla TBL_TPEDIDOS creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla TBL_TPEDIDOS ya existe.';
END
GO

/* =============================================
   Paso 5: Crear la Tabla TBL_TPEDIDO_PRODUCTOS
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

IF OBJECT_ID('dbo.TBL_TPEDIDO_PRODUCTOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TBL_TPEDIDO_PRODUCTOS](
        [PEDPROD_NID] INT IDENTITY(1,1) NOT NULL,
        [PED_NID] INT NOT NULL,                         -- ID del pedido
        [PRO_NID] INT NOT NULL,                         -- ID del producto
        [PEDPROD_NCANTIDAD] INT NOT NULL,               -- Cantidad del producto en el pedido
        CONSTRAINT PK_TBL_TPEDIDO_PRODUCTOS PRIMARY KEY CLUSTERED ([PEDPROD_NID] ASC)
    );
    PRINT 'Tabla TBL_TPEDIDO_PRODUCTOS creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla TBL_TPEDIDO_PRODUCTOS ya existe.';
END
GO

/* =============================================
   Paso 6: Crear las Claves Foráneas en TBL_TPEDIDO_PRODUCTOS
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

-- Clave foránea para PED_NID referenciando TBL_TPEDIDOS
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_TPEDIDO_PRODUCTOS_PEDIDOS' 
      AND parent_object_id = OBJECT_ID('dbo.TBL_TPEDIDO_PRODUCTOS')
)
BEGIN
    ALTER TABLE [dbo].[TBL_TPEDIDO_PRODUCTOS] 
    ADD CONSTRAINT FK_TPEDIDO_PRODUCTOS_PEDIDOS 
    FOREIGN KEY ([PED_NID])
    REFERENCES [dbo].[TBL_TPEDIDOS] ([PED_NID]);
    PRINT 'Clave foránea FK_TPEDIDO_PRODUCTOS_PEDIDOS agregada exitosamente a TBL_TPEDIDO_PRODUCTOS.';
END
ELSE
BEGIN
    PRINT 'La clave foránea FK_TPEDIDO_PRODUCTOS_PEDIDOS ya existe en TBL_TPEDIDO_PRODUCTOS.';
END
GO

-- Clave foránea para PRO_NID referenciando TBL_RPRODUCTOS
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_TPEDIDO_PRODUCTOS_PRODUCTOS' 
      AND parent_object_id = OBJECT_ID('dbo.TBL_TPEDIDO_PRODUCTOS')
)
BEGIN
    ALTER TABLE [dbo].[TBL_TPEDIDO_PRODUCTOS] 
    ADD CONSTRAINT FK_TPEDIDO_PRODUCTOS_PRODUCTOS 
    FOREIGN KEY ([PRO_NID])
    REFERENCES [dbo].[TBL_RPRODUCTOS] ([PRO_NID]);
    PRINT 'Clave foránea FK_TPEDIDO_PRODUCTOS_PRODUCTOS agregada exitosamente a TBL_TPEDIDO_PRODUCTOS.';
END
ELSE
BEGIN
    PRINT 'La clave foránea FK_TPEDIDO_PRODUCTOS_PRODUCTOS ya existe en TBL_TPEDIDO_PRODUCTOS.';
END
GO

/* =============================================
   Paso 7: Crear el Tipo de Tabla TVP_TPRODUCTOS
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

IF TYPE_ID('TVP_TPRODUCTOS') IS NULL
BEGIN
    CREATE TYPE TVP_TPRODUCTOS AS TABLE
    (
        PRO_NID INT,           -- ID del producto
        PEDPROD_NCANTIDAD INT  -- Cantidad del producto
    );
    PRINT 'Tipo de tabla TVP_TPRODUCTOS creado exitosamente.';
END
ELSE
BEGIN
    PRINT 'El tipo de tabla TVP_TPRODUCTOS ya existe.';
END
GO

/* =============================================
   Paso 8: Verificar la Creación de Tablas y Relaciones
   ============================================= */
USE [PRUEBA_PRODUCTOS];
GO

PRINT 'Contenido de TBL_RPRODUCTOS:';
SELECT 
    [PRO_NID],
    [PRO_CNOMBRE],
    [PRO_CDESCRIPCION],
    [PRO_NPRECIO],
    [PRO_NINVENTARIO],
    [PRO_CIMAGEN_URL]
FROM [dbo].[TBL_RPRODUCTOS];
GO

PRINT 'Contenido de TBL_TPEDIDOS:';
SELECT 
    [PED_NID],
    [PED_NUSUARIO_ID],
    [PED_NCANTIDAD],
    [PED_DFECHA_PEDIDO],
    [PED_NVALOR_TOTAL]
FROM [dbo].[TBL_TPEDIDOS];
GO

PRINT 'Contenido de TBL_TPEDIDO_PRODUCTOS:';
SELECT 
    [PEDPROD_NID],
    [PED_NID],
    [PRO_NID],
    [PEDPROD_NCANTIDAD]
FROM [dbo].[TBL_TPEDIDO_PRODUCTOS];
GO

PRINT 'Tipo de Tabla TVP_TPRODUCTOS:';
SELECT 
    name, 
    type_name(user_type_id) AS TypeName
FROM sys.types
WHERE name = 'TVP_TPRODUCTOS';
GO
