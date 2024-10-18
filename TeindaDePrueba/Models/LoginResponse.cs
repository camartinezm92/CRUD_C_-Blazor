namespace TeindaDePrueba.Models
{
    public class LoginResponse
    {
        public string Mensaje { get; set; }
        public string Token { get; set; }
        public int UsuarioId { get; set; }
        public string Rol { get; set; }
    }
}
