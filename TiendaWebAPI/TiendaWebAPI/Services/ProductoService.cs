using System.Collections.Generic;
using System.Threading.Tasks;
using TiendaWebAPI.Models;
using TiendaWebAPI.Repositories;

namespace TiendaWebAPI.Services
{
    public class ProductoService : IProductoService
    {
        private readonly IProductoRepository _productoRepository;

        // Constructor: Inicializa el repositorio de productos
        public ProductoService(IProductoRepository productoRepository)
        {
            _productoRepository = productoRepository;
        }

        // Obtener la lista de todos los productos
        public async Task<IEnumerable<Producto>> GetProductos()
        {
            return await _productoRepository.GetProductos();
        }

        // Obtener un producto por su ID
        public async Task<Producto> GetProductoById(int id)
        {
            return await _productoRepository.GetProductoById(id);
        }

        // Crear un nuevo producto
        public async Task CreateProducto(Producto producto)
        {
            await _productoRepository.CreateProducto(producto);
        }

        // Actualizar los datos de un producto existente
        public async Task UpdateProducto(Producto producto)
        {
            await _productoRepository.UpdateProducto(producto);
        }

        // Eliminar un producto por su ID
        public async Task DeleteProducto(int id)
        {
            await _productoRepository.DeleteProducto(id);
        }

        // Obtener el inventario disponible de un producto por su ID
        public async Task<int> ObtenerInventarioDisponible(int productoId)
        {
            var producto = await _productoRepository.GetProductoById(productoId);
            if (producto != null)
            {
                return producto.Inventario;
            }
            throw new Exception("Producto no encontrado");
        }
    }
}
