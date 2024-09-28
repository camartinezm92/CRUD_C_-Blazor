using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace TiendaWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PruebaController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        // Constructor: Inicializa la configuración
        public PruebaController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Método para probar la conexión a SQL Server
        [HttpGet("probar-conexion")]
        public IActionResult ProbarConexion()
        {
            string connectionString = _configuration.GetConnectionString("UserConnection");

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    return Ok("Conexión a SQL Server exitosa.");
                }
                catch (SqlException ex)
                {
                    return StatusCode(500, "Error al conectar a SQL Server: " + ex.Message);
                }
            }
        }
    }
}
