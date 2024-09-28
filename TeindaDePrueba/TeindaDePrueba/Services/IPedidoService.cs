using TeindaDePrueba.DTOs;
using System.Threading.Tasks;
using System.Collections.Generic;
using TeindaDePrueba.Models;


namespace TeindaDePrueba.Services
{
    public interface IPedidoService
    {
        Task<List<PedidoDTO>> GetPedidosAsync();
        Task<PedidoDTO> GetPedidoByIdAsync(int id);
        Task<bool> EliminarPedidoAsync(int id);
        Task<bool> CrearPedidoAsync(ModelPedido nuevoPedido);
        Task<bool> ActualizarPedidoAsync(int pedidoId, ModelPedido pedidoActualizado);
        Task<List<PedidoDTO>> GetPedidosByUsuarioIdAsync(int usuarioId);

    }

}

