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
    public partial class frmOcorrencia : Form
    {
        public frmOcorrencia()
        {
            InitializeComponent();
        }

        private void btnRegistar_Click(object sender, EventArgs e)
        {
            DatabaseHelper db = new DatabaseHelper();
            using (SqlConnection conn = db.GetConnection())
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_RegistarOcorrencia", conn);
                cmd.CommandType = CommandType.StoredProcedure; // Indica que é uma SP

                cmd.Parameters.AddWithValue("@ViaturaID", int.Parse(txtViaturaID.Text));
                cmd.Parameters.AddWithValue("@Descricao", txtDescricao.Text);
                cmd.Parameters.AddWithValue("@Gravidade", cbGravidade.Text);

                cmd.ExecuteNonQuery();
                MessageBox.Show("Ocorrência registada!");
            }
        }
    }
}
