namespace TiendaWebAPI.Models
{
    public class Usuario
    {
        public int USU_NID { get; set; }
        public string USU_CUSUARIO { get; set; }
        public string USU_CNOMBRE_COMPLETO { get; set; }
        public string USU_CCONTRASENA { get; set; } // Contraseña en texto plano
        public int USU_NROL_ID { get; set; }
        public DateTime USU_DCREACION { get; set; }
        public string? RolNombre { get; set; } // Solo para obtener el nombre del rol si es necesario
        public byte[]? USU_CPASSWORD { get; internal set; }
    }
}

