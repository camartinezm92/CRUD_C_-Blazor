using TiendaWebAPI.Models;

namespace TiendaWebAPI.Services
{
    public interface IProductoService
    {
        Task<IEnumerable<Producto>> GetProductos();
        Task<Producto> GetProductoById(int id);
        Task CreateProducto(Producto producto);
        Task UpdateProducto(Producto producto);
        Task DeleteProducto(int id);
        Task<int> ObtenerInventarioDisponible(int productoId);
    }
}
