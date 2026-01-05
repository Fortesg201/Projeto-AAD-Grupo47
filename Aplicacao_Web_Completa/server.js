/**
 * Servidor Node.js/Express para a aplicação de Gestão de Viaturas
 */

const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const http = require('http');

// Função para encontrar porta disponível
function findAvailablePort(startPort, maxAttempts = 10) {
    return new Promise((resolve, reject) => {
        let attempts = 0;
        
        function tryPort(port) {
            attempts++;
            if (attempts > maxAttempts) {
                reject(new Error(`Não foi possível encontrar porta disponível após ${maxAttempts} tentativas`));
                return;
            }
            
            const server = http.createServer();
            server.listen(port, () => {
                const actualPort = server.address().port;
                server.close(() => resolve(actualPort));
            });
            server.on('error', (err) => {
                if (err.code === 'EADDRINUSE') {
                    // Tentar próxima porta
                    tryPort(port + 1);
                } else {
                    reject(err);
                }
            });
        }
        
        tryPort(startPort);
    });
}

const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(__dirname)); // Servir arquivos estáticos

// Configuração da base de dados PostgreSQL
const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'postgres',
    user: 'postgres',
    password: 'admin123',
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

// Testar conexão
pool.query('SELECT NOW()', (err, res) => {
    if (err) {
        console.error('❌ Erro ao conectar à base de dados:', err.message);
    } else {
        console.log('✅ Conectado à base de dados PostgreSQL');
    }
});

// =====================================================
// ROTAS DA APLICAÇÃO
// =====================================================

// Rota principal - servir index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// =====================================================
// API - INSERÇÃO DE DADOS
// =====================================================

app.post('/api/inserir', async (req, res) => {
    const { action, ...data } = req.body;
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        switch (action) {
            case 'viatura_manutencao':
                await inserirViaturaComManutencao(client, data);
                break;
            case 'viatura_abastecimento':
                await inserirViaturaComAbastecimento(client, data);
                break;
            case 'viatura_ocorrencia':
                await inserirOcorrencia(client, data);
                break;
            default:
                throw new Error('Ação inválida');
        }

        await client.query('COMMIT');
        res.json({ success: true, message: 'Dados inseridos com sucesso' });

    } catch (error) {
        await client.query('ROLLBACK');
        console.error('Erro:', error);
        res.status(500).json({ success: false, message: error.message });
    } finally {
        client.release();
    }
});

// =====================================================
// API - ALTERAÇÃO DE DADOS
// =====================================================

app.post('/api/alterar', async (req, res) => {
    const { action, ...data } = req.body;

    try {
        if (action === 'buscar') {
            const result = await buscarViatura(data.matricula);
            res.json(result);
        } else if (action === 'atualizar') {
            await atualizarViatura(data);
            res.json({ success: true, message: 'Viatura atualizada com sucesso' });
        } else {
            throw new Error('Ação inválida');
        }
    } catch (error) {
        console.error('Erro:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});

// =====================================================
// API - CONSULTAS
// =====================================================

app.get('/api/consultas', async (req, res) => {
    const { tipo } = req.query;

    try {
        let resultados;
        switch (tipo) {
            case 'abastecimentos':
                resultados = await consultaAbastecimentos();
                break;
            case 'manutencoes':
                resultados = await consultaManutencoes();
                break;
            case 'ocorrencias':
                resultados = await consultaOcorrencias();
                break;
            case 'relatorio':
                resultados = await consultaRelatorioFrota();
                break;
            default:
                throw new Error('Tipo de consulta inválido');
        }

        res.json({ success: true, data: resultados });
    } catch (error) {
        console.error('Erro:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});

// =====================================================
// API - STORED PROCEDURES
// =====================================================

app.get('/api/stored-procedure', async (req, res) => {
    const { matricula } = req.query;

    try {
        await criarStoredProcedures();
        
        let resultados;
        if (matricula) {
            resultados = await pool.query(
                'SELECT * FROM calcular_despesa_total_viatura($1)',
                [matricula]
            );
        } else {
            resultados = await pool.query(
                'SELECT * FROM calcular_despesa_total_todas_viaturas()'
            );
        }

        res.json({ success: true, data: resultados.rows });
    } catch (error) {
        console.error('Erro:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});

// =====================================================
// FUNÇÕES AUXILIARES - INSERÇÃO
// =====================================================

async function inserirViaturaComManutencao(client, data) {
    const timestamp = Math.floor(Date.now() / 1000);
    const userId = 1;

    // Inserir viatura
    const viaturaResult = await client.query(
        `INSERT INTO viaturas (matricula, marca, modelo, tipo_id, base_id, estado, quilometragem, created_at, updated_at, created_by, updated_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING id`,
        [data.matricula, data.marca, data.modelo, data.tipo_id, data.base_id, 
         data.estado, data.quilometragem, timestamp, timestamp, userId, userId]
    );

    const viaturaId = viaturaResult.rows[0].id;

    // Inserir manutenção
    await client.query(
        `INSERT INTO manutencoes (viatura_id, oficina_id, tipo, descricao, custo, data_execucao, proxima_revisao, created_at, updated_at, created_by, updated_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
        [viaturaId, data.oficina_id, data.tipo_manutencao, data.descricao_manutencao, 
         data.custo, data.data_execucao, data.proxima_revisao, timestamp, timestamp, userId, userId]
    );
}

async function inserirViaturaComAbastecimento(client, data) {
    const timestamp = Math.floor(Date.now() / 1000);
    const userId = 1;

    // Inserir viatura
    const viaturaResult = await client.query(
        `INSERT INTO viaturas (matricula, marca, modelo, tipo_id, base_id, estado, quilometragem, created_at, updated_at, created_by, updated_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING id`,
        [data.matricula, data.marca, data.modelo, data.tipo_id, data.base_id, 
         data.estado, data.quilometragem, timestamp, timestamp, userId, userId]
    );

    const viaturaId = viaturaResult.rows[0].id;

    // Inserir abastecimento
    await client.query(
        `INSERT INTO abastecimentos (viatura_id, militar_id, fornecedor_id, tipo_combustivel_id, litros, custo_total, quilometragem, data_abastecimento, created_at, updated_at, created_by, updated_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)`,
        [viaturaId, data.militar_id, data.fornecedor_id, data.tipo_combustivel_id, 
         data.litros, data.custo_total, data.quilometragem_abast, data.data_abastecimento, 
         timestamp, timestamp, userId, userId]
    );
}

async function inserirOcorrencia(client, data) {
    const timestamp = Math.floor(Date.now() / 1000);
    const userId = 1;

    await client.query(
        `INSERT INTO ocorrencias (viatura_id, missao_id, tipo, descricao, gravidade, data_ocorrencia, created_at, updated_at, created_by, updated_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
        [data.viatura_id, data.missao_id, data.tipo_ocorrencia, data.descricao_ocorrencia, 
         data.gravidade, data.data_ocorrencia, timestamp, timestamp, userId, userId]
    );
}

// =====================================================
// FUNÇÕES AUXILIARES - ALTERAÇÃO
// =====================================================

async function buscarViatura(matricula) {
    const viaturaResult = await pool.query(
        `SELECT v.*, tv.nome as tipo_nome, bm.nome as base_nome 
         FROM viaturas v
         JOIN tipos_viatura tv ON v.tipo_id = tv.id
         JOIN bases_militares bm ON v.base_id = bm.id
         WHERE v.matricula = $1`,
        [matricula]
    );

    if (viaturaResult.rows.length === 0) {
        return { success: false, message: 'Viatura não encontrada' };
    }

    const viatura = viaturaResult.rows[0];
    const viaturaId = viatura.id;

    // Buscar dados relacionados
    const [manutencoes, abastecimentos, ocorrencias] = await Promise.all([
        pool.query(
            `SELECT m.*, o.nome as oficina_nome 
             FROM manutencoes m
             JOIN oficinas o ON m.oficina_id = o.id
             WHERE m.viatura_id = $1
             ORDER BY m.data_execucao DESC`,
            [viaturaId]
        ),
        pool.query(
            `SELECT a.*, tc.nome as combustivel_nome, fc.nome as fornecedor_nome 
             FROM abastecimentos a
             JOIN tipos_combustivel tc ON a.tipo_combustivel_id = tc.id
             JOIN fornecedores_combustivel fc ON a.fornecedor_id = fc.id
             WHERE a.viatura_id = $1
             ORDER BY a.data_abastecimento DESC`,
            [viaturaId]
        ),
        pool.query(
            `SELECT o.*, m.local as missao_local 
             FROM ocorrencias o
             JOIN missoes m ON o.missao_id = m.id
             WHERE o.viatura_id = $1
             ORDER BY o.data_ocorrencia DESC`,
            [viaturaId]
        )
    ]);

    return {
        success: true,
        message: 'Viatura encontrada',
        data: {
            viatura: viatura,
            manutencoes: manutencoes.rows,
            abastecimentos: abastecimentos.rows,
            ocorrencias: ocorrencias.rows
        }
    };
}

async function atualizarViatura(data) {
    const timestamp = Math.floor(Date.now() / 1000);
    const userId = 1;

    await pool.query(
        `UPDATE viaturas 
         SET matricula = $1, marca = $2, modelo = $3, tipo_id = $4, base_id = $5, 
             estado = $6, quilometragem = $7, updated_at = $8, updated_by = $9
         WHERE id = $10`,
        [data.matricula, data.marca, data.modelo, data.tipo_id, data.base_id, 
         data.estado, data.quilometragem, timestamp, userId, data.viatura_id]
    );
}

// =====================================================
// FUNÇÕES AUXILIARES - CONSULTAS
// =====================================================

async function consultaAbastecimentos() {
    const result = await pool.query(
        `SELECT 
            v.matricula,
            '2020-09 a 2023-12' AS periodo,
            SUM(a.custo_total) AS total_abastecido,
            COUNT(*) AS num_abastecimentos
         FROM viaturas v
         JOIN abastecimentos a ON v.id = a.viatura_id
         WHERE a.data_abastecimento > '2020-09-01' 
           AND a.data_abastecimento <= '2023-12-31'
         GROUP BY v.matricula, v.id
         HAVING SUM(a.custo_total) >= 2000
         ORDER BY total_abastecido DESC`
    );
    return result.rows;
}

async function consultaManutencoes() {
    const result = await pool.query(
        `SELECT
            v.matricula,
            2023 AS ano,
            SUM(m.custo) AS custo_total,
            COUNT(*) AS num_manutencoes
         FROM viaturas v
         JOIN manutencoes m ON v.id = m.viatura_id
         WHERE EXTRACT(YEAR FROM m.data_execucao) = 2023
         GROUP BY v.matricula, v.id
         HAVING SUM(m.custo) >= ALL (
             SELECT SUM(custo)
             FROM manutencoes
             WHERE EXTRACT(YEAR FROM data_execucao) = 2023
             GROUP BY viatura_id
         )`
    );
    return result.rows;
}

async function consultaOcorrencias() {
    const result = await pool.query(
        `SELECT 
            t.nome AS tipo, 
            COUNT(*) AS num_ocorrencias
         FROM tipos_viatura t
         JOIN viaturas v ON t.id = v.tipo_id 
         JOIN ocorrencias o ON v.id = o.viatura_id 
         GROUP BY t.nome
         HAVING COUNT(*) >= ALL (
             SELECT COUNT(*)
             FROM tipos_viatura t2
             JOIN viaturas v2 ON t2.id = v2.tipo_id
             JOIN ocorrencias o2 ON v2.id = o2.viatura_id
             GROUP BY t2.nome
         )`
    );
    return result.rows;
}

async function consultaRelatorioFrota() {
    // Verificar se a view existe
    const viewCheck = await pool.query(
        `SELECT EXISTS (
            SELECT 1 FROM information_schema.views 
            WHERE table_schema = 'public' AND table_name = 'relatorio_frota'
        )`
    );

    if (!viewCheck.rows[0].exists) {
        // Criar a view
        await pool.query(`
            CREATE VIEW relatorio_frota AS
            SELECT
                v.matricula,
                v.marca,
                v.modelo,
                tv.nome AS tipo_viatura,
                m.descricao AS descricao_manutencao,
                m.custo
            FROM viaturas v
            JOIN tipos_viatura tv ON v.tipo_id = tv.id  
            JOIN manutencoes m ON v.id = m.viatura_id
        `);
    }

    const result = await pool.query(
        'SELECT * FROM relatorio_frota ORDER BY matricula, custo DESC'
    );
    return result.rows;
}

// =====================================================
// FUNÇÕES AUXILIARES - STORED PROCEDURES
// =====================================================

async function criarStoredProcedures() {
    // Procedure 1
    await pool.query(`
        CREATE OR REPLACE FUNCTION calcular_despesa_total_viatura(p_matricula VARCHAR)
        RETURNS TABLE (
            matricula VARCHAR,
            ano INTEGER,
            despesa_total NUMERIC,
            manutencoes NUMERIC,
            abastecimentos NUMERIC
        ) AS $$
        BEGIN
            RETURN QUERY
            SELECT 
                v.matricula,
                2023 AS ano,
                COALESCE(SUM(m.custo), 0) + COALESCE(SUM(a.custo_total), 0) AS despesa_total,
                COALESCE(SUM(m.custo), 0) AS manutencoes,
                COALESCE(SUM(a.custo_total), 0) AS abastecimentos
            FROM viaturas v
            LEFT JOIN manutencoes m ON v.id = m.viatura_id 
                AND EXTRACT(YEAR FROM m.data_execucao) = 2023
            LEFT JOIN abastecimentos a ON v.id = a.viatura_id 
                AND EXTRACT(YEAR FROM a.data_abastecimento) = 2023
            WHERE v.matricula = p_matricula
            GROUP BY v.matricula, v.id;
        END;
        $$ LANGUAGE plpgsql;
    `);

    // Procedure 2
    await pool.query(`
        CREATE OR REPLACE FUNCTION calcular_despesa_total_todas_viaturas()
        RETURNS TABLE (
            matricula VARCHAR,
            ano INTEGER,
            despesa_total NUMERIC,
            manutencoes NUMERIC,
            abastecimentos NUMERIC
        ) AS $$
        BEGIN
            RETURN QUERY
            SELECT 
                v.matricula,
                2023 AS ano,
                COALESCE(SUM(m.custo), 0) + COALESCE(SUM(a.custo_total), 0) AS despesa_total,
                COALESCE(SUM(m.custo), 0) AS manutencoes,
                COALESCE(SUM(a.custo_total), 0) AS abastecimentos
            FROM viaturas v
            LEFT JOIN manutencoes m ON v.id = m.viatura_id 
                AND EXTRACT(YEAR FROM m.data_execucao) = 2023
            LEFT JOIN abastecimentos a ON v.id = a.viatura_id 
                AND EXTRACT(YEAR FROM a.data_abastecimento) = 2023
            GROUP BY v.matricula, v.id
            ORDER BY despesa_total DESC;
        END;
        $$ LANGUAGE plpgsql;
    `);
}

// =====================================================
// INICIAR SERVIDOR
// =====================================================

// Encontrar porta disponível e iniciar servidor
findAvailablePort(PORT)
    .then(availablePort => {
        app.listen(availablePort, () => {
            console.log('========================================');
            console.log('🚀 Servidor rodando!');
            console.log('========================================');
            console.log(`📍 URL: http://localhost:${availablePort}`);
            console.log(`📍 Aplicação: http://localhost:${availablePort}/index.html`);
            console.log(`📍 API: http://localhost:${availablePort}/api/`);
            console.log('');
            console.log('Pressione Ctrl+C para parar o servidor');
            console.log('========================================');
        });
    })
    .catch(error => {
        console.error('❌ Erro ao iniciar servidor:', error);
        process.exit(1);
    });

