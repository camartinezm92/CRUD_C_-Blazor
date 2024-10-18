using System.Net.Http.Headers;
using TeindaDePrueba.Auth;
using TeindaDePrueba.DTOs;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using System.Collections.Generic;
using TeindaDePrueba.Models;
using System.Text.Json;
using System.Text;

namespace TeindaDePrueba.Services
{
    public class PedidoService : IPedidoService
    {
        private readonly HttpClient _httpClient;
        private readonly CustomAuthStateProvider _authStateProvider;

        public PedidoService(HttpClient httpClient, CustomAuthStateProvider authStateProvider)
        {
            _httpClient = httpClient;
            _authStateProvider = authStateProvider;
        }

        // Obtener todos los pedidos
        public async Task<List<PedidoDTO>> GetPedidosAsync()
        {
            var token = await _authStateProvider.GetTokenAsync();
            //Console.WriteLine("Token en pedidos: " + token);

            if (string.IsNullOrEmpty(token))
            {
                //Console.WriteLine("No se encontró un token de autenticación.");
                return null;
            }

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            try
            {
                var response = await _httpClient.GetAsync("https://localhost:7054/api/Pedidos");

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<List<PedidoDTO>>();
                }
                else if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                {
                    Console.WriteLine("Token expirado o inválido.");
                    return null;
                }
                else
                {
                    Console.WriteLine($"Error en la solicitud: {response.StatusCode}");
                    return null;
                }
            }
            catch (HttpRequestException ex)
            {
                Console.WriteLine($"Error de red: {ex.Message}");
                return null;
            }
        }

        // Obtener pedido por ID
        public async Task<PedidoDTO> GetPedidoByIdAsync(int id)
        {
            var token = await _authStateProvider.GetTokenAsync();

            if (string.IsNullOrEmpty(token))
            {
                return null;
            }

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            try
            {
                var response = await _httpClient.GetAsync($"https://localhost:7054/api/Pedidos/{id}");

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<PedidoDTO>();
                }
                else
                {
                    return null;
                }
            }
            catch (HttpRequestException ex)
            {
                //Console.WriteLine($"Error de red: {ex.Message}");
                return null;
            }
        }

        // Eliminar un pedido
        public async Task<bool> EliminarPedidoAsync(int id)
        {
            var token = await _authStateProvider.GetTokenAsync();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.DeleteAsync($"https://localhost:7054/api/Pedidos/{id}");
            return response.IsSuccessStatusCode;
        }

        // Crear un nuevo pedido
        public async Task<bool> CrearPedidoAsync(ModelPedido nuevoPedido)
        {
            var token = await _authStateProvider.GetTokenAsync();

            if (string.IsNullOrEmpty(token))
            {
                return false;
            }

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.PostAsJsonAsync("https://localhost:7054/api/Pedidos", nuevoPedido);

            return response.IsSuccessStatusCode;
        }

        // Actualizar un pedido
        public async Task<bool> ActualizarPedidoAsync(int pedidoId, ModelPedido pedidoActualizado)
        {
            try
            {
                var jsonContent = JsonSerializer.Serialize(pedidoActualizado);
                var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                var response = await _httpClient.PutAsync($"https://localhost:7054/api/Pedidos/{pedidoId}", content);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Error en la actualización del pedido: {response.StatusCode} - {errorContent}");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al intentar actualizar el pedido: {ex.Message}");
                return false;
            }
        }

        // Obtener pedidos por ID de usuario
        public async Task<List<PedidoDTO>> GetPedidosByUsuarioIdAsync(int usuarioId)
        {
            var token = await _authStateProvider.GetTokenAsync();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.GetAsync($"https://localhost:7054/api/Pedidos/usuario/{usuarioId}");

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<List<PedidoDTO>>();
            }
            Console.WriteLine($"No se encontraron pedidos relacionados");
            return null;
        }
    }
}
