using System.Collections.Generic;
using System.Threading.Tasks;
using TiendaWebAPI.Models;

namespace TiendaWebAPI.Repositories
{
    public interface IPedidoRepository
    {
        Task<Pedido> CreatePedido(Pedido pedido);
        Task<Pedido> UpdatePedido(Pedido pedido);
        Task<int> DeletePedido(int id);
        Task<IEnumerable<Pedido>> GetPedidos();
        Task<Pedido> GetPedidoById(int id);
        Task<IEnumerable<Pedido>> GetPedidosByUsuarioId(int usuarioId);

    }
}
