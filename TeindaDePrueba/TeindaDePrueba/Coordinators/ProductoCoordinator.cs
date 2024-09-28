using TeindaDePrueba.DTOs;
using TeindaDePrueba.Services;
using System.Collections.Generic;
using System.Threading.Tasks;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Coordinators
{
    public class ProductoCoordinator
    {
        private readonly IProductoService _productoService;

        public ProductoCoordinator(IProductoService productoService)
        {
            _productoService = productoService;
        }

        // Obtener todos los productos coordinados con validaciones básicas
        public async Task<List<ProductoDTO>> ObtenerProductosCoordinadosAsync()
        {
            var productos = await _productoService.GetProductosAsync();

            if (productos != null)
            {
                // Validaciones básicas para productos
                foreach (var producto in productos)
                {
                    producto.Id = producto.Id > 0 ? producto.Id : -1;
                    producto.Nombre = string.IsNullOrEmpty(producto.Nombre) ? "Nombre no disponible" : producto.Nombre;
                    producto.Descripcion = string.IsNullOrEmpty(producto.Descripcion) ? "Descripción no disponible" : producto.Descripcion;
                    producto.Precio = producto.Precio <= 0 ? 0 : producto.Precio;
                    producto.Inventario = producto.Inventario < 0 ? 0 : producto.Inventario;
                    producto.ImagenUrl = string.IsNullOrEmpty(producto.ImagenUrl) ? "Imagen no disponible" : producto.ImagenUrl;
                }
            }

            return productos;
        }

        // Obtener un producto por ID y validar los datos
        public async Task<ProductoDTO> ObtenerProductoPorIdAsync(int id)
        {
            var producto = await _productoService.GetProductoByIdAsync(id);

            if (producto != null)
            {
                // Validar los datos y reemplazar valores nulos o vacíos
                producto.Id = producto.Id > 0 ? producto.Id : -1;
                producto.Nombre = string.IsNullOrEmpty(producto.Nombre) ? "No disponible" : producto.Nombre;
                producto.Descripcion = string.IsNullOrEmpty(producto.Descripcion) ? "No disponible" : producto.Descripcion;
                producto.ImagenUrl = string.IsNullOrEmpty(producto.ImagenUrl) ? "No disponible" : producto.ImagenUrl;
                producto.Precio = producto.Precio <= 0 ? 0 : producto.Precio;
                producto.Inventario = producto.Inventario < 0 ? 0 : producto.Inventario;
            }
            return producto;
        }

        // Eliminar un producto de forma coordinada
        public async Task<bool> EliminarProductoCoordinadoAsync(int productoId)
        {
            return await _productoService.EliminarProductoAsync(productoId);
        }

        // Crear un nuevo producto de forma coordinada
        public async Task<bool> CrearProductoCoordinadoAsync(ModelProducto productoNuevo)
        {
            return await _productoService.CrearProductoAsync(productoNuevo);
        }

        // Actualizar un producto existente de forma coordinada
        public async Task<bool> ActualizarProductoCoordinadoAsync(int id, ProductoActualizarModel productoActualizado)
        {
            return await _productoService.ActualizarProductoAsync(id, productoActualizado);
        }
    }
}
