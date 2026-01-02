using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Windows.Forms;

public class DatabaseHelper
{
    private string connectionString = @"Data Source=PC-GABRIEL;Initial Catalog=GestaoFrotasDB;Integrated Security=True;Encrypt=False";

    // Método para obter a conexão
    public SqlConnection GetConnection()
    {
        return new SqlConnection(connectionString);
    }

    // Função Genérica para LEITURA (SELECT) - Enche uma tabela
    public DataTable ExecuteQuery(string query)
    {
        using (SqlConnection conn = GetConnection())
        {
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                return dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro na BD: " + ex.Message);
                return null;
            }
        }
    }

    // Função Genérica para ESCRITA simples (INSERT, UPDATE, DELETE)
    public void ExecuteNonQuery(string query)
    {
        using (SqlConnection conn = GetConnection())
        {
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao gravar: " + ex.Message);
            }
        }
    }
}