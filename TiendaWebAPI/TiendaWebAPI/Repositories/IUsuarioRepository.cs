using TiendaWebAPI.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace TiendaWebAPI.Repositories
{
    public interface IUsuarioRepository
    {
        Task<Usuario> GetUsuarioByNombre(string nombreUsuario);
        Task<IEnumerable<Usuario>> GetUsuarios();
        Task<Usuario> GetUsuarioById(int id);
        Task CreateUsuario(Usuario usuario);
        Task UpdateUsuario(Usuario usuario);
        Task DeleteUsuario(int id);
    }
}
