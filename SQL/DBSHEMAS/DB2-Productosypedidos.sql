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

CREATE DATABASE [PRUEBA_PRODUCTOS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ProductosDB', FILENAME = N'C:\SQLServer\ProductosDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ProductosDB_log', FILENAME = N'C:\SQLServer\ProductosDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

/* Creación de la tabla TBL_RPRODUCTOS */
USE [PRUEBA_PRODUCTOS]
GO

CREATE TABLE [dbo].[TBL_RPRODUCTOS](
    [PRO_NID] [int] IDENTITY(1,1) NOT NULL,
      NOT NULL,
     NULL,
    [PRO_NPRECIO] [decimal](18, 2) NOT NULL,
    [PRO_NINVENTARIO] [int] NOT NULL,
    [PRO_CIMAGEN_URL] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
    [PRO_NID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_PRO_CNOMBRE] UNIQUE NONCLUSTERED 
(
    [PRO_CNOMBRE] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Restricciones CHECK para el inventario y el precio */
ALTER TABLE [dbo].[TBL_RPRODUCTOS] ADD  CONSTRAINT [CK_PRO_NINVENTARIO] CHECK  (([PRO_NINVENTARIO] >= 0))
GO

ALTER TABLE [dbo].[TBL_RPRODUCTOS] ADD  CONSTRAINT [CK_PRO_NPRECIO] CHECK  (([PRO_NPRECIO] >= 0))
GO

/* Creación de la tabla TBL_TPEDIDOS */
USE [PRUEBA_PRODUCTOS]
GO

CREATE TABLE [dbo].[TBL_TPEDIDOS](
    [PED_NID] [int] IDENTITY(1,1) NOT NULL,
    [PED_NUSUARIO_ID] [int] NOT NULL,
    [PED_NCANTIDAD] [int] NOT NULL,
    [PED_DFECHA_PEDIDO] [datetime] NOT NULL,
    [PED_NVALOR_TOTAL] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
    [PED_NID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Agregar la columna de fecha de pedido por defecto */
ALTER TABLE [dbo].[TBL_TPEDIDOS] ADD  CONSTRAINT [DF_PEDIDOS_FECHA_PEDIDO]  DEFAULT (getdate()) FOR [PED_DFECHA_PEDIDO]
GO

/* Creación de la tabla TBL_TPEDIDO_PRODUCTOS */
USE [PRUEBA_PRODUCTOS]
GO

CREATE TABLE [dbo].[TBL_TPEDIDO_PRODUCTOS](
    [PEDPROD_NID] [int] IDENTITY(1,1) NOT NULL,
    [PED_NID] [int] NOT NULL,
    [PRO_NID] [int] NOT NULL,
    [PEDPROD_NCANTIDAD] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
    [PEDPROD_NID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Claves foráneas para la tabla TBL_TPEDIDO_PRODUCTOS */
ALTER TABLE [dbo].[TBL_TPEDIDO_PRODUCTOS]  WITH CHECK ADD FOREIGN KEY([PED_NID])
REFERENCES [dbo].[TBL_TPEDIDOS] ([PED_NID])
GO

ALTER TABLE [dbo].[TBL_TPEDIDO_PRODUCTOS]  WITH CHECK ADD FOREIGN KEY([PRO_NID])
REFERENCES [dbo].[TBL_RPRODUCTOS] ([PRO_NID])
GO

/* Creación del tipo de tabla TVP_TPRODUCTOS para procedimientos almacenados */
CREATE TYPE TVP_TPRODUCTOS AS TABLE
(
    PRO_NID INT,           -- ID del producto
    PEDPROD_NCANTIDAD INT  -- Cantidad del producto
);
GO
