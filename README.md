Aquí te dejo una versión mejorada y más organizada de tu README para GitHub:

# CRUD en C# y Blazor

Este proyecto consiste en el desarrollo de un CRUD utilizando **C#** como backend API y **Blazor** como frontend, junto con **SQL Server** y procedimientos almacenados.

## Descripción

La aplicación es una plataforma de gestión que utiliza **SQL Server** para la base de datos, **ASP.NET Core API** para el backend y **Blazor** para el frontend. Está diseñada con **Bootstrap** y **CSS** personalizados para la interfaz de usuario.

### Estructura de la Aplicación:

- **Bases de datos:**  
  - 2 bases de datos: Usuarios y ProductosPedidos.
- **Backend independiente:**  
  - Maneja solicitudes HTTP y HTTPS.
- **Frontend en Blazor:**  
  - Incluye Boostrap.min y estilos CSS personalizados.

### Endpoints Disponibles:

#### Login:
- `POST /login`: Autenticación de usuarios.

#### Usuarios:
- `GET /usuarios`: Listar todos los usuarios.
- `GET /usuarios/{id}`: Obtener usuario por ID.
- `POST /usuarios`: Crear un nuevo usuario.
- `PUT /usuarios/{id}`: Actualizar usuario.
- `DELETE /usuarios/{id}`: Eliminar usuario.

#### Productos:
- `GET /productos`: Listar todos los productos.
- `GET /productos/{id}`: Obtener producto por ID.
- `POST /productos`: Crear un nuevo producto.
- `PUT /productos/{id}`: Actualizar producto.
- `DELETE /productos/{id}`: Eliminar producto.

#### Pedidos:
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

- **Data:** Lógica de acceso a datos.
- **Models:** Modelos utilizados en la aplicación.
- **Repositories:** Repositorios para gestionar la interacción con la base de datos.
- **Services:** Servicios que encapsulan la lógica del negocio.
- **Controllers:** Controladores que manejan las solicitudes HTTP.

### Roles y Permisos

El sistema utiliza **JWT** para autenticación y manejo de roles:

- **Admin:** Tiene permisos completos (CRUD).
- **Empleado:** Sin acceso a la gestión de usuarios, pero con permisos en productos y pedidos.
- **Cliente:** Acceso a la creación de pedidos y lectura de productos. Puede gestionar sus propios pedidos.

### Frontend en Blazor

El frontend está desarrollado en **Blazor** con la siguiente estructura:

- **Auth:** Manejo de autenticación.
- **State:** Almacenamiento del estado del token.
- **Model:** Estructura de los datos enviados.
- **Service:** Manejo de peticiones HTTP.
- **DTO:** Estructura de los datos recibidos.
- **Coordinators:** Validación y estructuración de datos.
- **Shared:** Componentes y layouts compartidos, como el navbar y botones reutilizables.

### Configuración de Base de Datos

1. **Creación de las bases de datos**: 
   - Usa SQL Server y autentícate en la base de datos `master`.
   - Ejecuta los scripts de las bases de datos proporcionados en los archivos `schemas_1DB.sql` y `schemas_2DB.sql`.
   
2. **Procedimientos almacenados (Usuarios):**
   - Ejecuta cada uno de los siguientes procedimientos almacenados en la base de datos `PRUEBA_USUARIOS`:
     - `SPR_INS_CREAR_USUARIO`
     - `SPR_GET_LISTAR_USUARIOS`
     - `SPR_GET_OBTENER_USUARIO_POR_ID`
     - `SPR_GET_USUARIO_POR_NOMBRE`
     - `SPR_GI__HASH_CONTRASENA`
     - `SPR_UPD_ACTUALIZAR_USUARIO`
     - `SPR_DEL_ELIMINAR_USUARIO`

3. **Procedimientos almacenados (Productos y Pedidos):**
   - Ejecuta cada uno de los siguientes procedimientos en la base de datos `PRUEBA_PRODUCTOS`:
     - Productos:
       - `SPR_INS_CREAR_PRODUCTO`
       - `SPR_GET_LISTAR_PRODUCTOS`
       - `SPR_GET_OBTENER_PRODUCTO_POR_ID`
       - `SPR_UPD_ACTUALIZAR_PRODUCTO`
       - `SPR_DEL_ELIMINAR_PRODUCTO`
     - Pedidos:
       - `SPR_INS_CREAR_PEDIDO`
       - `SPR_GET_LISTAR_PEDIDOS`
       - `SPR_GET_PEDIDO_POR_ID`
       - `SPR_GET_LISTAR_PEDIDOS_POR_USUARIO`
       - `SPR_UPD_ACTUALIZAR_PEDIDO`
       - `SPR_DEL_ELIMINAR_PEDIDO`

4. Ejecuta una a una las consulas SQL para ingresar la data de pruedas a las tablas dentro de la carpeta Datos para tablas.

5. **Pruebas del sistema:**
   - Ejecuta el backend (`TiendaAPI`), ajusta el archivo `appsettings.json` con los datos de conexión a tu SQL Server y ejecuta el proyecto.
   - Para probar la API, usa **Swagger** desde la web que se abre o **Postman** desde el archivo json que se encuntra en el repositorio. Valida la conexión a la base de datos y prueba los diferentes endpoints.
   
7. **Login y Autorización:**
   - Para acceder a los endpoints protegidos, autentícate usando `/api/Auth/login` con las siguientes credenciales:
     - **Admin**: 
       - Usuario: `admin`
       - Contraseña: `admin123`

La estrutura de ejemplo de solicutud se encuentra e la carpeta estrutre con el nombre de la estrutura y peticion que realiza.

## Cómo Ejecutar el Proyecto

1. **Abre el backend en tu editor de codigo:**  
   ```bash
      TiendaAPI
   ```
2. **Configura las cadenas de conexión en `appsettings.json` para tu servidor de SQL Server.**
3. **Ejecuta el proyecto en Visual Studio o usando `dotnet run`.**
4. Realiza preubas desde Postman o Swagger (opcional)
5. **Abre el frontend en tu editor de codigo**  
   ```bash
      TiendaDePrueba
   ```
6. **Ejecuta el frontend después de tener el backend en funcionamiento.**

## Contribución

Si deseas contribuir al proyecto, por favor, envía un pull request o abre un issue en GitHub.

