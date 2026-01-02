using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Data.SqlClient;

namespace GestaoFrotasApp
{
    public partial class frmNovaMissao : Form
    {
        public frmNovaMissao()
        {
            InitializeComponent();
        }

        private void btnSalvar_Click(object sender, EventArgs e)
        {
            DatabaseHelper db = new DatabaseHelper();

            using (SqlConnection conn = db.GetConnection())
            {
                conn.Open();
                // INÍCIO DA TRANSAÇÃO (Tudo ou Nada)
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1. Inserir a MISSÃO
                    string sqlMissao = "INSERT INTO missoes (local, objetivo, data_inicio) OUTPUT INSERTED.ID VALUES (@local, @obj, GETDATE())";
                    SqlCommand cmd1 = new SqlCommand(sqlMissao, conn, transaction);
                    cmd1.Parameters.AddWithValue("@local", txtLocal.Text);
                    cmd1.Parameters.AddWithValue("@obj", txtObjetivo.Text);

                    int idMissao = (int)cmd1.ExecuteScalar(); // Guarda o ID novo

                    // 2. Inserir a VIATURA NA MISSÃO
                    string sqlLigacao = "INSERT INTO viaturas_missao (missao_id, viatura_id) VALUES (@mID, @vID)";
                    SqlCommand cmd2 = new SqlCommand(sqlLigacao, conn, transaction);
                    cmd2.Parameters.AddWithValue("@mID", idMissao);
                    cmd2.Parameters.AddWithValue("@vID", int.Parse(txtViaturaID.Text));

                    cmd2.ExecuteNonQuery();

                    transaction.Commit(); // Grava tudo
                    MessageBox.Show("Missão criada com sucesso!");
                    this.Close();
                }
                catch (Exception ex)
                {
                    transaction.Rollback(); // Cancela tudo se der erro
                    MessageBox.Show("Erro: " + ex.Message);
                }
            }
        }
    }
}
