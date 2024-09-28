using TeindaDePrueba.DTOs;
using TeindaDePrueba.Services;
using System.Collections.Generic;
using System.Threading.Tasks;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Coordinators
{
    public class PedidoCoordinator
    {
        private readonly IPedidoService _pedidoService;

        public PedidoCoordinator(IPedidoService pedidoService)
        {
            _pedidoService = pedidoService;
        }

        // Obtener todos los pedidos coordinados, aplicando validaciones básicas
        public async Task<List<PedidoDTO>> ObtenerPedidosCoordinadosAsync()
        {
            var pedidos = await _pedidoService.GetPedidosAsync();

            if (pedidos != null)
            {
                // Validaciones básicas sobre los pedidos
                foreach (var pedido in pedidos)
                {
                    pedido.Id = pedido.Id > 0 ? pedido.Id : -1;
                    pedido.UsuarioNombre = string.IsNullOrEmpty(pedido.UsuarioNombre) ? "Nombre no disponible" : pedido.UsuarioNombre;
                    pedido.CantidadTotal = pedido.CantidadTotal <= 0 ? 0 : pedido.CantidadTotal;
                    pedido.ValorTotal = pedido.ValorTotal <= 0 ? 0 : pedido.ValorTotal;
                }
            }

            return pedidos;
        }

        // Obtener un pedido por ID con validación adicional
        public async Task<PedidoDTO> ObtenerPedidoIdCoordinadoAsync(int id)
        {
            var pedido = await _pedidoService.GetPedidoByIdAsync(id);

            if (pedido != null)
            {
                // Asegurar que la lista de productos no sea nula
                if (pedido.Productos == null || pedido.Productos.Count == 0)
                {
                    pedido.Productos = new List<ProductoPedidoDTO>(); // Inicializar lista de productos vacía
                }
            }

            return pedido;
        }

        // Eliminar un pedido de forma coordinada
        public async Task<bool> EliminarPedidoCoordinadoAsync(int pedidoId)
        {
            return await _pedidoService.EliminarPedidoAsync(pedidoId);
        }

        // Crear un nuevo pedido de forma coordinada
        public async Task<bool> CrearPedidoCoordinadoAsync(ModelPedido nuevoPedido)
        {
            return await _pedidoService.CrearPedidoAsync(nuevoPedido);
        }

        // Actualizar un pedido existente de forma coordinada
        public async Task<bool> ActualizarPedidoCoordinadoAsync(int pedidoId, ModelPedido pedidoActualizado)
        {
            return await _pedidoService.ActualizarPedidoAsync(pedidoId, pedidoActualizado);
        }

        // Obtener pedidos por ID de usuario
        public async Task<List<PedidoDTO>> ObtenerPedidosPorUsuarioIdCoordinadoAsync(int usuarioId)
        {
            return await _pedidoService.GetPedidosByUsuarioIdAsync(usuarioId);
        }
    }
}
