using System.Net.Http.Headers;
using TeindaDePrueba.Auth;
using TeindaDePrueba.DTOs;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using System.Collections.Generic;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Services
{
    public class ProductoService : IProductoService
    {
        private readonly HttpClient _httpClient;
        private readonly CustomAuthStateProvider _authStateProvider;

        public ProductoService(HttpClient httpClient, CustomAuthStateProvider authStateProvider)
        {
            _httpClient = httpClient;
            _authStateProvider = authStateProvider;
        }

        // Obtener todos los productos
        public async Task<List<ProductoDTO>> GetProductosAsync()
        {
            var token = await _authStateProvider.GetTokenAsync();
            Console.WriteLine("Token en productos: " + token);

            if (string.IsNullOrEmpty(token))
            {
                Console.WriteLine("No se encontró un token de autenticación.");
                return null;
            }

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            try
            {
                var response = await _httpClient.GetAsync("https://localhost:7054/api/Productos");

                if (response.IsSuccessStatusCode)
                {
                    // Convertir la respuesta en una lista de ProductoDTO
                    return await response.Content.ReadFromJsonAsync<List<ProductoDTO>>();
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

        // Obtener un producto por su ID
        public async Task<ProductoDTO> GetProductoByIdAsync(int id)
        {
            var token = await _authStateProvider.GetTokenAsync();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.GetAsync($"https://localhost:7054/api/Productos/{id}");
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<ProductoDTO>();
            }

            return null;
        }

        // Eliminar un producto por su ID
        public async Task<bool> EliminarProductoAsync(int id)
        {
            var token = await _authStateProvider.GetTokenAsync();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.DeleteAsync($"https://localhost:7054/api/Productos/{id}");
            return response.IsSuccessStatusCode;
        }

        // Crear un nuevo producto
        public async Task<bool> CrearProductoAsync(ModelProducto producto)
        {
            var token = await _authStateProvider.GetTokenAsync();

            if (string.IsNullOrEmpty(token))
            {
                Console.WriteLine("Token de autenticación no encontrado.");
                return false;
            }

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.PostAsJsonAsync("https://localhost:7054/api/Productos", producto);

            return response.IsSuccessStatusCode;
        }

        // Actualizar un producto existente
        public async Task<bool> ActualizarProductoAsync(int id, ProductoActualizarModel productoActualizado)
        {
            var response = await _httpClient.PutAsJsonAsync($"https://localhost:7054/api/Productos/{id}", productoActualizado);
            return response.IsSuccessStatusCode;
        }
    }
}
