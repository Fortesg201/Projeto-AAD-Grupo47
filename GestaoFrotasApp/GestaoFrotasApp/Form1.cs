using System.Data;

namespace GestaoFrotasApp
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Botão de Login
            DatabaseHelper db = new DatabaseHelper();

            // Verifica se o utilizador existe (Simples)
            string sql = $"SELECT * FROM utilizadores WHERE email='{txtEmail.Text}' AND password_hash='{txtPass.Text}'";
            DataTable dt = db.ExecuteQuery(sql);

            if (dt != null && dt.Rows.Count > 0)
            {
                MessageBox.Show("Login efetuado com sucesso!");

                // Esconde o Login e abre o Menu (que vamos criar a seguir)
                frmMenu menu = new frmMenu();
                menu.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Email ou password incorretos.");
            }
        }
    }
}
