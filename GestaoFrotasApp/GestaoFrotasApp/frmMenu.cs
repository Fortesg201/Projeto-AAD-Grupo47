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
    public partial class frmMenu : Form
    {
        public frmMenu()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            frmNovaMissao f = new frmNovaMissao();
            f.ShowDialog();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            frmOcorrencia f = new frmOcorrencia();
            f.ShowDialog();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            frmRelatorio f = new frmRelatorio();
            f.ShowDialog();
        }
    }
}
