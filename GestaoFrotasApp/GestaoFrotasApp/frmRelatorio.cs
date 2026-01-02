using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GestaoFrotasApp
{
    public partial class frmRelatorio : Form
    {
        public frmRelatorio()
        {
            InitializeComponent();
        }

        private void frmRelatorio_Load_CellContentClick(object sender, EventArgs e)
        {
            DatabaseHelper db = new DatabaseHelper();
            // Query com JOINs
            string sql = "SELECT v.matricula, v.marca, v.modelo, t.nome as Tipo, v.estado FROM viaturas v JOIN tipos_viatura t ON v.tipo_viatura_id = t.id";

            dataGridView1.DataSource = db.ExecuteQuery(sql);
        }
    }
}
