using Microsoft.Data.SqlClient;
using System.Data;
using TiendaWebAPI.Data;
using TiendaWebAPI.Models;

namespace TiendaWebAPI.Repositories
{
    public class PedidoRepository : IPedidoRepository
    {
        private readonly ProductosDbContext _context;

        // Constructor: Inicializa el contexto de base de datos para pedidos
        public PedidoRepository(ProductosDbContext context)
        {
            _context = context;
        }

        // Obtener la lista de todos los pedidos
        public async Task<IEnumerable<Pedido>> GetPedidos()
        {
            return await _context.ExecuteStoredProcedure(
                "SPR_GET_LISTAR_PEDIDOS",
                reader => new Pedido
                {
                    Id = (int)reader["PedidoId"],
                    UsuarioNombre = reader["Usuario"].ToString(),
                    CantidadTotal = (int)reader["CantidadTotalProductos"],
                    ValorTotal = (decimal)reader["CostoTotal"],
                    FechaPedido = (DateTime)reader["FechaPedido"]
                }
            );
        }

        // Obtener la lista de pedidos por ID de usuario
        public async Task<IEnumerable<Pedido>> GetPedidosByUsuarioId(int usuarioId)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NUSUARIO_ID", usuarioId)
            };

            var pedidos = await _context.ExecuteStoredProcedure(
                "SPR_GET_LISTAR_PEDIDOS_POR_USUARIO",
                reader => new Pedido
                {
                    Id = (int)reader["PedidoId"],
                    UsuarioNombre = reader["Usuario"].ToString(),
                    CantidadTotal = (int)reader["CantidadTotalProductos"],
                    ValorTotal = (decimal)reader["CostoTotal"],
                    FechaPedido = (DateTime)reader["FechaPedido"]
                },
                parameters
            );

            return pedidos;
        }

        // Obtener los detalles de un pedido por su ID
        public async Task<Pedido> GetPedidoById(int id)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NPEDIDO_ID", id)
            };

            var pedidos = await _context.ExecuteStoredProcedure(
                "SPR_GET_PEDIDO_POR_ID",
                reader => new Pedido
                {
                    Id = (int)reader["PedidoId"],
                    UsuarioId = (int)reader["UsuarioId"],
                    UsuarioNombre = reader["Usuario"].ToString(),
                    CantidadTotal = (int)reader["CantidadTotalProductos"],
                    ValorTotal = (decimal)reader["ValorTotal"],
                    FechaPedido = (DateTime)reader["FechaPedido"],
                    Productos = new List<ProductoDetalle>
                    {
                        new ProductoDetalle
                        {
                            ProductoId = (int)reader["ProductoId"],
                            NombreProducto = reader["Producto"].ToString(),
                            Cantidad = (int)reader["Cantidad"],
                            PrecioUnitario = (decimal)reader["PrecioUnitario"],
                            PrecioTotal = (decimal)reader["ValorTotalPorProducto"]
                        }
                    }
                },
                parameters
            );

            var pedido = pedidos.FirstOrDefault();

            if (pedido != null)
            {
                pedido.Productos = pedidos
                    .SelectMany(p => p.Productos)
                    .ToList();
            }

            return pedido;
        }

        // Crear un nuevo pedido
        public async Task<Pedido> CreatePedido(Pedido pedido)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NUSUARIO_ID", pedido.UsuarioId),
                new SqlParameter("@PT_PRODUCTOS", CreateProductosDataTable(pedido.Productos))
            };

            try
            {
                var result = await _context.ExecuteStoredProcedure(
                    "SPR_INS_CREAR_PEDIDO",
                    reader => new Pedido
                    {
                        Id = (int)reader["PedidoId"],
                        UsuarioNombre = reader["Usuario"].ToString(),
                        CantidadTotal = (int)reader["TotalProductos"],
                        ValorTotal = (decimal)reader["ValorTotal"],
                        FechaPedido = (DateTime)reader["FechaPedido"]
                    },
                    parameters
                );

                var pedidoCreado = result.FirstOrDefault();
                if (pedidoCreado != null)
                {
                    pedido.Id = pedidoCreado.Id;
                }
                return pedidoCreado;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al crear el pedido: {ex.Message}");
            }
        }

        // Actualizar un pedido existente
        public async Task<Pedido> UpdatePedido(Pedido pedido)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NPEDIDO_ID", pedido.Id),
                new SqlParameter("@PI_NUSUARIO_ID", pedido.UsuarioId),
                new SqlParameter("@PT_PRODUCTOS", CreateProductosDataTable(pedido.Productos))
            };

            try
            {
                var result = await _context.ExecuteStoredProcedure(
                    "SPR_UPD_ACTUALIZAR_PEDIDO",
                    reader => new Pedido
                    {
                        Id = (int)reader["PedidoId"],
                        UsuarioNombre = pedido.UsuarioNombre,
                        CantidadTotal = pedido.CantidadTotal,
                        ValorTotal = pedido.ValorTotal,
                        FechaPedido = DateTime.Now
                    },
                    parameters
                );

                var pedidoActualizado = result.FirstOrDefault();
                if (pedidoActualizado != null)
                {
                    pedido.Id = pedidoActualizado.Id;
                }

                return pedidoActualizado;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al actualizar el pedido: {ex.Message}");
            }
        }

        // Eliminar un pedido
        public async Task<int> DeletePedido(int id)
        {
            var parameters = new SqlParameter[] {
                new SqlParameter("@PI_NPEDIDO_ID", id)
            };

            await _context.ExecuteStoredProcedure("SPR_DEL_ELIMINAR_PEDIDO", reader => 0, parameters);
            return 0;
        }

        // Método privado para convertir la lista de productos en DataTable (para TVP)
        private DataTable CreateProductosDataTable(List<ProductoDetalle> productos)
        {
            var dt = new DataTable();
            dt.Columns.Add("PRO_NID", typeof(int));
            dt.Columns.Add("PEDPROD_NCANTIDAD", typeof(int));

            foreach (var producto in productos)
            {
                dt.Rows.Add(producto.ProductoId, producto.Cantidad);
            }

            return dt;
        }
    }
}
