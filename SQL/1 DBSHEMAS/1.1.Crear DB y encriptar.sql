/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Creación de clave simétrica y certificado para encriptación de datos sensibles
Consideraciones: Esta clave y certificado se usarán para encriptar y desencriptar información sensible como el nombre de usuario.
Modificaciones:
Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

/* =============================================
   Paso 1: Crear la Base de Datos PRUEBA_USUARIOS (si no existe)
   ============================================= */
IF DB_ID('PRUEBA_USUARIOS') IS NULL
BEGIN
    CREATE DATABASE [PRUEBA_USUARIOS];
    PRINT 'Base de datos PRUEBA_USUARIOS creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La base de datos PRUEBA_USUARIOS ya existe.';
END
GO

/* =============================================
   Paso 2: Crear la Clave Maestra (Master Key)
   ============================================= */
USE [PRUEBA_USUARIOS];
GO

-- Verificar si la clave maestra ya existe
IF NOT EXISTS (
    SELECT * 
    FROM sys.symmetric_keys 
    WHERE name = '##MS_DatabaseMasterKey##'
)
BEGIN
    -- Crear la clave maestra con una contraseña fuerte
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'EncriptacionUsuarios';
    PRINT 'Clave Maestra (Master Key) creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La Clave Maestra (Master Key) ya existe en la base de datos PRUEBA_USUARIOS.';
END
GO

/* =============================================
   Paso 3: Crear el Certificado para Encriptación
   ============================================= */
USE [PRUEBA_USUARIOS];
GO

-- Verificar si el certificado ya existe
IF NOT EXISTS (
    SELECT * 
    FROM sys.certificates 
    WHERE name = 'CertificadoEncriptacion'
)
BEGIN
    CREATE CERTIFICATE CertificadoEncriptacion
       WITH SUBJECT = 'Certificado para encriptación de datos sensibles';
    PRINT 'Certificado CertificadoEncriptacion creado exitosamente.';
END
ELSE
BEGIN
    PRINT 'El certificado CertificadoEncriptacion ya existe en la base de datos PRUEBA_USUARIOS.';
END
GO

/* =============================================
   Paso 4: Crear la Clave Simétrica usando el Certificado
   ============================================= */
USE [PRUEBA_USUARIOS];
GO

-- Verificar si la clave simétrica ya existe
IF NOT EXISTS (
    SELECT * 
    FROM sys.symmetric_keys 
    WHERE name = 'ClaveEncriptacion'
)
BEGIN
    CREATE SYMMETRIC KEY ClaveEncriptacion
       WITH ALGORITHM = AES_256
       ENCRYPTION BY CERTIFICATE CertificadoEncriptacion;
    PRINT 'Clave Simétrica ClaveEncriptacion creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La Clave Simétrica ClaveEncriptacion ya existe en la base de datos PRUEBA_USUARIOS.';
END
GO

/* =============================================
   Paso 5: Verificar la Creación de Clave Maestra, Certificado y Clave Simétrica
   ============================================= */
USE [PRUEBA_USUARIOS];
GO

PRINT 'Verificación de objetos de encriptación:';

-- Verificar Clave Maestra
PRINT 'Clave Maestra (Master Key):';
SELECT 
    name AS [Nombre],
    algorithm_desc AS [Algoritmo],
    key_length AS [Longitud de la Clave]
FROM sys.symmetric_keys
WHERE name = '##MS_DatabaseMasterKey##';
GO

-- Verificar Certificado
PRINT 'Certificado Encriptacion:';
SELECT 
    name AS [Nombre],
    certificate_id AS [ID Certificado],
    subject AS [Asunto],
    expiry_date AS [Fecha de Expiración]
FROM sys.certificates
WHERE name = 'CertificadoEncriptacion';
GO

-- Verificar Clave Simétrica
PRINT 'Clave Simétrica ClaveEncriptacion:';
SELECT 
    name AS [Nombre],
    key_algorithm AS [Algoritmo],
    key_length AS [Longitud de la Clave]
FROM sys.symmetric_keys
WHERE name = 'ClaveEncriptacion';
GO
