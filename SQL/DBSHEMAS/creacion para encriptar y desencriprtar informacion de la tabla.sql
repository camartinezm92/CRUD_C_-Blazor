/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 17/09/2024
Propósito: Creación de clave simétrica y certificado para encriptación de datos sensibles
Consideraciones: Esta clave y certificado se usarán para encriptar y desencriptar información sensible como el nombre de usuario.
Modificaciones:
Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

/* Crear el certificado para encriptación */
USE [PRUEBA_USUARIOS]
GO

CREATE CERTIFICATE CertificadoEncriptacion
   WITH SUBJECT = 'Certificado para encriptación de datos sensibles';
GO

/* Crear la clave simétrica usando el certificado creado anteriormente */
CREATE SYMMETRIC KEY ClaveEncriptacion
   WITH ALGORITHM = AES_256
   ENCRYPTION BY CERTIFICATE CertificadoEncriptacion;
GO
