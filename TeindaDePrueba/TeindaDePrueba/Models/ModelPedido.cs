namespace TeindaDePrueba.Models
{
    public class ModelPedido
    {
        public int UsuarioId { get; set; } 
        public List<ProductoPedidoModel> Productos { get; set; } = new List<ProductoPedidoModel>(); 

    }

    public class ProductoPedidoModel
    {
        public int ProductoId { get; set; } 
        public int Cantidad { get; set; } 
    }
}
