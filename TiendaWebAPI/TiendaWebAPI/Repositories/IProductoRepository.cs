using System.Collections.Generic;
using System.Threading.Tasks;
using TiendaWebAPI.Models;

namespace TiendaWebAPI.Repositories
{
    public interface IProductoRepository
    {
        Task<IEnumerable<Producto>> GetProductos();
        Task<Producto> GetProductoById(int id);
        Task CreateProducto(Producto producto);
        Task UpdateProducto(Producto producto);
        Task DeleteProducto(int id);
    }
}
