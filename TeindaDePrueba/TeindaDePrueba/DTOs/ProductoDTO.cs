namespace TeindaDePrueba.DTOs
{
    public class ProductoDTO
    {
        // Identificador único del producto
        public int Id { get; set; }

        // Nombre del producto
        public string? Nombre { get; set; }

        // Descripción del producto
        public string? Descripcion { get; set; }

        // Precio del producto
        public decimal Precio { get; set; }

        // Cantidad disponible en inventario
        public int Inventario { get; set; }

        // URL de la imagen del producto (opcional)
        public string? ImagenUrl { get; set; }

        // Cantidad seleccionada por el usuario en una orden o pedido
        public int CantidadSeleccionada { get; set; }
    }
}
