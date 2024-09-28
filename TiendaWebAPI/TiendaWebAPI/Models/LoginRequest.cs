namespace TiendaWebAPI.Models
{
    public class LoginRequest
    {
        public string Usuario { get; set; }  // Nombre de usuario
        public string Contrasena { get; set; }  // Contraseña en texto plano
    }
}
