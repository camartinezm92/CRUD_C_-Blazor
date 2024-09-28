using Microsoft.EntityFrameworkCore;
using System.Data.Common;
using Microsoft.Data.SqlClient;
using TiendaWebAPI.Models;

namespace TiendaWebAPI.Data
{
    public class PedidosDbContext : DbContext
    {
        // Constructor: Inicializa el DbContext con las opciones proporcionadas
        public PedidosDbContext(DbContextOptions<PedidosDbContext> options)
            : base(options)
        {
        }

        // Definir la tabla de pedidos
        public DbSet<Pedido> Pedidos { get; set; }

        // Configuraciones para las entidades (OnModelCreating)
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configuraciones para Pedido: Clave primaria de Pedido
            modelBuilder.Entity<Pedido>()
                .HasKey(p => p.Id);
        }

        // Método para ejecutar procedimientos almacenados que devuelven resultados
        public async Task<List<T>> ExecuteStoredProcedure<T>(string storedProcedure, Func<DbDataReader, T> processRow, params SqlParameter[] parameters)
        {
            var results = new List<T>();
            var connection = Database.GetDbConnection();

            try
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = storedProcedure;
                    command.CommandType = System.Data.CommandType.StoredProcedure;

                    if (parameters != null)
                    {
                        foreach (var param in parameters)
                        {
                            command.Parameters.Add(param);
                        }
                    }

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            results.Add(processRow(reader));
                        }
                    }
                }
            }
            finally
            {
                if (connection.State == System.Data.ConnectionState.Open)
                {
                    await connection.CloseAsync();
                }
            }

            return results;
        }

        // Método para ejecutar procedimientos almacenados sin devolver resultados
        public async Task<int> ExecuteStoredProcedure(string storedProcedure, params SqlParameter[] parameters)
        {
            var connection = Database.GetDbConnection();
            int rowsAffected = 0;

            await using (var transaction = await Database.BeginTransactionAsync()) 
            {
                try
                {
                    await connection.OpenAsync();

                    using (var command = connection.CreateCommand())
                    {
                        command.CommandText = storedProcedure;
                        command.CommandType = System.Data.CommandType.StoredProcedure;

                        if (parameters != null)
                        {
                            foreach (var param in parameters)
                            {
                                command.Parameters.Add(param);
                            }
                        }

                        rowsAffected = await command.ExecuteNonQueryAsync(); 
                    }

                    await transaction.CommitAsync(); 
                }
                catch
                {
                    await transaction.RollbackAsync(); 
                    throw;
                }
                finally
                {
                    if (connection.State == System.Data.ConnectionState.Open)
                    {
                        await connection.CloseAsync();
                    }
                }
            }
            return rowsAffected;
        }
    }
}
