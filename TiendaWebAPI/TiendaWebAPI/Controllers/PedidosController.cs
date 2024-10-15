using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TiendaWebAPI.Models;
using TiendaWebAPI.Services;

namespace TiendaWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PedidosController : ControllerBase
    {
        private readonly IPedidoService _pedidoService;

        // Constructor: Inicializa el servicio de pedidos
        public PedidosController(IPedidoService pedidoService)
        {
            _pedidoService = pedidoService;
        }

        // Obtener todos los pedidos (solo Admin y Empleados)
        [Authorize(Roles = "Admin,Empleado")]
        [HttpGet]
        public async Task<IActionResult> GetPedidos()
        {
            try
            {
                var pedidos = await _pedidoService.GetPedidos();
                return Ok(pedidos);  // Devuelve un listado de pedidos con información básica
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // Obtener un pedido por ID
        [Authorize(Roles = "Admin,Empleado,Cliente")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPedidoById(int id)
        {
            var usuarioAutenticadoId = int.Parse(User.FindFirst("usuarioId")?.Value);

            try
            {
                var pedido = await _pedidoService.GetPedidoById(id);
                if (pedido == null)
                {
                    return NotFound("Pedido no encontrado.");
                }

                if (pedido.UsuarioId != usuarioAutenticadoId && User.IsInRole("Cliente"))
                {
                    return Forbid();
                }

                return Ok(pedido);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // Obtener pedidos por ID de usuario
        [Authorize(Roles = "Admin,Empleado,Cliente")]
        [HttpGet("usuario/{usuarioId}")]
        public async Task<IActionResult> GetPedidosByUsuarioId(int usuarioId)
        {
            try
            {
                var pedidos = await _pedidoService.GetPedidosByUsuarioId(usuarioId);
                if (pedidos == null || !pedidos.Any())
                {
                    return NotFound("No se encontraron pedidos para este usuario.");
                }
                return Ok(pedidos);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno: {ex.Message}");
            }
        }

        // Crear un pedido
        [Authorize(Roles = "Admin,Empleado,Cliente")]
        [HttpPost]
        public async Task<IActionResult> CreatePedido([FromBody] Pedido pedido)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                await _pedidoService.CreatePedido(pedido);
                return CreatedAtAction(nameof(GetPedidoById), new { id = pedido.Id }, new { mensaje = "Pedido creado exitosamente.", PedidoId = pedido.Id });
            }
            catch (System.ArgumentException ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = $"Ocurrió un error al crear el pedido: {ex.Message}" });
            }
        }

        // Actualizar un pedido
        [Authorize(Roles = "Admin,Empleado,Cliente")]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePedido(int id, [FromBody] Pedido pedido)
        {
            var usuarioAutenticadoId = int.Parse(User.FindFirst("usuarioId")?.Value);

            try
            {
                var pedidoExistente = await _pedidoService.GetPedidoById(id);
                if (pedidoExistente == null)
                {
                    return NotFound("Pedido no encontrado.");
                }

                if (pedidoExistente.UsuarioId != usuarioAutenticadoId && User.IsInRole("Cliente"))
                {
                    return Forbid();
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                pedido.Id = id;
                await _pedidoService.UpdatePedido(pedido);

                return Ok(new { mensaje = "Pedido actualizado exitosamente." });
            }
            catch (System.ArgumentException ex)
            {
                return BadRequest(new { mensaje = $"Error de validación: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = $"Error interno: {ex.Message}" });
            }
        }

        // Eliminar un pedido
        [Authorize(Roles = "Admin,Empleado,Cliente")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePedido(int id)
        {
            var usuarioAutenticadoId = int.Parse(User.FindFirst("usuarioId")?.Value);

            try
            {
                var pedidoExistente = await _pedidoService.GetPedidoById(id);
                if (pedidoExistente == null)
                {
                    return NotFound("Pedido no encontrado.");
                }

                if (pedidoExistente.UsuarioId != usuarioAutenticadoId && User.IsInRole("Cliente"))
                {
                    return Forbid();
                }

                await _pedidoService.DeletePedido(id);
                return Ok(new { mensaje = "Pedido eliminado exitosamente." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
