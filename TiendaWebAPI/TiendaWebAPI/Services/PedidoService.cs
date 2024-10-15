using TiendaWebAPI.Models;
using TiendaWebAPI.Repositories;

namespace TiendaWebAPI.Services
{
    public class PedidoService : IPedidoService
    {
        private readonly IPedidoRepository _pedidoRepository;
        private readonly IProductoService _productoService;

        // Constructor: Inicializa los repositorios de pedidos y productos
        public PedidoService(IPedidoRepository pedidoRepository, IProductoService productoService)
        {
            _pedidoRepository = pedidoRepository;
            _productoService = productoService;
        }

        // Obtener la lista de todos los pedidos
        public async Task<IEnumerable<Pedido>> GetPedidos()
        {
            return await _pedidoRepository.GetPedidos();
        }

        // Obtener un pedido por su ID
        public async Task<Pedido> GetPedidoById(int id)
        {
            return await _pedidoRepository.GetPedidoById(id);
        }

        // Obtener todos los pedidos de un usuario por su ID
        public async Task<IEnumerable<Pedido>> GetPedidosByUsuarioId(int usuarioId)
        {
            return await _pedidoRepository.GetPedidosByUsuarioId(usuarioId);
        }

        // Crear un nuevo pedido, validando el inventario de los productos
        public async Task CreatePedido(Pedido pedido)
        {
            foreach (var producto in pedido.Productos)
            {
                var inventarioDisponible = await _productoService.ObtenerInventarioDisponible(producto.ProductoId);
                if (producto.Cantidad > inventarioDisponible)
                {
                    throw new System.ArgumentException($"No hay suficiente inventario para el producto {producto.NombreProducto}.");
                }
            }
            await _pedidoRepository.CreatePedido(pedido);
        }

        // Actualizar un pedido existente, validando el inventario de los productos
        public async Task UpdatePedido(Pedido pedido)
        {
            foreach (var producto in pedido.Productos)
            {
                var inventarioDisponible = await _productoService.ObtenerInventarioDisponible(producto.ProductoId);
                if (producto.Cantidad > inventarioDisponible)
                {
                    throw new System.ArgumentException($"No hay suficiente inventario para el producto {producto.NombreProducto}.");
                }
            }
            await _pedidoRepository.UpdatePedido(pedido);
        }

        // Eliminar un pedido por su ID
        public async Task DeletePedido(int id)
        {
            await _pedidoRepository.DeletePedido(id);
        }
    }
}
