using Microsoft.Data.SqlClient;
using TiendaWebAPI.Data;
using TiendaWebAPI.Models;

namespace TiendaWebAPI.Repositories
{
    public class ProductoRepository : IProductoRepository
    {
        private readonly ProductosDbContext _context;

        // Constructor: Inicializa el contexto de base de datos para productos
        public ProductoRepository(ProductosDbContext context)
        {
            _context = context;
        }

        // Obtener la lista de todos los productos
        public async Task<IEnumerable<Producto>> GetProductos()
        {
            return await _context.ExecuteStoredProcedure(
                "SPR_GET_LISTAR_PRODUCTOS",
                reader => new Producto
                {
                    Id = (int)reader["Id"],
                    Nombre = reader["Nombre"].ToString(),
                    Descripcion = reader["Descripcion"].ToString(),
                    Precio = (decimal)reader["Precio"],
                    Inventario = (int)reader["Inventario"],
                    ImagenUrl = reader["Imagen"]?.ToString()
                }
            );
        }

        // Obtener un producto por su ID
        public async Task<Producto> GetProductoById(int id)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NID", id)
            };

            var productos = await _context.ExecuteStoredProcedure(
                "SPR_GET_OBTENER_PRODUCTO_POR_ID",
                reader => new Producto
                {
                    Id = (int)reader["Id"],
                    Nombre = reader["Nombre"].ToString(),
                    Descripcion = reader["Descripcion"].ToString(),
                    Precio = (decimal)reader["Precio"],
                    Inventario = (int)reader["Inventario"],
                    ImagenUrl = reader["Imagen"]?.ToString()
                },
                parameters
            );

            return productos.FirstOrDefault();
        }

        // Crear un nuevo producto
        public async Task CreateProducto(Producto producto)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_CNOMBRE", producto.Nombre),
                new SqlParameter("@PI_CDESCRIPCION", producto.Descripcion ?? (object)DBNull.Value),
                new SqlParameter("@PI_NPRECIO", producto.Precio),
                new SqlParameter("@PI_NINVENTARIO", producto.Inventario),
                new SqlParameter("@PI_CIMAGEN_URL", producto.ImagenUrl ?? (object)DBNull.Value)
            };

            await _context.ExecuteStoredProcedure("SPR_INS_CREAR_PRODUCTO", reader => { return true; }, parameters);
        }

        // Actualizar un producto existente
        public async Task UpdateProducto(Producto producto)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NID", producto.Id),
                new SqlParameter("@PI_CNOMBRE", producto.Nombre),
                new SqlParameter("@PI_CDESCRIPCION", producto.Descripcion ?? (object)DBNull.Value),
                new SqlParameter("@PI_NPRECIO", producto.Precio),
                new SqlParameter("@PI_NINVENTARIO", producto.Inventario),
                new SqlParameter("@PI_CIMAGEN_URL", producto.ImagenUrl ?? (object)DBNull.Value)
            };

            await _context.ExecuteStoredProcedure("SPR_UPD_ACTUALIZAR_PRODUCTO", reader => { return true; }, parameters);
        }

        // Eliminar un producto por su ID
        public async Task DeleteProducto(int id)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NID", id)
            };

            try
            {
                await _context.ExecuteStoredProcedure("SPR_DEL_ELIMINAR_PRODUCTO", reader => { return true; }, parameters);
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547) // Error por restricción de clave foránea
                {
                    throw new InvalidOperationException("No se puede eliminar el producto porque está asociado a un pedido.");
                }
                else
                {
                    throw;
                }
            }
        }
    }
}
