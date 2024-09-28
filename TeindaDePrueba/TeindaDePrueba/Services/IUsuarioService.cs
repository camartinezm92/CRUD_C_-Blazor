using TeindaDePrueba.DTOs;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Services
{
    public interface IUsuarioService
    {
        Task<List<UsuarioDTO>> GetUsuariosAsync();
        Task<UsuarioDTO> GetUsuarioByIdAsync(int id);
        Task<bool> EliminarUsuarioAsync(int id);
        Task<bool> CrearUsuarioAsync(ModelUsuario usuarioNuevo);
        Task<bool> ActualizarUsuarioAsync(int id, UsuarioActualizarModel usuarioActualizar);


    }
}
