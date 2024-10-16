USE [PRUEBA_PRODUCTOS]
GO

/*---------------------------------------------------------------------------------------------
Autor: Camilo Martinez
Fecha Creación: 25/09/2024
Propósito: Insertar 25 productos en la tabla TBL_RPRODUCTOS para la base de datos PRUEBA_PRODUCTOS.
Consideraciones: Los productos tendrán un inventario entre 10 y 150 unidades, y un precio entre 200,000 y 3,000,000.
Cada producto cuenta con su URL de imagen correspondiente.
Modificaciones:
Fecha modificación: N/A
-----------------------------------------------------------------------------------------------*/

/* Inserción de 25 productos en la tabla TBL_RPRODUCTOS */
INSERT INTO [dbo].[TBL_RPRODUCTOS] (
    PRO_CNOMBRE, 
    PRO_CDESCRIPCION, 
    PRO_NPRECIO, 
    PRO_NINVENTARIO, 
    PRO_CIMAGEN_URL
)
VALUES
-- Producto 1
('Televisor Ultra HD', 'Televisor de 50 pulgadas con resolución 4K Ultra HD y HDR', 1500000, 25, 'https://images.samsung.com/is/image/samsung/es-uhd-ku6000-ue50ku6000kxxc-008-side-black?$L2-Thumbnail$'),
-- Producto 2
('Smartphone X500', 'Smartphone de gama alta con 128 GB de almacenamiento y cámara de 64 MP', 1200000, 50, 'https://tse1.mm.bing.net/th?id=OIP.0raAsaMY60q-GYGyLP-BnwHaE8&pid=Api&P=0&h=180'),
-- Producto 3
('Laptop Gamer Pro', 'Laptop para juegos con procesador Intel i7 y tarjeta gráfica RTX 3060', 2800000, 15, 'https://www.professionalwireless.com.co/wp-content/uploads/2023/12/Legion-Pro-7-16IRX8H-82WQ002SUS_16GB.jpg'),
-- Producto 4
('Auriculares Inalámbricos', 'Auriculares Bluetooth con cancelación de ruido', 300000, 100, 'https://cosonyb2c.vtexassets.com/arquivos/ids/356566-800-800?v=638180374236330000&width=800&height=800&aspect=true'),
-- Producto 5
('Reloj Inteligente', 'Reloj con monitoreo de ritmo cardíaco y GPS integrado', 400000, 60, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSef3ZaqhzZxr20daBh6MHNU_DlWE-xIZ89OA&s'),
-- Producto 6
('Tablet Pro', 'Tablet de 10 pulgadas con pantalla de alta resolución y 256 GB de almacenamiento', 1100000, 40, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVsb0-LKrk_EaYy2hEcU8hxjh5IDD0eTB5KA&s'),
-- Producto 7
('Cámara Fotográfica DSLR', 'Cámara profesional con lente de 18-55mm y 24 MP', 2500000, 30, 'https://colombia.bioweb.co/cdn/shop/files/1670509913_IMG_1892712.jpg?v=1685545801'),
-- Producto 8
('Consola de Videojuegos', 'Consola de última generación con soporte 4K y 1 TB de almacenamiento', 2200000, 20, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaXYCAfwmE3j0mksw9twnp8xO4QmJjAOtStw&s'),
-- Producto 9
('Bicicleta Eléctrica', 'Bicicleta con asistencia eléctrica y batería de larga duración', 1800000, 35, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2q7_z5b6dwxcO3IsX5HCVTRWMUJ_7ESnPJA&s'),
-- Producto 10
('Aspiradora Robot', 'Aspiradora inteligente con programación automática y control remoto', 800000, 50, 'https://electroluxco.vtexassets.com/arquivos/ids/162906/Robot_Vacuum_ERB10_Perspective_Electrolux_1000x1000.jpg?v=638151302320930000'),
-- Producto 11
('Altavoz Bluetooth', 'Altavoz portátil resistente al agua con sonido envolvente', 200000, 120, 'https://tse3.mm.bing.net/th?id=OIP.GSqUw_bpdnnv3orlEO79oQHaHa&pid=Api&P=0&h=180'),
-- Producto 12
('Monitor 4K', 'Monitor de 27 pulgadas con resolución 4K y 60 Hz', 1300000, 25, 'https://images-na.ssl-images-amazon.com/images/I/61KT4VHM0GL._AC_SL1250_.jpg'),
-- Producto 13
('Teclado Mecánico', 'Teclado mecánico RGB con switches Cherry MX Red', 350000, 90, 'https://tse2.mm.bing.net/th?id=OIP.1XlnY_hDWwYlBiThiGDD5wHaFE&pid=Api&P=0&h=180'),
-- Producto 14
('Silla Gamer', 'Silla ergonómica con soporte lumbar y ajuste de altura', 900000, 30, 'https://tse4.mm.bing.net/th?id=OIP.ydL9HOCTaoVNpeMQczXAAQHaHa&pid=Api&P=0&h=180'),
-- Producto 15
('Impresora Multifuncional', 'Impresora con escáner y conexión Wi-Fi', 550000, 50, 'https://mymsystech.com.co/1641-thickbox_default/impresora-multifuncional-epson-l3150-c11cg86301.jpg'),
-- Producto 16
('Disco Duro Externo', 'Disco duro de 2 TB con conexión USB 3.0', 300000, 150, 'https://tse3.mm.bing.net/th?id=OIP.BeZw9RZvIvxYQvU-DB3y9wHaHa&pid=Api&P=0&h=180'),
-- Producto 17
('Router Wi-Fi 6', 'Router de última generación con tecnología Wi-Fi 6 y 4 antenas', 500000, 45, 'https://www.hellotech.com/blog/wp-content/uploads/2020/11/Asus-ROG-Rapture-GT-AX11000_Best-WiFi-6-Router-for-Gaming-1400x1137.jpg'),
-- Producto 18
('Ventilador de Torre', 'Ventilador de torre con control remoto y temporizador', 250000, 60, 'https://s.libertaddigital.com/2020/08/02/rowenta-eole-infinite-digital.jpg'),
-- Producto 19
('Cámara de Seguridad', 'Cámara con visión nocturna y detección de movimiento', 600000, 80, 'https://tse1.mm.bing.net/th?id=OIP.-tlVhMv8tijxntSgVaXh7QHaHG&pid=Api&P=0&h=180'),
-- Producto 20
('Batería Portátil', 'Power bank de 20000 mAh con carga rápida', 200000, 100, 'https://tse3.mm.bing.net/th?id=OIP.MzRRBfzf5ucGssHT6WMEZwHaFx&pid=Api&P=0&h=180'),
-- Producto 21
('Televisor OLED', 'Televisor de 55 pulgadas con tecnología OLED y Dolby Vision', 3000000, 20, 'https://images.philips.com/is/image/PhilipsConsumer/55OLED856_12-IMS-en_GB?$jpglarge$&wid=1250'),
-- Producto 22
('Barra de Sonido', 'Barra de sonido con subwoofer inalámbrico y sonido envolvente', 1000000, 40, 'https://tse4.mm.bing.net/th?id=OIP.mOHsjZBLY8gDQHwHS6bqBAHaE_&pid=Api&P=0&h=180'),
-- Producto 23
('Proyector Full HD', 'Proyector portátil con resolución Full HD y soporte 3D', 1200000, 15, 'https://tse2.mm.bing.net/th?id=OIP.RZmLSRL56HUjvszurTBY5AHaHa&pid=Api&P=0&h=180'),
-- Producto 24
('Refrigerador Inverter', 'Refrigerador de dos puertas con tecnología Inverter y dispensador de agua', 2900000, 10, 'https://www.elpalaciodehierro.com/on/demandware.static/-/Sites-palacio-master-catalog/default/dw2bc11a44/images/41136114/large/41136114_x1.jpg'),
-- Producto 25
('Smartwatch Fitness', 'Reloj inteligente con monitoreo de actividad física y resistencia al agua', 350000, 150, 'https://tse3.mm.bing.net/th?id=OIP.wiXtN9iJHlQJ2dJiSLHa5wAAAA&pid=Api&P=0&h=180');
GO