using TiendaWebAPI.Models;

namespace TiendaWebAPI.Services
{
    public interface IPedidoService
    {
        Task<IEnumerable<Pedido>> GetPedidos();
        Task<Pedido> GetPedidoById(int id);
        Task CreatePedido(Pedido pedido);
        Task UpdatePedido(Pedido pedido);
        Task DeletePedido(int id);
        Task<IEnumerable<Pedido>> GetPedidosByUsuarioId(int usuarioId);

    }
}
