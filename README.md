
# CRUD en C# y Blazor

Este proyecto consiste en el desarrollo de un CRUD utilizando **C#** como backend API y **Blazor** como frontend, junto con **SQL Server** y procedimientos almacenados.

## Descripción

La aplicación es una plataforma de gestión que utiliza **SQL Server** para la base de datos, **ASP.NET Core API** para el backend y **Blazor** para el frontend. Está diseñada con **Bootstrap** y **CSS** personalizados para la interfaz de usuario.

## Cómo Instalar y Ejecutar el Proyecto

### video de instalacion y demostración de funcionamiento : 
 **https://1drv.ms/v/c/6e09eb5971b6ae2c/EXUiTVEAkalBq33VjFdSOhgBAO35GPujTSyAAKpvJ9lOcA?e=9KAymf**

### 0. Clonar el Repositorio

Clona el repositorio utilizando el siguiente comando:

```bash
git clone https://github.com/camartinezm92/CRUD_C_-Blazor.git
```

### 1. Configuración de la Base de Datos e Instalación del Proyecto

#### **Carpeta SQL**

1. **Creación de las Bases de Datos**:
   - Usa SQL Server y autentícate en la base de datos `master`.
   - Una vez autenticado, genera una nueva consulta y ejecuta los scripts de las bases de datos proporcionados en la carpeta `DBSHEMAS` en el orden de numeración dentro de esta.

2. **Procedimientos Almacenados**:
   - Ejecuta cada uno de los procedimientos almacenados de usuario ubicados en la carpeta `2 Procedimientos Almacenados`, siguiendo la numeración de las carpetas dentro de esta.

3. **Implementación de Datos de Prueba en las Tablas**:
   - Ejecuta una a una las consultas SQL de la carpeta `3 Datos de Pruebas` para ingresar la data de pruebas en las tablas dentro de la carpeta `Datos para Tablas`.

#### **Carpeta TiendaWebAPI**

4. **Configuración y Ejecución del Backend**:
   - Abre la carpeta `TiendaWebAPI` en tu editor de código.
   - Ajusta el archivo `appsettings.json` con los datos de conexión a tu SQL Server.
   - Ejecuta el proyecto utilizando Visual Studio o el comando `dotnet run`.

5. **Pruebas del Sistema**:
   - Para probar la API, usa **Swagger** desde la web que se abre o **Postman** utilizando el archivo JSON que se encuentra en el repositorio.
   - Valida la conexión a la base de datos y prueba los diferentes endpoints.

6. **Login y Autorización**:
   - Para acceder a los endpoints protegidos, autentícate usando `/api/Auth/login` con las siguientes credenciales:
     - **Admin**:
       - Usuario: `admin`
       - Contraseña: `admin123`

#### **Carpeta TiendaDePrueba**

7. **Ejecución del Proyecto Frontend**:
   - Abre la carpeta `TiendaDePrueba` en tu editor de código.
   - Ejecuta la aplicación. El sistema redirigirá a la página de inicio, desde donde puedes empezar a realizar pruebas del programa.
   - **Nota**: Para validar estas pruebas, debes tener el backend en ejecución en paralelo.

## Estructura de la Aplicación

- **Bases de Datos**:
  - 2 bases de datos: `Usuarios` y `ProductosPedidos`.
  
- **Backend Independiente**:
  - Maneja solicitudes HTTP y HTTPS.
  
- **Frontend en Blazor**:
  - Incluye `Bootstrap.min` y estilos CSS personalizados.

## Endpoints Disponibles

### Login

- `POST /login`: Autenticación de usuarios.

### Usuarios

- `GET /usuarios`: Listar todos los usuarios.
- `GET /usuarios/{id}`: Obtener usuario por ID.
- `POST /usuarios`: Crear un nuevo usuario.
- `PUT /usuarios/{id}`: Actualizar usuario.
- `DELETE /usuarios/{id}`: Eliminar usuario.

### Productos

- `GET /productos`: Listar todos los productos.
- `GET /productos/{id}`: Obtener producto por ID.
- `POST /productos`: Crear un nuevo producto.
- `PUT /productos/{id}`: Actualizar producto.
- `DELETE /productos/{id}`: Eliminar producto.

### Pedidos

- `GET /pedidos`: Listar todos los pedidos.
- `GET /pedidos/{id}`: Obtener pedido por ID.
- `GET /pedidos/usuario/{idUsuario}`: Listar pedidos por usuario.
- `POST /pedidos`: Crear un nuevo pedido.
- `PUT /pedidos/{id}`: Actualizar pedido.
- `DELETE /pedidos/{id}`: Eliminar pedido.

## Detalles de la Implementación

### SQL Server

Para la base de datos se utilizó la guía de estándares de Luis Ernesto Marino, donde se establecieron las siguientes convenciones:

- Nomenclatura estandarizada según el tipo de tabla.
- Uso de **procedimientos almacenados** para manejar las peticiones SQL, previniendo inyecciones SQL.
- Encriptación del campo nombre de usuario y uso de **SHA256** para el cifrado de contraseñas.

### Backend en C#

Se estableció una estructura de carpetas en el backend que incluye:

- **Data**: Lógica de acceso a datos.
- **Models**: Modelos utilizados en la aplicación.
- **Repositories**: Repositorios para gestionar la interacción con la base de datos.
- **Services**: Servicios que encapsulan la lógica del negocio.
- **Controllers**: Controladores que manejan las solicitudes HTTP.

### Roles y Permisos

El sistema utiliza **JWT** para autenticación y manejo de roles:

- **Admin**: Tiene permisos completos (CRUD).
- **Empleado**: Sin acceso a la gestión de usuarios, pero con permisos en productos y pedidos.
- **Cliente**: Acceso a la creación de pedidos y lectura de productos. Puede gestionar sus propios pedidos.

### Frontend en Blazor

El frontend está desarrollado en **Blazor** con la siguiente estructura:

- **Auth**: Manejo de autenticación.
- **State**: Almacenamiento del estado del token.
- **Model**: Estructura de los datos enviados.
- **Service**: Manejo de peticiones HTTP.
- **DTO**: Estructura de los datos recibidos.
- **Coordinators**: Validación y estructuración de datos.
- **Shared**: Componentes y layouts compartidos, como el navbar y botones reutilizables.

## Contribución

Si deseas contribuir al proyecto, por favor, envía un pull request o abre un issue en GitHub.

---

### Notas Adicionales:

- **Estructura de Solicitudes de Ejemplo**: La estructura de ejemplo de solicitudes se encuentra en la carpeta `estructura` con el nombre de la estructura y la petición que realiza.
  
- **Asegúrate de instalar todos los paquetes necesarios**: Para una ejecución adecuada del programa, todos los paquetes del proyecto deben estar instalados. Utiliza el comando correspondiente (`npm install`, `dotnet restore`, etc.) según sea necesario en cada parte del proyecto.

- **Ejecutar en Entornos Sin Configuración Previa**: Este proyecto está diseñado para ejecutarse en una PC que no tenga nada configurado previamente. Sigue las instrucciones detalladas para clonar, configurar y ejecutar tanto el backend como el frontend especificando las líneas de código necesarias.

