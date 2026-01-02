CREATE TABLE perfis (
  id         int IDENTITY NOT NULL, 
  nome       varchar(50) NOT NULL UNIQUE, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE utilizadores (
  id         int IDENTITY NOT NULL, 
  nome       varchar(120) NOT NULL, 
  email      varchar(180) NOT NULL UNIQUE, 
  hash_senha text NOT NULL, 
  perfil_id  int NOT NULL, 
  ativo      int DEFAULT TRUE NOT NULL, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE auditoria_acessos (
  id            int IDENTITY NOT NULL, 
  utilizador_id int NOT NULL, 
  acao          text NOT NULL, 
  entidade      varchar(100) NOT NULL, 
  entidade_id   bigint NULL, 
  ip            varchar(64) NULL, 
  user_agent    text NULL, 
  created_at    int DEFAULT NOW() NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE bases_militares (
  id         int IDENTITY NOT NULL, 
  nome       varchar(120) NOT NULL, 
  localidade varchar(120) NULL, 
  codigo     varchar(30) NULL UNIQUE, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE tipos_viatura (
  id         int IDENTITY NOT NULL, 
  nome       varchar(80) NOT NULL UNIQUE, 
  descricao  text NULL, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE viaturas (
  id            int IDENTITY NOT NULL, 
  matricula     varchar(20) NOT NULL UNIQUE, 
  marca         varchar(80) NOT NULL, 
  modelo        varchar(80) NOT NULL, 
  tipo_id       int NOT NULL, 
  base_id       int NOT NULL, 
  estado        varchar(40) NOT NULL, 
  quilometragem int NOT NULL CHECK(quilometragem >= 0), 
  created_at    int DEFAULT NOW() NOT NULL, 
  updated_at    int NULL, 
  created_by    int NULL, 
  updated_by    int NULL, 
  PRIMARY KEY (id));
CREATE TABLE patentes (
  id         int IDENTITY NOT NULL, 
  nome       varchar(80) NOT NULL UNIQUE, 
  grau_ordem int NULL, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE militares (
  id         int IDENTITY NOT NULL, 
  nip        varchar(30) NOT NULL UNIQUE, 
  nome       varchar(120) NOT NULL, 
  patente_id int NOT NULL, 
  contacto   varchar(60) NULL, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE missoes (
  id                     int IDENTITY NOT NULL, 
  data_inicio            date NOT NULL, 
  data_fim               date NULL, 
  local                  varchar(200) NULL, 
  objetivo               text NULL, 
  oficial_responsavel_id int NOT NULL, 
  created_at             int DEFAULT NOW() NOT NULL, 
  updated_at             int NULL, 
  created_by             int NULL, 
  updated_by             int NULL, 
  PRIMARY KEY (id), 
  CONSTRAINT chk_missao_datas 
    CHECK (data_fim IS NULL OR data_fim >= data_inicio));
CREATE TABLE viaturas_missao (
  viatura_id  bigint NOT NULL, 
  missao_id   bigint NOT NULL, 
  condutor_id int NOT NULL, 
  created_at  int DEFAULT NOW() NOT NULL, 
  updated_at  int NULL, 
  created_by  int NULL, 
  updated_by  int NULL, 
  PRIMARY KEY (viatura_id, 
  missao_id));
CREATE TABLE oficinas (
  id         int IDENTITY NOT NULL, 
  nome       varchar(160) NOT NULL, 
  nif        varchar(20) NULL, 
  contacto   varchar(60) NULL, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE manutencoes (
  id              int IDENTITY NOT NULL, 
  viatura_id      int NOT NULL, 
  oficina_id      int NOT NULL, 
  tipo            varchar(12) NOT NULL CHECK(tipo IN ('preventiva','corretiva')), 
  descricao       text NULL, 
  custo           decimal(10, 2) DEFAULT 0 NOT NULL, 
  data_execucao   date NOT NULL, 
  proxima_revisao date NULL, 
  created_at      int DEFAULT NOW() NOT NULL, 
  updated_at      int NULL, 
  created_by      int NULL, 
  updated_by      int NULL, 
  PRIMARY KEY (id), 
  CONSTRAINT chk_revisao 
    CHECK (proxima_revisao IS NULL OR proxima_revisao > data_execucao));
CREATE TABLE fornecedores_combustivel (
  id         int IDENTITY NOT NULL, 
  nome       varchar(160) NOT NULL, 
  nif        varchar(20) NULL, 
  contacto   varchar(60) NULL, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE tipos_combustivel (
  id         int IDENTITY NOT NULL, 
  nome       varchar(60) NOT NULL UNIQUE, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE abastecimentos (
  id                  int IDENTITY NOT NULL, 
  viatura_id          int NOT NULL, 
  militar_id          int NOT NULL, 
  fornecedor_id       int NOT NULL, 
  tipo_combustivel_id int NOT NULL, 
  litros              decimal(10, 2) NOT NULL CHECK(litros > 0), 
  custo_total         decimal(10, 2) NOT NULL CHECK(custo_total >= 0), 
  quilometragem       int NOT NULL CHECK(quilometragem >= 0), 
  data_abastecimento  date NOT NULL, 
  created_at          int DEFAULT NOW() NOT NULL, 
  updated_at          int NULL, 
  created_by          int NULL, 
  updated_by          int NULL, 
  PRIMARY KEY (id));
CREATE TABLE tipos_documento (
  id         int IDENTITY NOT NULL, 
  nome       varchar(80) NOT NULL UNIQUE, 
  created_at int DEFAULT NOW() NOT NULL, 
  updated_at int NULL, 
  created_by int NULL, 
  updated_by int NULL, 
  PRIMARY KEY (id));
CREATE TABLE documentos_viatura (
  id                  int IDENTITY NOT NULL, 
  viatura_id          int NOT NULL, 
  tipo_documento_id   int NOT NULL, 
  numero              varchar(120) NULL, 
  emissor             varchar(160) NULL, 
  data_emissao        date NOT NULL, 
  data_validade       date NOT NULL, 
  alertar_a_partir_de date NULL, 
  created_at          int DEFAULT NOW() NOT NULL, 
  updated_at          int NULL, 
  created_by          int NULL, 
  updated_by          int NULL, 
  PRIMARY KEY (id), 
  CONSTRAINT chk_doc_validade 
    CHECK (data_validade > data_emissao));
CREATE TABLE ocorrencias (
  id              int IDENTITY NOT NULL, 
  viatura_id      int NOT NULL, 
  missao_id       int NULL, 
  tipo            varchar(12) NOT NULL CHECK(tipo IN ('avaria','acidente','incidente')), 
  descricao       text NULL, 
  gravidade       varchar(10) NOT NULL CHECK(gravidade IN ('baixa','media','alta')), 
  data_ocorrencia date NOT NULL, 
  created_at      int DEFAULT NOW() NOT NULL, 
  updated_at      int NULL, 
  created_by      int NULL, 
  updated_by      int NULL, 
  PRIMARY KEY (id));
CREATE NONCLUSTERED INDEX idx_viaturas_tipo 
  ON viaturas (tipo_id);
CREATE NONCLUSTERED INDEX idx_viaturas_base 
  ON viaturas (base_id);
CREATE NONCLUSTERED INDEX idx_viaturas_matricula 
  ON viaturas (matricula);
CREATE NONCLUSTERED INDEX idx_militares_patente 
  ON militares (patente_id);
CREATE NONCLUSTERED INDEX idx_militares_nip 
  ON militares (nip);
CREATE NONCLUSTERED INDEX idx_missoes_oficial 
  ON missoes (oficial_responsavel_id);
CREATE NONCLUSTERED INDEX idx_vm_condutor 
  ON viaturas_missao (condutor_id);
CREATE NONCLUSTERED INDEX idx_manutencoes_viatura 
  ON manutencoes (viatura_id);
CREATE NONCLUSTERED INDEX idx_manutencoes_oficina 
  ON manutencoes (oficina_id);
CREATE NONCLUSTERED INDEX idx_abast_viatura_data 
  ON abastecimentos (viatura_id, data_abastecimento);
CREATE NONCLUSTERED INDEX idx_abast_militar 
  ON abastecimentos (militar_id);
CREATE NONCLUSTERED INDEX idx_doc_viatura 
  ON documentos_viatura (viatura_id);
CREATE NONCLUSTERED INDEX idx_doc_tipo 
  ON documentos_viatura (tipo_documento_id);
CREATE NONCLUSTERED INDEX idx_ocorrencias_viatura 
  ON ocorrencias (viatura_id);
CREATE NONCLUSTERED INDEX idx_ocorrencias_missao 
  ON ocorrencias (missao_id);
ALTER TABLE perfis ADD CONSTRAINT fk_perfis_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE perfis ADD CONSTRAINT fk_perfis_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE utilizadores ADD CONSTRAINT fk_utilizadores_perfil FOREIGN KEY (perfil_id) REFERENCES perfis (id);
ALTER TABLE utilizadores ADD CONSTRAINT fk_utilizadores_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE utilizadores ADD CONSTRAINT fk_utilizadores_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE auditoria_acessos ADD CONSTRAINT fk_auditoria_utilizador FOREIGN KEY (utilizador_id) REFERENCES utilizadores (id);
ALTER TABLE bases_militares ADD CONSTRAINT fk_bases_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE bases_militares ADD CONSTRAINT fk_bases_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE tipos_viatura ADD CONSTRAINT fk_tipos_viatura_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE tipos_viatura ADD CONSTRAINT fk_tipos_viatura_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE viaturas ADD CONSTRAINT fk_viaturas_tipo FOREIGN KEY (tipo_id) REFERENCES tipos_viatura (id);
ALTER TABLE viaturas ADD CONSTRAINT fk_viaturas_base FOREIGN KEY (base_id) REFERENCES bases_militares (id);
ALTER TABLE viaturas ADD CONSTRAINT fk_viaturas_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE viaturas ADD CONSTRAINT fk_viaturas_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE patentes ADD CONSTRAINT fk_patentes_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE patentes ADD CONSTRAINT fk_patentes_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE militares ADD CONSTRAINT fk_militares_patente FOREIGN KEY (patente_id) REFERENCES patentes (id);
ALTER TABLE militares ADD CONSTRAINT fk_militares_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE militares ADD CONSTRAINT fk_militares_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE missoes ADD CONSTRAINT fk_missoes_oficial FOREIGN KEY (oficial_responsavel_id) REFERENCES militares (id);
ALTER TABLE missoes ADD CONSTRAINT fk_missoes_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE missoes ADD CONSTRAINT fk_missoes_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE viaturas_missao ADD CONSTRAINT fk_vm_viatura FOREIGN KEY (viatura_id) REFERENCES viaturas (id);
ALTER TABLE viaturas_missao ADD CONSTRAINT fk_vm_missao FOREIGN KEY (missao_id) REFERENCES missoes (id);
ALTER TABLE viaturas_missao ADD CONSTRAINT fk_vm_condutor FOREIGN KEY (condutor_id) REFERENCES militares (id);
ALTER TABLE viaturas_missao ADD CONSTRAINT fk_vm_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE viaturas_missao ADD CONSTRAINT fk_vm_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE oficinas ADD CONSTRAINT fk_oficinas_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE oficinas ADD CONSTRAINT fk_oficinas_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE manutencoes ADD CONSTRAINT fk_manutencoes_viatura FOREIGN KEY (viatura_id) REFERENCES viaturas (id);
ALTER TABLE manutencoes ADD CONSTRAINT fk_manutencoes_oficina FOREIGN KEY (oficina_id) REFERENCES oficinas (id);
ALTER TABLE manutencoes ADD CONSTRAINT fk_manutencoes_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE manutencoes ADD CONSTRAINT fk_manutencoes_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE fornecedores_combustivel ADD CONSTRAINT fk_fornecedores_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE fornecedores_combustivel ADD CONSTRAINT fk_fornecedores_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE tipos_combustivel ADD CONSTRAINT fk_tipos_comb_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE tipos_combustivel ADD CONSTRAINT fk_tipos_comb_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE abastecimentos ADD CONSTRAINT fk_abast_viatura FOREIGN KEY (viatura_id) REFERENCES viaturas (id);
ALTER TABLE abastecimentos ADD CONSTRAINT fk_abast_militar FOREIGN KEY (militar_id) REFERENCES militares (id);
ALTER TABLE abastecimentos ADD CONSTRAINT fk_abast_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedores_combustivel (id);
ALTER TABLE abastecimentos ADD CONSTRAINT fk_abast_tipo_comb FOREIGN KEY (tipo_combustivel_id) REFERENCES tipos_combustivel (id);
ALTER TABLE abastecimentos ADD CONSTRAINT fk_abast_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE abastecimentos ADD CONSTRAINT fk_abast_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE tipos_documento ADD CONSTRAINT fk_tipos_doc_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE tipos_documento ADD CONSTRAINT fk_tipos_doc_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE documentos_viatura ADD CONSTRAINT fk_doc_viatura FOREIGN KEY (viatura_id) REFERENCES viaturas (id);
ALTER TABLE documentos_viatura ADD CONSTRAINT fk_doc_tipo FOREIGN KEY (tipo_documento_id) REFERENCES tipos_documento (id);
ALTER TABLE documentos_viatura ADD CONSTRAINT fk_doc_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE documentos_viatura ADD CONSTRAINT fk_doc_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
ALTER TABLE ocorrencias ADD CONSTRAINT fk_ocorrencias_viatura FOREIGN KEY (viatura_id) REFERENCES viaturas (id);
ALTER TABLE ocorrencias ADD CONSTRAINT fk_ocorrencias_missao FOREIGN KEY (missao_id) REFERENCES missoes (id);
ALTER TABLE ocorrencias ADD CONSTRAINT fk_ocorrencias_created_by FOREIGN KEY (created_by) REFERENCES utilizadores (id);
ALTER TABLE ocorrencias ADD CONSTRAINT fk_ocorrencias_updated_by FOREIGN KEY (updated_by) REFERENCES utilizadores (id);
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'set_updated_at') AND type in (N'P', N'PC')) DROP PROCEDURE set_updated_at;
GO
-- Visual Paradigm Import DDL
-- Database: PostgreSQL
-- Schema: public
-- Model: Sistema de GestÃ£o de Frotas Militares (18 tabelas)

-- ==============================================
-- Helpers: trigger to auto-update updated_at
-- ==============================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_perfis_updated_at')) DROP TRIGGER trg_perfis_updated_at;
GO
CREATE TRIGGER trg_perfis_updated_at
BEFORE UPDATE ON perfis
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_utilizadores_updated_at')) DROP TRIGGER trg_utilizadores_updated_at;
GO
CREATE TRIGGER trg_utilizadores_updated_at
BEFORE UPDATE ON utilizadores
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_bases_militares_updated_at')) DROP TRIGGER trg_bases_militares_updated_at;
GO
CREATE TRIGGER trg_bases_militares_updated_at
BEFORE UPDATE ON bases_militares
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_tipos_viatura_updated_at')) DROP TRIGGER trg_tipos_viatura_updated_at;
GO
CREATE TRIGGER trg_tipos_viatura_updated_at
BEFORE UPDATE ON tipos_viatura
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_viaturas_updated_at')) DROP TRIGGER trg_viaturas_updated_at;
GO
CREATE TRIGGER trg_viaturas_updated_at
BEFORE UPDATE ON viaturas
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_patentes_updated_at')) DROP TRIGGER trg_patentes_updated_at;
GO
CREATE TRIGGER trg_patentes_updated_at
BEFORE UPDATE ON patentes
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_militares_updated_at')) DROP TRIGGER trg_militares_updated_at;
GO
CREATE TRIGGER trg_militares_updated_at
BEFORE UPDATE ON militares
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_missoes_updated_at')) DROP TRIGGER trg_missoes_updated_at;
GO
CREATE TRIGGER trg_missoes_updated_at
BEFORE UPDATE ON missoes
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_viaturas_missao_updated_at')) DROP TRIGGER trg_viaturas_missao_updated_at;
GO
CREATE TRIGGER trg_viaturas_missao_updated_at
BEFORE UPDATE ON viaturas_missao
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_oficinas_updated_at')) DROP TRIGGER trg_oficinas_updated_at;
GO
CREATE TRIGGER trg_oficinas_updated_at
BEFORE UPDATE ON oficinas
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_manutencoes_updated_at')) DROP TRIGGER trg_manutencoes_updated_at;
GO
CREATE TRIGGER trg_manutencoes_updated_at
BEFORE UPDATE ON manutencoes
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_fornecedores_updated_at')) DROP TRIGGER trg_fornecedores_updated_at;
GO
CREATE TRIGGER trg_fornecedores_updated_at
BEFORE UPDATE ON fornecedores_combustivel
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_tipos_combustivel_updated_at')) DROP TRIGGER trg_tipos_combustivel_updated_at;
GO
CREATE TRIGGER trg_tipos_combustivel_updated_at
BEFORE UPDATE ON tipos_combustivel
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_abastecimentos_updated_at')) DROP TRIGGER trg_abastecimentos_updated_at;
GO
CREATE TRIGGER trg_abastecimentos_updated_at
BEFORE UPDATE ON abastecimentos
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_tipos_documento_updated_at')) DROP TRIGGER trg_tipos_documento_updated_at;
GO
CREATE TRIGGER trg_tipos_documento_updated_at
BEFORE UPDATE ON tipos_documento
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_documentos_viatura_updated_at')) DROP TRIGGER trg_documentos_viatura_updated_at;
GO
CREATE TRIGGER trg_documentos_viatura_updated_at
BEFORE UPDATE ON documentos_viatura
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'trg_ocorrencias_updated_at')) DROP TRIGGER trg_ocorrencias_updated_at;
GO
CREATE TRIGGER trg_ocorrencias_updated_at
BEFORE UPDATE ON ocorrencias
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
GO
