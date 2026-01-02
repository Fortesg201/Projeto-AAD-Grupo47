namespace GestaoFrotasApp
{
    partial class frmNovaMissao
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
            txtLocal = new TextBox();
            txtObjetivo = new TextBox();
            txtViaturaID = new TextBox();
            btnSalvar = new Button();
            SuspendLayout();
            // 
            // txtLocal
            // 
            txtLocal.Location = new Point(365, 146);
            txtLocal.Name = "txtLocal";
            txtLocal.Size = new Size(100, 23);
            txtLocal.TabIndex = 0;
            txtLocal.Text = "Local";
            // 
            // txtObjetivo
            // 
            txtObjetivo.Location = new Point(365, 187);
            txtObjetivo.Name = "txtObjetivo";
            txtObjetivo.Size = new Size(100, 23);
            txtObjetivo.TabIndex = 1;
            txtObjetivo.Text = "Objetivo";
            // 
            // txtViaturaID
            // 
            txtViaturaID.Location = new Point(365, 228);
            txtViaturaID.Name = "txtViaturaID";
            txtViaturaID.Size = new Size(100, 23);
            txtViaturaID.TabIndex = 2;
            txtViaturaID.Text = "ViaturaID";
            // 
            // btnSalvar
            // 
            btnSalvar.Location = new Point(365, 276);
            btnSalvar.Name = "btnSalvar";
            btnSalvar.Size = new Size(100, 23);
            btnSalvar.TabIndex = 4;
            btnSalvar.Text = "Salvar Missão";
            btnSalvar.UseVisualStyleBackColor = true;
            btnSalvar.Click += btnSalvar_Click;
            // 
            // frmNovaMissao
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(btnSalvar);
            Controls.Add(txtViaturaID);
            Controls.Add(txtObjetivo);
            Controls.Add(txtLocal);
            Name = "frmNovaMissao";
            Text = "frmNovaMissao";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox txtLocal;
        private TextBox txtObjetivo;
        private TextBox txtViaturaID;
        private Button btnSalvar;
    }
}