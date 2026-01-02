namespace GestaoFrotasApp
{
    partial class frmOcorrencia
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            txtViaturaID = new TextBox();
            txtDescricao = new TextBox();
            cbGravidade = new ComboBox();
            btnRegistar = new Button();
            SuspendLayout();
            // 
            // txtViaturaID
            // 
            txtViaturaID.Location = new Point(321, 122);
            txtViaturaID.Name = "txtViaturaID";
            txtViaturaID.Size = new Size(121, 23);
            txtViaturaID.TabIndex = 0;
            txtViaturaID.Text = "ViaturaId";
            // 
            // txtDescricao
            // 
            txtDescricao.Location = new Point(321, 169);
            txtDescricao.Name = "txtDescricao";
            txtDescricao.Size = new Size(121, 23);
            txtDescricao.TabIndex = 1;
            txtDescricao.Text = "Descricão";
            // 
            // cbGravidade
            // 
            cbGravidade.FormattingEnabled = true;
            cbGravidade.Items.AddRange(new object[] { "Baixa, ", "Media, ", "Alta" });
            cbGravidade.Location = new Point(321, 214);
            cbGravidade.Name = "cbGravidade";
            cbGravidade.Size = new Size(121, 23);
            cbGravidade.TabIndex = 2;
            cbGravidade.Text = "Gravidade";
            // 
            // btnRegistar
            // 
            btnRegistar.Location = new Point(337, 266);
            btnRegistar.Name = "btnRegistar";
            btnRegistar.Size = new Size(75, 23);
            btnRegistar.TabIndex = 3;
            btnRegistar.Text = "Registar";
            btnRegistar.UseVisualStyleBackColor = true;
            btnRegistar.Click += btnRegistar_Click;
            // 
            // frmOcorrencia
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(btnRegistar);
            Controls.Add(cbGravidade);
            Controls.Add(txtDescricao);
            Controls.Add(txtViaturaID);
            Name = "frmOcorrencia";
            Text = "frmOcorrencia";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox txtViaturaID;
        private TextBox txtDescricao;
        private ComboBox cbGravidade;
        private Button btnRegistar;
    }
}