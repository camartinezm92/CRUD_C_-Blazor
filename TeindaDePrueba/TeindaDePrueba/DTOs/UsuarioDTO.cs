namespace TeindaDePrueba.DTOs
{
    public class UsuarioDTO
    {
        // Identificador único del usuario
        public int UsU_NID { get; set; }

        // Nombre de usuario (login)
        public string? UsU_CUSUARIO { get; set; }

        // Nombre completo del usuario
        public string? UsU_CNOMBRE_COMPLETO { get; set; }

        // Identificador del rol asociado al usuario
        public int UsU_NROL_ID { get; set; }

        // Nombre descriptivo del rol (e.g., Admin, Empleado, Cliente)
        public string? RolNombre { get; set; }

        // Fecha en que el usuario fue creado
        public DateTime UsU_DCREACION { get; set; }
    }
}
