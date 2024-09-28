public class ActualizarUsuarioModel
{
    public string NombreUsuario { get; set; }
    public string NombreCompleto { get; set; }
    public string? Contrasena { get; set; } // Nueva propiedad opcional
    public int RolId { get; set; }
}
