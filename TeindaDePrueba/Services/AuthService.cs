using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components.Authorization;
using TeindaDePrueba.Auth;
using TeindaDePrueba.Models;

namespace TeindaDePrueba.Services
{
    public class AuthService
    {
        private readonly HttpClient _httpClient;
        private readonly AuthenticationStateProvider _authenticationStateProvider;

        public AuthService(HttpClient httpClient, AuthenticationStateProvider authenticationStateProvider)
        {
            _httpClient = httpClient;
            _authenticationStateProvider = authenticationStateProvider;
        }

        public async Task<LoginResult> Login(LoginRequest loginRequest)
        {
            // Usa la ruta relativa después de la BaseAddress configurada en Program.cs
            var response = await _httpClient.PostAsJsonAsync("https://localhost:7054/api/Auth/login", loginRequest);

            if (response.IsSuccessStatusCode)
            {
                var result = await response.Content.ReadFromJsonAsync<LoginResponse>();

                // Guardar el token y la información del usuario
                await ((CustomAuthStateProvider)_authenticationStateProvider).MarkUserAsAuthenticated(result.Token, result.UsuarioId, result.Rol);

                // Mostrar en la consola el estado después de autenticarse
                Console.WriteLine("Login exitoso:");
                Console.WriteLine($"UsuarioId: {result.UsuarioId}");
                Console.WriteLine($"Rol: {result.Rol}");
                Console.WriteLine($"Token: {result.Token}");

                return new LoginResult { Success = true, Message = "Login exitoso." };
            }

            return new LoginResult { Success = false, Message = "Usuario o contraseña incorrectos." };
        }
    }
}
