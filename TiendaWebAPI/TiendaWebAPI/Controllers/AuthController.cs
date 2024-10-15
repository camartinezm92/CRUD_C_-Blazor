using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using TiendaWebAPI.Data;
using TiendaWebAPI.Models;
using TiendaWebAPI.Services;

namespace TiendaWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUsuarioService _usuarioService;
        private readonly ApplicationDbContext _context; // Agregado

        // Constructor: Inicializa el servicio de usuarios y el contexto de la base de datos
        public AuthController(IUsuarioService usuarioService, ApplicationDbContext context)
        {
            _usuarioService = usuarioService;
            _context = context;
        }

        // Login: Verifica las credenciales de usuario
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
        {
            // Mostrar el usuario ingresado
            Console.WriteLine($"Usuario ingresado: {loginRequest.Usuario}");

            var usuario = await _usuarioService.GetUsuarioByNombre(loginRequest.Usuario);

            // Verificar si se encontró el usuario
            if (usuario == null)
            {
                Console.WriteLine("Usuario no encontrado.");
                return Unauthorized(new { mensaje = "Usuario o contraseña incorrecta." });
            }

            // Mostrar el usuario encontrado
            //Console.WriteLine($"Usuario encontrado: {usuario.USU_CUSUARIO}, ID: {usuario.USU_NID}");

            // Obtener el hash de la contraseña almacenada
            string contrasenaAlmacenada = BitConverter.ToString(usuario.USU_CPASSWORD).Replace("-", "").ToLower();
            Console.WriteLine($"Hash de la contraseña almacenada: {contrasenaAlmacenada}");

            // Imprimir la contraseña ingresada
            // Console.WriteLine($"Contraseña ingresada: {loginRequest.Contrasena}");

            // Calcular el hash de la contraseña ingresada utilizando el procedimiento almacenado
            var parameters = new SqlParameter[] { new SqlParameter("@PI_CCONTRASENA", loginRequest.Contrasena) };

            var hashIngresadoList = await _context.ExecuteStoredProcedure(
                "SPR_GI__HASH_CONTRASENA",
                reader => (byte[])reader["HashedPassword"],
                parameters
            );

            // Verificar que hashIngresado tenga al menos un resultado
            if (hashIngresadoList != null && hashIngresadoList.Count > 0)
            {
                var hashIngresado = hashIngresadoList[0]; // Toma el primer elemento

                // Comparar el hash de la contraseña ingresada con el hash almacenado
                bool contrasenaValida = hashIngresado.SequenceEqual(usuario.USU_CPASSWORD);

                // Mostrar si la contraseña es válida
                if (contrasenaValida)
                {
                    Console.WriteLine("Contraseña encontrada en la base de datos.");
                    var token = GenerarJwt(usuario);

                    return Ok(new
                    {
                        mensaje = "Login exitoso.",
                        token = token,
                        usuarioId = usuario.USU_NID,
                        rol = usuario.RolNombre
                    });
                }
            }

            Console.WriteLine("Contraseña incorrecta.");
            return Unauthorized(new { mensaje = "Usuario o contraseña incorrecta." });
        }

        // GenerarJwt: Crea un token JWT para el usuario autenticado
        private string GenerarJwt(Usuario usuario)
        {
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, usuario.USU_CUSUARIO),
                new Claim("usuarioId", usuario.USU_NID.ToString()),
                new Claim(ClaimTypes.Role, usuario.RolNombre)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("EstamosUtilizadnoJWTParaCifrarLaInfoamcioYPideTextoLargo"));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: "TiendaWebAPIin",
                audience: "TiendaWebAPIout",
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
