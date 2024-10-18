using TeindaDePrueba.DTOs;
using System.Threading.Tasks;
using System.Collections.Generic;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Services
{
    public interface IProductoService
    {
        Task<List<ProductoDTO>> GetProductosAsync();
        Task<ProductoDTO> GetProductoByIdAsync(int id);
        Task<bool> EliminarProductoAsync(int id);
        Task<bool> CrearProductoAsync(ModelProducto productoNuevo);
        Task<bool> ActualizarProductoAsync(int id, ProductoActualizarModel productoActualizado);

    }
}
