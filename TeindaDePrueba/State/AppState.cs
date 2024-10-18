namespace TeindaDePrueba.State
{
    public class AppState
    {
        public string Token { get; private set; }  // Almacena el token de autenticación
        public string Rol { get; private set; }    // Almacena el rol del usuario
        public int UsuarioId { get; private set; } // Almacena el ID del usuario

        public event Action OnChange;  // Evento que se dispara cuando cambia el estado

        // Método para establecer el token, rol y ID del usuario, y notificar el cambio de estado
        public void SetTokenAndRole(string token, string rol, int usuarioId)
        {
            Token = token;
            Rol = rol;
            UsuarioId = usuarioId;
            NotifyStateChanged();  // Notifica que el estado ha cambiado
        }

        // Método para obtener el ID del usuario actual
        public int GetUsuarioId()
        {
            return UsuarioId;  // Devuelve el ID del usuario
        }

        // Método privado para notificar cambios de estado
        private void NotifyStateChanged() => OnChange?.Invoke();
    }
}
