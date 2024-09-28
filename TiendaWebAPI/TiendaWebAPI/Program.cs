using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using TiendaWebAPI.Data;
using TiendaWebAPI.Repositories;
using TiendaWebAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// Habilitar CORS para todas las orígenes (desarrollo, en producción se debe limitar)
builder.Services.AddCors(options =>
{
    options.AddPolicy("PermitirTodo", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

// Habilitar Swagger y servicios de la API
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Tienda API", Version = "v1" });

    // Configurar JWT para Swagger
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Por favor ingrese el token JWT con el prefijo 'Bearer '",
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});

// Configurar DbContext para UsuariosDB
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("UserConnection")));

// Configurar DbContext para ProductosDB
builder.Services.AddDbContext<ProductosDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("ProductosConnection")));

// Configurar DbContext para PedidosDB
builder.Services.AddDbContext<PedidosDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("ProductosConnection")));

// Registrar los repositorios y servicios para Usuarios
builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>();
builder.Services.AddScoped<IUsuarioService, UsuarioService>();

// Registrar los repositorios y servicios para Productos
builder.Services.AddScoped<IProductoRepository, ProductoRepository>();
builder.Services.AddScoped<IProductoService, ProductoService>();

// Registrar los repositorios y servicios para Pedidos
builder.Services.AddScoped<IPedidoRepository, PedidoRepository>();
builder.Services.AddScoped<IPedidoService, PedidoService>();

// Configurar autenticación JWT
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = "TiendaWebAPIin",  // Emisor (API)
        ValidAudience = "TiendaWebAPIout",  // Audiencia (clientes)
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("EstamosUtilizadnoJWTParaCifrarLaInfoamcioYPideTextoLargo"))  // Clave secreta
    };
});

builder.Services.AddControllers();

var app = builder.Build();

// Configurar CORS antes de Swagger
app.UseCors("PermitirTodo");

// Redirigir la raíz a index.html
app.Use(async (context, next) =>
{
    if (context.Request.Path == "/")
    {
        context.Response.Redirect("/index.html");
        return;
    }
    await next();
});

// Habilitar Swagger solo en desarrollo
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Tienda API v1");
        c.RoutePrefix = string.Empty; // Para acceder a Swagger en la raíz
    });

    // Redirigir /swagger directamente a /index.html
    app.Use(async (context, next) =>
    {
        if (context.Request.Path == "/swagger")
        {
            context.Response.Redirect("/index.html");
            return;
        }

        await next();
    });
}

app.UseHttpsRedirection();
app.UseAuthentication(); // Autenticación antes de autorización
app.UseAuthorization();  // Autorizar acceso a los endpoints
app.MapControllers();

app.Run();
