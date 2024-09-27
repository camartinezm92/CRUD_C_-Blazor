# CRUDC-yBlazor
Desarrollo de un CRUD en C# como backen API y BLazor como Frontend, con SQL Server y procedimeintos almacenados.

Desarrollo de un aplicion por medio de SQL Server de Microsoft, Un Backend en ASP.NET Core API y front desarrollado en Blazzor, con Boostrap.min y CSS.

La esturutra d ela alicion cuenta con:
- 2 bases de datos (Usuarios y ProductosPedidos)
- Backen independiente que maneja solicitudes HTTP y HTTPS
- Fronend en blazor.

Se realizaron los sigunetes endpoints:
LOGIN:
- POST LOGIN
  
USUARIOS
- GET USUARIOS
- GET ID USUARIOS
- POST USUARIOS
- PUT USUARIOS
- DELETE USUARIOS
  
PRODUCTOS
- GET PRODUCTOS
- GET ID PRODUCTOS
- POST PRODUTOS
- PUT PRODUSTOS
- DELETE PRODUCTOS

PEDIDOS
- GET PEDIOS
- GET ID PEDIDOS
- GET ID USUARIO PEDIDOS
- PUT PEDIDOS
- DELETE PEDIDO  


Para el SQL se toma como referencia el Manual de estandares de base de datos de Luis Ernesto Marino, se realiza la nomenclaruta segun el tipo de tabla y se realiza el uso de proceso almacenados para el manejo de peticiones SQL, buscnado asi evitar inyeccion de sql diretamente sobre cada una de las bases de datos, se manejo encritado apra tabla usuarios en nombre susario y se uso SHA256 para el cifrado de contrasenas dentro de la base de datos y se realiza comparaion directa de la infomacion por medio del SHA256 diratamente en el procemiento alamcenado.

Para el desarrollo en C# se seguio una estrutura de carpetas Data, Model, Repositories, Services, Controller teniendo clariadad en la estrutura de la solicitud, estrutura de la repsuesta, y control valiacion de la infoamcion, adcional se establecio control de permisos por medio de JWT y asignacion de roles para el acceso a las peticiones desde el front.

ROLES = "Admin", "Empleado" y "clientes"

Sin rol = C Usuario
Admin = tiene tosos los permisos
Empleado = No tine permieso en usuarios.
Cliente = R Productos, C pedidos y RUD de sus pedidos

El Frontend en se desarrolla con Blazor en una estrucutra Auth (login), State(disponibilidad de Token), Model(estrutura para envio de datos), Service(manejo de peticiones), DTO(estrutura para recepcion de datos), Coordinators( validacion de data y estruturacion de la misma hacia la vista), Share(nav, compoentes, leyouts,ect), estruturando la data tanto de la solicitud Con Token en JWT, resiviendo la respuesta validando los datos y estruturando la respuesta.

Para realizar pruebas de funcionamiento de la aplicaion se tiene que seguir este paso a paso:

1 Creacion de Dabes de datos y Tablas SQL: Abrir SQL Server y autenticarse en la DB Master y seguido de esto abrir una nueva ocnsulta.  Abrir archivo Shemas 1DB y 2DB, Copiar el codigo de cada uno de ellos Shemas y ejecutar de forma separadas.

2. Creacion de metodos alamcenados Usuario : Seleciconar la base de datos PRUEBA_USUARIOS abrir una nueva consulta y ejecutar el codigo  de forma individual de los siguentes archivos:
  -SPR_INS_CREAR_USUARIO --> Crear Usuario
  -SPR_GET_LISTAR_USUARIOS --> Listar Uusarios
  -SPR_GET_OBTENER_USUARIO_POR_ID --> Buscar Usuario por ID Uusario
  -SPR_GET_USUARIO_POR_NOMBRE --> Buscar usaurio por nombre 
  -SPR_GI__HASH_CONTRASENA --> Encriptaciopn de contrasenas
  -SPR_UPD_ACTUALIZAR_USUARIO --> Actualiza Uusario
  -SPR_DEL_ELIMINAR_USUARIO --> Eliminar Uusario
  -SPR_GET_USUARIOS_DESENCRIPTADOS (opcional) --> proceos para validar que se logre desencritar el nombre de usuario de la base de datos con la key establecida.

3. Creacion de metodos almacenados Productos y Pedidos: Seleciconar la base de datos PRUEBA_PRODUCTOS abrir una nueva consulta y ejecutar el codigo SQL de forma individual de los siguentes archivos:
  Productos:
  -SPR_INS_CREAR_PRODUCTO
  -SPR_GET_LISTAR_PRODUCTOS
  -SPR_GET_OBTENER_PRODUCTO_POR_ID
  -SPR_UPD_ACTUALIZAR_PRODUCTO
  -SPR_DEL_ELIMINAR_PRODUCTO

  Pedidos:
  -TVP_TPRODUCTOS.
  -SPR_INS_CREAR_PEDIDO
  -SPR_GET_LISTAR_PEDIDOS
  -SPR_GET_PEDIDO_POR_ID
  -SPR_GET_LISTAR_PEDIDOS_POR_USUARIO
  -SPR_UPD_ACTUALIZAR_PEDIDO
  -SPR_DEL_ELIMINAR_PEDIDO

4. ingreso de data a las bases de datos:
   - DB PRUEBA_USUARIOS : DataUsuarios.
   - DB PRUEBA_PRODUCTOS : Data Productos.
  
5. Pruebas codigo SQL (opcional) en la carpta Prubas SQL se encuntran codigo spara relizar validacion de los metodos y su funcionamiento.
   
6. Clonar repositorio TiendaAPI (backend): Clonar el repositorio en su pc, abrir el repositorio e ir al archivo appsettings.json:
En este archivo conontrara esta estrutura:
{
  "ConnectionStrings": {
    "UserConnection": "Server= Nombre del servirdor en su pc ;Database=PRUEBA_USUARIOS;User Id=sa;Password= constrasena para ingresar a su db ;Encrypt=False;",  --> acceso base de datos PRUEBA_USUARIOS en metodo de autenticacion SQL Server.
    "ProductosConnection": "Nombre del servirdor en su pc;Database=PRUEBA_PRODUCTOS;User Id=sa;Password=onstrasena para ingresar a su db;Encrypt=False;" --> --> acceso base de datos PRUEBA_PRODUCTOS en metodo de autenticacion SQL Server.
  }
}

Editar el nombre del servidor y la contrasena para autenticacion sql server dentro de su pc, en este caso se deja en usuario Sa de admintrador de sistema que trae el programa por defecto pero si desea cambiarlo puede hacerlo sin problema. una vez actulizado esto guarde los cambios en el archivo.

Seguido de esto ejecute el la aplicion, se abrira la terminal e indicara 2 rutas de acceso apra la aplicacion una es HTTP y la otra es HTTPS, preison sobre cualqueira de la 2 rutas o copie la ruta peguela en su navegador en el URL y coloquele un / al final o un /index.html, Esto habilitara swagger para realizar lasa pruebas de los endpoint que tiene estruturada la aplicacion, busque el itme que dice /api/Prueba/probar-conexion
presione sobre el y presione el boton que dice Try it out y luego un boton azul aparece y presion execute, valide que en el mensaje de repsuesta aparesca 200 y un pensaje que dice *Conexión a SQL Server exitosa.*  si esta es la respuesta obtenida significa que la comunicacion de la aplicacion con la db es axitosa.

(opcional)
Puede iniciar la prueba de los metodos desde swagger, apra esto debe ejecutar de forma inical la opcion que dice: /api/Auth/login y escriba este cuerpo en el body de la solicitud donde aparece usuario y contrasena:

{
  "usuario": "admin",
  "contrasena": "admin"
}

recibira una repsuesta con un token copie el token sin  incluir las "" y en la parte superior de la pagina se swagger vera un boton que dice Authorize preion ahi en en la cpato de texto que se habilira escriba lo siguiente: Bearer (el toquen que copio) --> a estrutura es con el esacio entre el Bearer y el token. preison en el boton Autoriza y luego cierre el modal, verifique que todos los simbolos con forma de candado aparescan cerrados esto queire decir que el token para realizar las solicitudes esta gaurdado y se peuden realizar las pruebas los cuarpos para las petiocnes se encuntran dentor dle archivo PruebasEndPointsBackEND. slecelccione sla qeu desea probar copie el cuerpo de pequelo si requiere.

7. Conalr el repositorio TeindaDePrueba abrirlo y ejecutarlo depsues de tener en ejecucion TiendaAPI, esperar a que inicie el proyecto y probalor, puede usaurio estos suaurios para sus preubas:
Admin: 
usuario: admin
contrasena: admin

Empleado:
usuario: empleado
contrasena: empleado

Cliente:
usuario: cliente
contrasena: cliente.


   
