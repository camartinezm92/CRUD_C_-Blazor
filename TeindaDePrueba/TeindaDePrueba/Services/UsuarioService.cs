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
    public class UsuarioService : IUsuarioService
    {
        private readonly HttpClient _httpClient;
        private readonly CustomAuthStateProvider _authStateProvider;

        public UsuarioService(HttpClient httpClient, CustomAuthStateProvider authStateProvider)
        {
            _httpClient = httpClient;
            _authStateProvider = authStateProvider;
        }

        // Obtener todos los usuarios
        public async Task<List<UsuarioDTO>> GetUsuariosAsync()
        {
            Console.WriteLine("Iniciando la solicitud de usuarios...");

            var token = await _authStateProvider.GetTokenAsync();
            Console.WriteLine("Token en usuarios: " + token);

            if (string.IsNullOrEmpty(token))
            {
                Console.WriteLine("No se encontró un token de autenticación.");
                return null;
            }

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            try
            {
                var response = await _httpClient.GetAsync("https://localhost:7054/api/Usuarios");

                if (response.IsSuccessStatusCode)
                {
                    var jsonResponse = await response.Content.ReadAsStringAsync();
                    Console.WriteLine("Datos crudos de la API: " + jsonResponse);

                    var usuarios = await response.Content.ReadFromJsonAsync<List<UsuarioDTO>>();

                    if (usuarios != null)
                    {
                        foreach (var usuario in usuarios)
                        {
                            Console.WriteLine($"ID: {usuario.UsU_NID} - Nombre: {usuario.UsU_CNOMBRE_COMPLETO ?? "No disponible"} - Rol: {usuario.RolNombre}");
                        }
                    }

                    return usuarios;
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

        // Obtener un usuario por su ID
        public async Task<UsuarioDTO> GetUsuarioByIdAsync(int id)
        {
            var token = await _authStateProvider.GetTokenAsync();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.GetAsync($"https://localhost:7054/api/Usuarios/{id}");

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<UsuarioDTO>();
            }

            return null;
        }

        // Eliminar un usuario por su ID
        public async Task<bool> EliminarUsuarioAsync(int id)
        {
            var token = await _authStateProvider.GetTokenAsync();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.DeleteAsync($"https://localhost:7054/api/Usuarios/{id}");
            return response.IsSuccessStatusCode;
        }

        // Actualizar un usuario existente
        public async Task<bool> ActualizarUsuarioAsync(int id, UsuarioActualizarModel usuarioActualizar)
        {
            var response = await _httpClient.PutAsJsonAsync($"https://localhost:7054/api/Usuarios/{id}", usuarioActualizar);
            return response.IsSuccessStatusCode;
        }

        // Crear un nuevo usuario
        public async Task<bool> CrearUsuarioAsync(ModelUsuario usuarioNuevo)
        {
            var response = await _httpClient.PostAsJsonAsync("https://localhost:7054/api/Usuarios", usuarioNuevo);
            return response.IsSuccessStatusCode;
        }
    }
}
