namespace TeindaDePrueba.Models
{
    public class ModelUsuario
    {
        public int UsU_NID { get; set; } // ID del usuario
        public string UsU_CUSUARIO { get; set; } // Nombre de usuario
        public string UsU_CNOMBRE_COMPLETO { get; set; } // Nombre completo
        public string UsU_CCONTRASENA { get; set; } // Contraseña
        public int UsU_NROL_ID { get; set; } // ID del rol
        public DateTime UsU_DCREACION { get; set; } // Fecha de creación
        public string RolNombre { get; set; } // Nombre del rol (opcional)
        public byte[] UsU_BCONTRASENA_HASH { get; set; } // Hash de contraseña (opcional)
    }

    public class UsuarioActualizarModel
    {
        public string NombreUsuario { get; set; } = string.Empty; // Nombre de usuario
        public string NombreCompleto { get; set; } = string.Empty; // Nombre completo
        public string? Contrasena { get; set; } = null; // Contraseña opcional
        public int RolId { get; set; } = 3; // Rol por defecto
    }
}
