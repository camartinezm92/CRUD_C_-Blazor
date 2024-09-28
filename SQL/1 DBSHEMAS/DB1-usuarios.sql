/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Creación de Base de datos Usuarios y tablas para manejo de usuarios
Consideraciones: Usuarios se deben encriptar y contraseña se almacenará en SHA256
Modificaciones:
Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

/* Creación de la base de datos */
USE [master]
GO

CREATE DATABASE [PRUEBA_USUARIOS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UsuariosDB', FILENAME = N'C:\SQLServer\UsuariosDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'UsuariosDB_log', FILENAME = N'C:\SQLServer\UsuariosDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

/* Uso de la base de datos recién creada */
USE [PRUEBA_USUARIOS]
GO

/* Creación de la tabla TBL_RROLES */
CREATE TABLE [dbo].[TBL_RROLES](
    [ROL_NID] [int] IDENTITY(1,1) NOT NULL,
     NOT NULL,
PRIMARY KEY CLUSTERED 
(
    [ROL_NID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Inserción de roles en la tabla TBL_RROLES */
INSERT INTO [dbo].[TBL_RROLES] ([ROL_CNOMBRE_ROL])
VALUES 
('Admin'),      -- ID = 1
('Empleado'),   -- ID = 2
('Cliente');    -- ID = 3
GO

/* Creación de la tabla TBL_RUSUARIOS */
CREATE TABLE [dbo].[TBL_RUSUARIOS](
    [USU_NID] [int] IDENTITY(1,1) NOT NULL,
     NOT NULL,  -- Usuario encriptado
     NOT NULL,  -- Nombre completo del usuario
     NOT NULL, -- Contraseña hasheada
    [USU_DCREACION] [datetime] NOT NULL,  -- Fecha de creación
    [USU_NROL_ID] [int] NOT NULL,  -- Relación con los roles
PRIMARY KEY CLUSTERED 
(
    [USU_NID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
    [USU_CUSUARIO] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Agregar la columna de fecha de creación por defecto */
ALTER TABLE [dbo].[TBL_RUSUARIOS] ADD CONSTRAINT [DF_USR_FechaCreacion] DEFAULT (getdate()) FOR [USU_DCREACION]
GO

/* Creación de la clave foránea entre TBL_RUSUARIOS y TBL_RROLES */
ALTER TABLE [dbo].[TBL_RUSUARIOS] WITH CHECK ADD CONSTRAINT FK_USUARIOS_ROLES FOREIGN KEY([USU_NROL_ID])
REFERENCES [dbo].[TBL_RROLES] ([ROL_NID])
GO

-- Confirmación de los roles insertados
SELECT * FROM [dbo].[TBL_RROLES];