namespace TeindaDePrueba.Models
{
    public class ModelProducto
    {
        public string Nombre { get; set; } // Nombre del producto
        public string Descripcion { get; set; } // Descripción del producto
        public decimal Precio { get; set; } // Precio del producto
        public int Inventario { get; set; } // Inventario del producto
        public string ImagenUrl { get; set; } // URL de la imagen del producto
    }

    public class ProductoActualizarModel
    {
        public string Nombre { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public int Inventario { get; set; }
        public string ImagenUrl { get; set; } = string.Empty;
    }


}
