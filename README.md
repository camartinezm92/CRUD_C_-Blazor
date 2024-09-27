CRUD  C# y Blazor
Desarrollo de un CRUD en C# como backend  API y Blazor como frontend, con SQL Server y procedimientos almacenados.
Desarrollo de una aplicación por medio de SQL Server de Microsoft, Un backend en ASP.NET Core API y frontend desarrollado en Blazor, con Boostrap.min y CSS.
La estructura de la aplicación cuenta con:
•	2 bases de datos (Usuarios y ProductosPedidos)
•	Backend independiente que maneja solicitudes HTTP y HTTPS
•	Frontend en Blazor.
Se realizaron los siguientes endpoints: 
LOGIN:
•	POST LOGIN
USUARIOS:
•	GET USUARIOS
•	GET ID USUARIOS
•	POST USUARIOS
•	PUT USUARIOS
•	DELETE USUARIOS
PRODUCTOS:
•	GET PRODUCTOS
•	GET ID PRODUCTOS
•	POST PRODUTOS
•	PUT PRODUSTOS
•	DELETE PRODUCTOS
PEDIDOS:
•	GET PEDIOS
•	GET ID PEDIDOS
•	GET ID USUARIO PEDIDOS
•	PUT PEDIDOS
•	DELETE PEDIDO
Para el SQL se toma como referencia el Manual de estándares de base de datos de Luis Ernesto Marino, se realiza la nomenclatura según el tipo de tabla y se realiza el uso de proceso almacenados para el manejo de peticiones SQL, buscando así evitar inyección de SQL directamente sobre cada una de las tablas de las bases de datos, se manejó encriptado para tabla usuarios en nombre usuario y se usó SHA256 para el cifrado de contraseñas dentro de la base de datos.
Para el desarrollo en C# se estableció una estructura de carpetas  tipo ;;;;;;; Data, Model, Repositories, Services, Controller teniendo claridad en la estructura de la solicitud, estructura de la respuesta, y control validación de la información, adicional se estableció control de permisos por medio de JWT y asignación de roles para el acceso a las peticiones desde el frontend.
ROLES = "Admin", "Empleado" y "clientes"
Sin rol = C Usuario Admin = tiene todos los permisos 
Empleado = No tiene permisos en usuarios. Cliente = R Productos, C pedidos y RUD de sus pedidos
El Frontend en se desarrolla con Blazor en una estructura Auth (login), State(disponibilidad de Token), Model (estructura para envió de datos), Servicie(manejo de peticiones), DTO(estructura para recepción de datos), Coordinators( validación de data y estructuración de la misma hacia la vista), Share(nav, compoentes, layouts, ect..), estructurando la data tanto de la solicitud Con Token en JWT, recibiendo la respuesta validando los datos y estructurado la respuesta.
Para realizar pruebas de funcionamiento de la aplicación se tiene que seguir este paso a paso:
1 Creación de bases de datos y Tablas SQL: Abrir SQL Server y autenticarse en la DB Master y seguido de esto abrir una nueva consulta. Abrir archivo shemas 1DB y 2DB, Copiar el código de cada uno de ellos shemas y ejecutar de forma separadas.
Creación de métodos almacenados Usuario : Seleccionar la base de datos PRUEBA_USUARIOS  abrir una nueva consulta y ejecutar el código de forma individual de los siguientes archivos: 

•	SPR_INS_CREAR_USUARIO --> Crear Usuario 
•	SPR_GET_LISTAR_USUARIOS --> Listar Usuarios 
•	SPR_GET_OBTENER_USUARIO_POR_ID --> Buscar Usuario por ID Usuario 
•	SPR_GET_USUARIO_POR_NOMBRE --> Buscar usuario por nombre 
•	SPR_GI__HASH_CONTRASENA --> Encriptación de contraseñas 
•	SPR_UPD_ACTUALIZAR_USUARIO --> Actualiza Usuario 
•	SPR_DEL_ELIMINAR_USUARIO --> Eliminar Usuario 
•	SPR_GET_USUARIOS_DESENCRIPTADOS (opcional) --> proceso para validar que se logre desencriptar el nombre de usuario de la base de datos con la key establecida.
2.	Creación de métodos almacenados Productos y Pedidos: Seleccionar la base de datos PRUEBA_PRODUCTOS abrir una nueva consulta y ejecutar el código SQL de forma individual de los siguientes archivos: Productos: 
•	SPR_INS_CREAR_PRODUCTO
•	SPR_GET_LISTAR_PRODUCTOS 
•	SPR_GET_OBTENER_PRODUCTO_POR_ID 
•	SPR_UPD_ACTUALIZAR_PRODUCTO 
•	SPR_DEL_ELIMINAR_PRODUCTO
Pedidos: 
•	TVP_TPRODUCTOS.
•	SPR_INS_CREAR_PEDIDO 
•	SPR_GET_LISTAR_PEDIDOS 
•	SPR_GET_PEDIDO_POR_ID 
•	SPR_GET_LISTAR_PEDIDOS_POR_USUARIO 
•	SPR_UPD_ACTUALIZAR_PEDIDO -SPR_DEL_ELIMINAR_PEDIDO
4.	ingreso de data a las bases de datos:
1.	DB PRUEBA_USUARIOS: DataUsuarios.
2.	DB PRUEBA_PRODUCTOS: Data Productos.

5.	(opcional) Pruebas código SQL en la carpeta Pruebas SQL se encuentra código para realizar validación de los métodos y su funcionamiento.
6.	Clonar repositorio TiendaAPI (backend): Clonar el repositorio en su pc
1.	Abrir el repositorio e ir al archivo appsettings.json: En este archivo encontraras esta estructura: 
{ 
"ConnectionStrings": { 
"UserConnection": "Server= Nombre del servidor en su pc ;Database=PRUEBA_USUARIOS;User Id=sa;Password= contraseña para ingresar a su DB ;Encrypt=False;", --> acceso base de datos PRUEBA_USUARIOS en método de autenticación SQL Server. 

"ProductosConnection": "Nombre del servidor en su pc;Database=PRUEBA_PRODUCTOS;User Id=sa;Password=contraseña para ingresar a su DB;Encrypt=False;" --> --> acceso base de datos PRUEBA_PRODUCTOS en método de autenticación SQL Server.
 } 
}
Editar el nombre del servidor y la contraseña para autenticación SQL server dentro de su pc, en este caso se deja en usuario sa de administrador de sistema que trae el programa por defecto, pero si desea cambiarlo puede hacerlo sin problema. una vez actualizado esto guarde los cambios en el archivo.
Seguido de esto ejecute la aplicación, se abrirá la terminal e indicara 2 rutas de acceso para la aplicación una es HTTP y la otra es HTTPS, seleccioné sobre cualquiera de la 2 rutas o copie la ruta péguela en su navegador en el URL y colóquele un  /  al final o  /index.html, Esto habilitara swagger para realizar las pruebas de los endpoint que tiene estructurada la aplicación, busque el ítem que dice /api/Prueba/probar-conexion presione sobre el y presione el botón que dice Try it out y luego un botón azul aparece y presione execute, valide que en el mensaje de respuesta aparezca 200 y un mensaje que dice   Conexión a SQL Server exitosa.  si esta es la respuesta obtenida significa que la comunicación de la aplicación con la Base de datos es correcta.
(opcional) Puede iniciar la prueba de los métodos desde swagger, para esto debe ejecutar de forma inicial la opción que dice: /api/Auth/login y escriba este cuerpo en el body de la solicitud donde aparece usuario y contrasena:
{ "usuario": "admin", "contrasena": "admin" }
Recibirá una respuesta con un token, copie el token sin incluir las "comillas" y en la parte superior de la página se swagger vera un botón que dice Authorize presione ahí en el campo de texto que se habilita escriba lo siguiente: 
Bearer (el toquen que copio) --> a estructura es con el espacio entre el Bearer y el token. 
presión en el botón Autoriza y luego cierre el modal, verifique que todos los símbolos con forma de candado aparecen cerrados esto quiere decir que el token para realizar las solicitudes esta guardado y se pueden realizar las pruebas;  Los cuerpos para las peticiones se encuentran dentro del archivo PruebasEndPointsBackEND. seleccione las que desea probar copie el cuerpo de péquelo si requiere.
7.	Clonar el repositorio TeindaDePrueba abrirlo y ejecutarlo después de tener en ejecución Tienda API, esperar a que inicie el proyecto y probarlo, puede usar estos usuarios para sus pruebas: 
•	Admin: 
o	usuario: admin 
o	contrasena: admin
•	Empleado: 
o	usuario: empleado 
o	contrasena: empleado
•	Cliente: 
o	usuario: cliente 	
o	contrasena: cliente.

