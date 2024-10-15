using TiendaWebAPI.Models;
using TiendaWebAPI.Repositories;

namespace TiendaWebAPI.Services
{
    public class UsuarioService : IUsuarioService
    {
        private readonly IUsuarioRepository _usuarioRepository;

        // Constructor: Inicializa el repositorio de usuarios
        public UsuarioService(IUsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        // Obtener la lista de todos los usuarios
        public async Task<IEnumerable<Usuario>> GetUsuarios()
        {
            return await _usuarioRepository.GetUsuarios();
        }

        // Obtener un usuario por su ID
        public async Task<Usuario> GetUsuarioById(int id)
        {
            return await _usuarioRepository.GetUsuarioById(id);
        }

        // Crear un nuevo usuario
        public async Task CreateUsuario(Usuario usuario)
        {
            await _usuarioRepository.CreateUsuario(usuario);
        }

        // Actualizar los datos de un usuario existente
        public async Task UpdateUsuario(Usuario usuario)
        {
            await _usuarioRepository.UpdateUsuario(usuario);
        }

        // Eliminar un usuario por su ID
        public async Task DeleteUsuario(int id)
        {
            await _usuarioRepository.DeleteUsuario(id);
        }

        // Obtener un usuario por su nombre
        public async Task<Usuario> GetUsuarioByNombre(string nombreUsuario)
        {
            return await _usuarioRepository.GetUsuarioByNombre(nombreUsuario);
        }
    }
}
