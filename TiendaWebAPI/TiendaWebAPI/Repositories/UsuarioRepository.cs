using Microsoft.Data.SqlClient;
using TiendaWebAPI.Data;
using TiendaWebAPI.Models;
using TiendaWebAPI.Repositories;
using System.Collections.Generic;
using System.Threading.Tasks;

public class UsuarioRepository : IUsuarioRepository
{
    private readonly ApplicationDbContext _context;

    // Constructor: Inicializa el contexto de base de datos
    public UsuarioRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    // Obtener la lista de todos los usuarios
    public async Task<IEnumerable<Usuario>> GetUsuarios()
    {
        return await _context.ExecuteStoredProcedure("SPR_GET_LISTAR_USUARIOS", reader =>
        {
            return new Usuario
            {
                USU_NID = (int)reader["Id"],
                USU_CNOMBRE_COMPLETO = reader["NombreCompleto"].ToString(),
                RolNombre = reader["Rol"].ToString()
            };
        });
    }

    // Obtener un usuario por su ID
    public async Task<Usuario> GetUsuarioById(int id)
    {
        var parameters = new SqlParameter[] {
           new SqlParameter("@PI_NID", id)
        };
        var result = await _context.ExecuteStoredProcedure("SPR_GET_OBTENER_USUARIO_POR_ID", reader =>
        {
            return new Usuario
            {
                USU_NID = (int)reader["Id"],
                USU_CUSUARIO = reader["NombreUsuario"].ToString(),
                USU_CNOMBRE_COMPLETO = reader["NombreCompleto"].ToString(),
                RolNombre = reader["Rol"].ToString(),
                USU_DCREACION = (DateTime)reader["FechaCreacion"]
            };
        }, parameters);

        return result.FirstOrDefault();
    }

    // Crear un nuevo usuario
    public async Task CreateUsuario(Usuario usuario)
    {
        var parameters = new SqlParameter[] {
            new SqlParameter("@PI_CUSUARIO", usuario.USU_CUSUARIO), // Nombre de usuario
            new SqlParameter("@PI_CNOMBRE_COMPLETO", usuario.USU_CNOMBRE_COMPLETO), // Nombre completo
            new SqlParameter("@PI_CCONTRASENA", usuario.USU_CCONTRASENA), // Contraseña en texto plano
            new SqlParameter("@PI_NROL_ID", usuario.USU_NROL_ID) // ID del rol
        };
        await _context.ExecuteStoredProcedure("SPR_INS_CREAR_USUARIO", reader => { return true; }, parameters);
    }

    // Actualizar un usuario existente
    public async Task UpdateUsuario(Usuario usuario)
    {
        var parameters = new SqlParameter[] {
            new SqlParameter("@PI_NID", usuario.USU_NID),
            new SqlParameter("@PI_CUSUARIO", usuario.USU_CUSUARIO),
            new SqlParameter("@PI_CNOMBRE_COMPLETO", usuario.USU_CNOMBRE_COMPLETO),
            new SqlParameter("@PI_CCONTRASENA", string.IsNullOrEmpty(usuario.USU_CCONTRASENA) ? DBNull.Value : (object)usuario.USU_CCONTRASENA),
            new SqlParameter("@PI_NROL_ID", usuario.USU_NROL_ID)
        };
        await _context.ExecuteStoredProcedure("SPR_UPD_ACTUALIZAR_USUARIO", reader => { return true; }, parameters);
    }

    // Eliminar un usuario por su ID
    public async Task DeleteUsuario(int id)
    {
        var parameters = new SqlParameter[] {
            new SqlParameter("@PI_NID", id)
        };
        await _context.ExecuteStoredProcedure("SPR_DEL_ELIMINAR_USUARIO", reader => { return true; }, parameters);
    }

    // Obtener un usuario por nombre para el login
    public async Task<Usuario> GetUsuarioByNombre(string nombreUsuario)
    {
        var parameters = new SqlParameter[] {
        new SqlParameter("@PI_CUSUARIO", nombreUsuario)
    };

        var result = await _context.ExecuteStoredProcedure(
            "SPR_GET_USUARIO_POR_NOMBRE",
            reader => new Usuario
            {
                USU_NID = (int)reader["IdUsuario"],
                USU_CUSUARIO = reader["NombreUsuario"].ToString(),
                USU_CNOMBRE_COMPLETO = reader["NombreCompleto"].ToString(),
                USU_BCONTRASENA_HASH = (byte[])reader["BContrasenaHash"],
                USU_NROL_ID = (int)reader["RolId"],
                RolNombre = reader["RolNombre"].ToString()
            },
            parameters
        );

        return result.FirstOrDefault();
    }

}
