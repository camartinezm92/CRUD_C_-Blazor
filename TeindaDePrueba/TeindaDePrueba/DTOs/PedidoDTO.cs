namespace TeindaDePrueba.DTOs
{
    public class PedidoDTO
    {
        // Identificador único del pedido
        public int Id { get; set; }

        // ID del usuario que realizó el pedido
        public int UsuarioId { get; set; }

        // Nombre del usuario que realizó el pedido
        public string UsuarioNombre { get; set; }

        // Cantidad total de productos en el pedido
        public int CantidadTotal { get; set; }

        // Valor total del pedido
        public decimal ValorTotal { get; set; }

        // Fecha en la que se realizó el pedido
        public DateTime FechaPedido { get; set; }

        // Lista de productos asociados al pedido
        public List<ProductoPedidoDTO> Productos { get; set; } = new List<ProductoPedidoDTO>();
    }

    public class ProductoPedidoDTO
    {
        // ID del producto en el pedido
        public int ProductoId { get; set; }

        // Nombre del producto en el pedido
        public string NombreProducto { get; set; }

        // Cantidad del producto en el pedido
        public int Cantidad { get; set; }

        // Precio unitario del producto en el pedido
        public decimal PrecioUnitario { get; set; }

        // Precio total calculado (Cantidad * PrecioUnitario)
        public decimal PrecioTotal { get; set; }
    }
}
