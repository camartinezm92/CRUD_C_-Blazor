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
-- =============================================
-- Script para crear la base de datos PRUEBA_USUARIOS,
-- las tablas TBL_RROLES y TBL_RUSUARIOS,
-- establecer relaciones y insertar datos iniciales.
-- =============================================


-- =============================================
-- Paso 1: Crear la Tabla TBL_RROLES
-- =============================================
USE [PRUEBA_USUARIOS];
GO

IF OBJECT_ID('dbo.TBL_RROLES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TBL_RROLES](
        [ROL_NID] INT IDENTITY(1,1) NOT NULL,
        [ROL_CNOMBRE_ROL] NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_TBL_RROLES PRIMARY KEY CLUSTERED ([ROL_NID] ASC)
    );
    PRINT 'Tabla TBL_RROLES creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla TBL_RROLES ya existe.';
END
GO

-- =============================================
-- Paso 2: Insertar Datos Iniciales en TBL_RROLES
-- =============================================
USE [PRUEBA_USUARIOS];
GO

IF NOT EXISTS (
    SELECT 1 
    FROM [dbo].[TBL_RROLES] 
    WHERE [ROL_CNOMBRE_ROL] IN ('Admin', 'Empleado', 'Cliente')
)
BEGIN
    INSERT INTO [dbo].[TBL_RROLES] ([ROL_CNOMBRE_ROL])
    VALUES 
        ('Admin'),      -- ID = 1
        ('Empleado'),   -- ID = 2
        ('Cliente');    -- ID = 3
    PRINT 'Roles insertados exitosamente en TBL_RROLES.';
END
ELSE
BEGIN
    PRINT 'Los roles ya existen en TBL_RROLES.';
END
GO

-- =============================================
-- Paso 3: Crear la Tabla TBL_RUSUARIOS
-- =============================================
USE [PRUEBA_USUARIOS];
GO

IF OBJECT_ID('dbo.TBL_RUSUARIOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TBL_RUSUARIOS](
        [USU_NID] INT IDENTITY(1,1) NOT NULL,
        [USU_CUSUARIO] NVARCHAR(50) NOT NULL,
        [USU_CNOMBRE_COMPLETO] NVARCHAR(100) NOT NULL,
        [USU_CPASSWORD] NVARCHAR(256) NOT NULL,
        [USU_DCREACION] DATETIME NOT NULL DEFAULT (GETDATE()),
        [USU_NROL_ID] INT NOT NULL,
        CONSTRAINT PK_TBL_RUSUARIOS PRIMARY KEY CLUSTERED ([USU_NID] ASC),
        CONSTRAINT UQ_TBL_RUSUARIOS_USUARIO UNIQUE NONCLUSTERED ([USU_CUSUARIO] ASC)
    );
    PRINT 'Tabla TBL_RUSUARIOS creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla TBL_RUSUARIOS ya existe.';
END
GO

-- =============================================
-- Paso 4: Crear la Clave Foránea entre TBL_RUSUARIOS y TBL_RROLES
-- =============================================
USE [PRUEBA_USUARIOS];
GO

IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_USUARIOS_ROLES'
)
BEGIN
    ALTER TABLE [dbo].[TBL_RUSUARIOS] 
    ADD CONSTRAINT FK_USUARIOS_ROLES 
    FOREIGN KEY ([USU_NROL_ID])
    REFERENCES [dbo].[TBL_RROLES] ([ROL_NID]);
    PRINT 'Clave foránea FK_USUARIOS_ROLES creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La clave foránea FK_USUARIOS_ROLES ya existe.';
END
GO



-- =============================================
-- Paso 5: Verificar la Inserción de Roles e impereison de tabla Usuarios
-- =============================================
USE [PRUEBA_USUARIOS];
GO

PRINT 'Contenido de TBL_RROLES:';
SELECT * FROM [dbo].[TBL_RROLES];
GO

PRINT 'Contenido de TBL_RUSUARIOS:';
SELECT 
    [USU_NID],
    [USU_CUSUARIO],
    [USU_CNOMBRE_COMPLETO],
    -- Convertir el hash a hexadecimal para visualizarlo como cadena
    CONVERT(VARCHAR(512), [USU_CPASSWORD], 2) AS [USU_CPASSWORD_HASH],
    [USU_DCREACION],
    [USU_NROL_ID]
FROM [dbo].[TBL_RUSUARIOS];
GO
