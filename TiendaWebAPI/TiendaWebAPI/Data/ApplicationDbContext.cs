using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data.Common;
using TiendaWebAPI.Models;

namespace TiendaWebAPI.Data
{
    public class ApplicationDbContext : DbContext
    {
        // Constructor: Inicializa el DbContext con las opciones proporcionadas
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        // Definir las tablas de usuarios y roles
        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Rol> Roles { get; set; }

        // Configuraciones de mapeo para las tablas de usuarios y roles
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configuraciones para la tabla de Usuarios
            modelBuilder.Entity<Usuario>(entity =>
            {
                entity.HasKey(e => e.USU_NID);
                entity.Property(e => e.USU_NID).HasColumnName("USU_NID");
                entity.Property(e => e.USU_CUSUARIO).HasColumnName("USU_CUSUARIO");
                entity.Property(e => e.USU_CNOMBRE_COMPLETO).HasColumnName("USU_CNOMBRE_COMPLETO");
                entity.Property(e => e.USU_NROL_ID).HasColumnName("USU_NROL_ID");
                entity.Property(e => e.USU_DCREACION).HasColumnName("USU_DCREACION");
            });

            // Configuraciones para la tabla de Roles
            modelBuilder.Entity<Rol>(entity =>
            {
                entity.ToTable("TBL_RROLES", "dbo");
                entity.HasKey(e => e.ROL_NID);

                entity.Property(e => e.ROL_NID).HasColumnName("ROL_NID");
                entity.Property(e => e.ROL_CNOMBRE_ROL).HasColumnName("ROL_CNOMBRE_ROL");
            });

            // Configurar la relación entre Usuarios y Roles
            modelBuilder.Entity<Usuario>()
                .HasOne<Rol>()
                .WithMany()
                .HasForeignKey(u => u.USU_NROL_ID);
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

            await using (var transaction = await Database.BeginTransactionAsync()) // Iniciar una transacción
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
