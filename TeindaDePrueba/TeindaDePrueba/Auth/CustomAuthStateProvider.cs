using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Text.Json;
using TeindaDePrueba.State;  // Asegúrate de tener este namespace para usar AppState
using Blazored.LocalStorage;  // Requiere el paquete NuGet Blazored.LocalStorage
using System;

namespace TeindaDePrueba.Auth
{
    public class CustomAuthStateProvider : AuthenticationStateProvider
    {
        private readonly AppState _appState;  // Manejo centralizado del estado global de la aplicación
        private readonly ILocalStorageService _localStorage;  // Almacenamiento local del token

        public CustomAuthStateProvider(AppState appState, ILocalStorageService localStorage)
        {
            _appState = appState;
            _localStorage = localStorage;
        }

        // Obtener el estado de autenticación actual
        public override async Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            var token = await _localStorage.GetItemAsync<string>("authToken");
            ClaimsIdentity identity;

            if (!string.IsNullOrEmpty(token))
            {
                identity = new ClaimsIdentity(ParseClaimsFromJwt(token), "jwtAuthType");
                // Almacenar token, rol y usuarioId en el AppState
                _appState.SetTokenAndRole(token, GetClaimValue(token, "role"), int.Parse(GetClaimValue(token, "usuarioId")));
            }
            else
            {
                identity = new ClaimsIdentity();
            }

            var user = new ClaimsPrincipal(identity);
            return new AuthenticationState(user);
        }

        // Marcar al usuario como autenticado y almacenar el token
        public async Task MarkUserAsAuthenticated(string token, int usuarioId, string rol)
        {
            _appState.SetTokenAndRole(token, rol, usuarioId);
            await _localStorage.SetItemAsync("authToken", token);

            var authenticatedUser = new ClaimsPrincipal(new ClaimsIdentity(ParseClaimsFromJwt(token), "jwtAuthType"));
            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(authenticatedUser)));
        }

        // Cerrar sesión, limpiando almacenamiento local y AppState
        public async Task LogoutAsync()
        {
            await _localStorage.RemoveItemAsync("authToken");
            _appState.SetTokenAndRole(null, null, 0);

            var anonymousUser = new ClaimsPrincipal(new ClaimsIdentity());
            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(anonymousUser)));
        }

        // Obtener el token actual del AppState
        public Task<string> GetTokenAsync()
        {
            return Task.FromResult(_appState.Token);
        }

        // Obtener el rol actual del usuario autenticado
        public Task<string> GetRolAsync()
        {
            return Task.FromResult(_appState.Rol);
        }

        // Obtener el ID del usuario autenticado
        public Task<int> GetUsuarioIdAsync()
        {
            return Task.FromResult(_appState.UsuarioId);
        }

        // Extraer los claims del token JWT
        private IEnumerable<Claim> ParseClaimsFromJwt(string jwt)
        {
            var payload = jwt.Split('.')[1];
            var jsonBytes = ParseBase64WithoutPadding(payload);
            var keyValuePairs = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonBytes);
            return keyValuePairs.Select(kvp => new Claim(kvp.Key, kvp.Value.ToString()));
        }

        // Decodificar Base64 sin relleno para procesar el token JWT
        private byte[] ParseBase64WithoutPadding(string base64)
        {
            switch (base64.Length % 4)
            {
                case 2: base64 += "=="; break;
                case 3: base64 += "="; break;
            }
            return Convert.FromBase64String(base64);
        }

        // Obtener el valor de un claim específico del token JWT
        private string GetClaimValue(string jwt, string claimType)
        {
            var claims = ParseClaimsFromJwt(jwt);
            return claims.FirstOrDefault(c => c.Type == claimType)?.Value;
        }
    }
}
