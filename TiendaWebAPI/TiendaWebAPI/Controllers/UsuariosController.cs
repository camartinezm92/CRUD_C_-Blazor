using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TiendaWebAPI.Models;
using TiendaWebAPI.Services;

[ApiController]
[Route("api/[controller]")]
public class UsuariosController : ControllerBase
{
    private readonly IUsuarioService _usuarioService;

    // Constructor: Inicializa el servicio de usuarios
    public UsuariosController(IUsuarioService usuarioService)
    {
        _usuarioService = usuarioService;
    }

    // Método para obtener la lista de usuarios (solo Admin)
    [Authorize(Roles = "Admin")]
    [HttpGet]
    public async Task<IActionResult> GetUsuarios()
    {
        try
        {
            var usuarios = await _usuarioService.GetUsuarios();
            return Ok(usuarios);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para obtener un usuario por ID (Admin, Empleado, Cliente)
    [Authorize(Roles = "Admin,Empleado,Cliente")]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetUsuarioById(int id)
    {
        var usuarioAutenticadoId = int.Parse(User.FindFirst("usuarioId")?.Value);

        if (id != usuarioAutenticadoId && !User.IsInRole("Admin"))
        {
            return Forbid(); // Prohibido si no es el propietario o un admin
        }

        try
        {
            var usuario = await _usuarioService.GetUsuarioById(id);
            if (usuario == null)
            {
                return NotFound("Usuario no encontrado.");
            }
            return Ok(usuario);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para crear un nuevo usuario
    [HttpPost]
    public async Task<IActionResult> CreateUsuario([FromBody] Usuario usuario)
    {
        if (User.Identity.IsAuthenticated && !User.IsInRole("Admin"))
        {
            return Forbid(); // Prohibido si ya está autenticado y no es admin
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            await _usuarioService.CreateUsuario(usuario);
            return CreatedAtAction(nameof(GetUsuarioById), new { id = usuario.USU_NID }, usuario);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para actualizar un usuario (Admin, Empleado, Cliente)
    [Authorize(Roles = "Admin,Empleado,Cliente")]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateUsuario(int id, [FromBody] ActualizarUsuarioModel usuario)
    {
        var usuarioAutenticadoId = int.Parse(User.FindFirst("usuarioId")?.Value);

        if (id != usuarioAutenticadoId && !User.IsInRole("Admin"))
        {
            return Forbid(); // Prohibido si no es el propietario o un admin
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var usuarioExistente = await _usuarioService.GetUsuarioById(id);
            if (usuarioExistente == null)
            {
                return NotFound("Usuario no encontrado.");
            }

            usuarioExistente.USU_CUSUARIO = usuario.NombreUsuario;
            usuarioExistente.USU_CNOMBRE_COMPLETO = usuario.NombreCompleto;
            usuarioExistente.USU_NROL_ID = usuario.RolId;

            // Si se proporciona una nueva contraseña, actualízala
            if (!string.IsNullOrEmpty(usuario.Contrasena))
            {
                usuarioExistente.USU_CCONTRASENA = usuario.Contrasena;
            }

            await _usuarioService.UpdateUsuario(usuarioExistente);
            return Ok(new { message = "Usuario actualizado correctamente." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para eliminar un usuario (Admin, Empleado, Cliente)
    [Authorize(Roles = "Admin,Empleado,Cliente")]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUsuario(int id)
    {
        var usuarioAutenticadoId = int.Parse(User.FindFirst("usuarioId")?.Value);

        if (id != usuarioAutenticadoId && !User.IsInRole("Admin"))
        {
            return Forbid(); // Prohibido si no es el propietario o un admin
        }

        try
        {
            await _usuarioService.DeleteUsuario(id);
            return Ok(new { message = "Usuario eliminado correctamente." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }
}
