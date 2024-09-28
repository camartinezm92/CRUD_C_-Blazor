using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TiendaWebAPI.Models;
using TiendaWebAPI.Services;

[ApiController]
[Route("api/[controller]")]
public class ProductosController : ControllerBase
{
    private readonly IProductoService _productoService;

    // Constructor: Inicializa el servicio de productos
    public ProductosController(IProductoService productoService)
    {
        _productoService = productoService;
    }

    // Método para obtener la lista de productos
    [Authorize(Roles = "Admin,Empleado,Cliente")]
    [HttpGet]
    public async Task<IActionResult> GetProductos()
    {
        try
        {
            var productos = await _productoService.GetProductos();
            return Ok(productos);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para obtener un producto por su ID
    [Authorize(Roles = "Admin,Empleado,Cliente")]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetProductoById(int id)
    {
        try
        {
            var producto = await _productoService.GetProductoById(id);
            if (producto == null)
            {
                return NotFound("Producto no encontrado.");
            }
            return Ok(producto);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para crear un nuevo producto
    [Authorize(Roles = "Admin,Empleado")]
    [HttpPost]
    public async Task<IActionResult> CreateProducto([FromBody] Producto producto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            await _productoService.CreateProducto(producto);
            return CreatedAtAction(nameof(GetProductoById), new { id = producto.Id }, producto);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para actualizar un producto existente
    [Authorize(Roles = "Admin,Empleado")]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateProducto(int id, [FromBody] Producto producto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var productoExistente = await _productoService.GetProductoById(id);
            if (productoExistente == null)
            {
                return NotFound("Producto no encontrado.");
            }

            productoExistente.Nombre = producto.Nombre;
            productoExistente.Descripcion = producto.Descripcion;
            productoExistente.Precio = producto.Precio;
            productoExistente.Inventario = producto.Inventario;
            productoExistente.ImagenUrl = producto.ImagenUrl;

            await _productoService.UpdateProducto(productoExistente);
            return Ok(new { message = "Producto actualizado correctamente." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Método para eliminar un producto
    [Authorize(Roles = "Admin,Empleado")]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteProducto(int id)
    {
        try
        {
            var productoExistente = await _productoService.GetProductoById(id);
            if (productoExistente == null)
            {
                return NotFound("Producto no encontrado.");
            }

            await _productoService.DeleteProducto(id);
            return Ok(new { message = "Producto eliminado correctamente." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }
}
