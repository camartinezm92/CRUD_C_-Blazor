using System.Net.Http;
using System.Threading.Tasks;

namespace TeindaDePrueba.Services
{
    public class PruebaService
    {
        private readonly HttpClient _httpClient;

        // Inyectar HttpClient usando el nombre configurado en Program.cs
        public PruebaService(IHttpClientFactory httpClientFactory)
        {
            _httpClient = httpClientFactory.CreateClient("BackendAPI");
        }

        // Método para probar la conexión con el backend
        public async Task<string> ProbarConexionAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync("https://localhost:7054/api/Prueba/probar-conexion");
                if (response.IsSuccessStatusCode)
                {
                    // Retornar el contenido de la respuesta en caso de éxito
                    return await response.Content.ReadAsStringAsync();
                }
                else
                {
                    // En caso de error
                    return $"Error: {response.StatusCode}";
                }
            }
            catch (Exception ex)
            {
                // Manejar cualquier excepción
                return $"Error al conectar: {ex.Message}";
            }
        }
    }
}
