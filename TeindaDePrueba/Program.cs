using Blazored.LocalStorage;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using TeindaDePrueba.Auth;
using TeindaDePrueba.Coordinators;
using TeindaDePrueba.Data;
using TeindaDePrueba.Services;
using TeindaDePrueba.State;

var builder = WebApplication.CreateBuilder(args);

// Agregar servicios al contenedor

// Servicio para almacenamiento local (Blazored)
builder.Services.AddBlazoredLocalStorage();

// Servicios esenciales de Razor Pages y Blazor Server
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

// Servicio Singleton para el pronóstico del clima (ejemplo)
builder.Services.AddSingleton<WeatherForecastService>();

// Configurar cliente HTTP para la autenticación
builder.Services.AddHttpClient<AuthService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7054/api/");
});

// Configurar cliente HTTP para Usuarios
builder.Services.AddHttpClient<IUsuarioService, UsuarioService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7054/api/");
});

// Configurar cliente HTTP para Productos
builder.Services.AddHttpClient<IProductoService, ProductoService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7054/api/");
});

// Configurar cliente HTTP para Pedidos
builder.Services.AddHttpClient<IPedidoService, PedidoService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7054/api/");
});

// Registrar coordinadores para pedidos
builder.Services.AddScoped<PedidoCoordinator>();

// Registrar AppState para gestionar el estado de la aplicación
builder.Services.AddScoped<AppState>();

// Configurar el proveedor de autenticación personalizado
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<AuthenticationStateProvider, CustomAuthStateProvider>();
builder.Services.AddScoped<CustomAuthStateProvider>();

// Registrar servicios de prueba y coordinadores
builder.Services.AddScoped<PruebaService>();
builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<UsuarioCoordinator>();
builder.Services.AddScoped<IProductoService, ProductoService>();
builder.Services.AddScoped<ProductoCoordinator>();
builder.Services.AddScoped<IPedidoService, PedidoService>();
builder.Services.AddScoped<PedidoCoordinator>();

// Configurar la autenticación y autorización en Blazor
builder.Services.AddAuthorizationCore();
builder.Services.AddBlazoredLocalStorage();  // Para el almacenamiento local (se registra nuevamente por si acaso)

var app = builder.Build();

// Configurar el pipeline de HTTP
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");  // Usar página de errores en producción
    app.UseHsts();  // Configurar HTTP Strict Transport Security (HSTS)
}

app.UseHttpsRedirection();  // Redireccionar todas las solicitudes HTTP a HTTPS
app.UseStaticFiles();  // Habilitar archivos estáticos
app.UseRouting();  // Configurar enrutamiento

// Mapear el hub de Blazor y la página de fallback
app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();  // Ejecutar la aplicación
