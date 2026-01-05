-- =====================================================
-- Stored Procedures para a aplicação
-- =====================================================

-- Procedure 1: Calcular despesa total de uma viatura específica em 2023
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

-- Procedure 2: Calcular despesa total de todas as viaturas em 2023
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

-- =====================================================
-- Fim das Stored Procedures
-- =====================================================

