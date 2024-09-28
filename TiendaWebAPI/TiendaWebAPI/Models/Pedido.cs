namespace TiendaWebAPI.Models
{
    public class Pedido
    {
        public int Id { get; set; }  // PED_NID
        public int UsuarioId { get; set; }  // PED_NUSUARIO_ID
        public string? UsuarioNombre { get; set; } // Nombre del usuario (solo se debe utilizar en consultas o listados)
        public int CantidadTotal { get; set; }  // PED_NCANTIDAD
        public decimal ValorTotal { get; set; }  // PED_NVALOR_TOTAL
        public DateTime FechaPedido { get; set; }  // PED_DFECHA_PEDIDO

        // Relación con los productos en el pedido (solo para el detalle)
        public List<ProductoDetalle> Productos { get; set; } = new List<ProductoDetalle>();  // Esta lista no debe ser usada como relación en la base de datos
    }

    public class ProductoDetalle
    {
        public int ProductoId { get; set; }   // ID del producto
        public string? NombreProducto { get; set; }  // Nombre del producto (solo para consultas)
        public int Cantidad { get; set; }   // Cantidad del producto en el pedido
        public decimal PrecioUnitario { get; set; }   // Precio unitario del producto (solo para consultas)
        public decimal PrecioTotal { get; set; }   // Precio total por producto (solo para consultas)
    }
}
