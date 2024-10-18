using TeindaDePrueba.DTOs;
using TeindaDePrueba.Services;
using System.Collections.Generic;
using System.Threading.Tasks;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Coordinators
{
    public class UsuarioCoordinator
    {
        private readonly IUsuarioService _usuarioService;

        public UsuarioCoordinator(IUsuarioService usuarioService)
        {
            _usuarioService = usuarioService;
        }

        // Obtener todos los usuarios con validaciones básicas
        public async Task<List<UsuarioDTO>> ObtenerUsuariosCoordinadosAsync()
        {
            var usuarios = await _usuarioService.GetUsuariosAsync();

            if (usuarios != null)
            {
                // Validar los datos y reemplazar valores nulos o vacíos
                foreach (var usuario in usuarios)
                {
                    usuario.UsU_NID = usuario.UsU_NID > 0 ? usuario.UsU_NID : -1; // Validación para el ID
                    usuario.UsU_CNOMBRE_COMPLETO = string.IsNullOrEmpty(usuario.UsU_CNOMBRE_COMPLETO)
                        ? "Nombre no disponible"
                        : usuario.UsU_CNOMBRE_COMPLETO;  // Validación para el nombre completo
                    usuario.RolNombre = string.IsNullOrEmpty(usuario.RolNombre)
                        ? "Rol no disponible"
                        : usuario.RolNombre;  // Validación para el rol del usuario
                }
            }

            return usuarios;
        }

        // Obtener un usuario por ID con validaciones
        public async Task<UsuarioDTO> ObtenerUsuarioPorIdAsync(int id)
        {
            var usuario = await _usuarioService.GetUsuarioByIdAsync(id);

            if (usuario != null)
            {
                // Validar los datos y reemplazar valores nulos o vacíos
                usuario.UsU_CNOMBRE_COMPLETO = string.IsNullOrEmpty(usuario.UsU_CNOMBRE_COMPLETO)
                    ? "No disponible"
                    : usuario.UsU_CNOMBRE_COMPLETO;
                usuario.RolNombre = string.IsNullOrEmpty(usuario.RolNombre)
                    ? "No disponible"
                    : usuario.RolNombre;
                usuario.UsU_CUSUARIO = string.IsNullOrEmpty(usuario.UsU_CUSUARIO)
                    ? "No disponible"
                    : usuario.UsU_CUSUARIO;

                // Validar fecha de creación
                usuario.UsU_DCREACION = usuario.UsU_DCREACION != DateTime.MinValue
                    ? DateTime.Parse(usuario.UsU_DCREACION.ToString("dd/MM/yyyy"))
                    : DateTime.MinValue;
            }

            return usuario;
        }

        // Eliminar un usuario de forma coordinada
        public async Task<bool> EliminarUsuarioCoordinadoAsync(int usuarioId)
        {
            return await _usuarioService.EliminarUsuarioAsync(usuarioId);
        }

        // Crear un nuevo usuario de forma coordinada
        public async Task<bool> CrearUsuarioCoordinadoAsync(ModelUsuario usuarioNuevo)
        {
            var exito = await _usuarioService.CrearUsuarioAsync(usuarioNuevo);
            return exito;
        }

        // Actualizar un usuario de forma coordinada
        public async Task<bool> ActualizarUsuarioCoordinadoAsync(int id, UsuarioActualizarModel usuarioActualizar)
        {
            // No enviar la contraseña si es nula o vacía
            if (string.IsNullOrEmpty(usuarioActualizar.Contrasena))
            {
                usuarioActualizar.Contrasena = null;
            }
            return await _usuarioService.ActualizarUsuarioAsync(id, usuarioActualizar);
        }
    }
}
