ALTER TABLE indicadores ADD COLUMN IF NOT EXISTS situacao_atual varchar(3);

UPDATE indicadores 
SET situacao_atual = 'Sim'
FROM ( SELECT
  protocolo,
  MAX(dat_encerramento) as ultima_data
  FROM
  indicadores 
  GROUP BY
  protocolo) AS subquery
WHERE 
indicadores.protocolo = subquery.protocolo
AND indicadores.dat_encerramento = subquery.ultima_data;

TRUNCATE public.indicadores_cvi;

INSERT INTO public.indicadores_cvi(
cod_processo, configuracao_orgao_id, protocolo, nome_orgao, nome_servico, cod_ciclo, cod_etapa, nome_etapa, cod_tipo_etapa, nome_tipo_etapa, ide_finalizado, status_processo, cpf_cidadao, dat_abertura, dat_encerramento, dat_conclusao_etapa, nota, dimensao_avaliacao, dat_avaliacao, id_fase_processo, nome_fase_processo, cod_servico, cod_orgao, atendente, situacao_atual)
(
SELECT * FROM indicadores WHERE cod_servico IN (1159,6906)
);

TRUNCATE public.indicadores_cvi_dimensao;

INSERT INTO public.indicadores_cvi_dimensao(
protocolo, nota, cod_ciclo, cod_etapa, dat_avaliacao, dimensao_avaliacao)
(
SELECT
t1.protocolo,
t1.cod_etapa,
t1.cod_ciclo,
t1.nota,
t1.dat_avaliacao,
split_part(split_part(t1.dimensao_avaliacao, ',', n.n), ',', 1) dimensao_avaliacao    
FROM indicadores_cvi as t1
CROSS JOIN 
(
    SELECT a.N + b.N * 10 + 1 n
    FROM 
    (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
    (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    ORDER BY n
) n
 WHERE n.n <= 1 + (LENGTH(t1.dimensao_avaliacao) - LENGTH(REPLACE(t1.dimensao_avaliacao, ',', '')))
  AND dimensao_avaliacao <> ''
 ORDER BY 
  t1.protocolo,
t1.cod_etapa,
t1.cod_ciclo,
t1.nota,
t1.dat_avaliacao
);

TRUNCATE public.indicadores_pesca;
TRUNCATE public.indicadores_pesca_dimensao;
