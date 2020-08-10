ALTER TABLE indicadores_hom ADD COLUMN IF NOT EXISTS situacao_atual varchar(3);

UPDATE indicadores_hom 
SET situacao_atual = 'sim'
FROM ( SELECT
  protocolo,
  MAX(dat_encerramento) as ultima_data
  FROM
  indicadores_hom 
  GROUP BY
  protocolo) AS subquery
WHERE 
indicadores_hom.protocolo = subquery.protocolo
AND indicadores_hom.dat_encerramento = subquery.ultima_data;

DROP TABLE IF EXISTS public.indicadores_hom_dimensao;

CREATE TABLE public.indicadores_hom_dimensao
(
    protocolo character varying(100) COLLATE pg_catalog."default" NOT NULL DEFAULT NULL::character varying,
    nota integer NOT NULL,
    cod_ciclo smallint NOT NULL,
    cod_etapa smallint NOT NULL,
    dat_avaliacao timestamp without time zone NOT NULL,
    dimensao_avaliacao text COLLATE pg_catalog."default" NOT NULL,
    nome_servico character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT indicadores_hom_dimensao_pkey PRIMARY KEY (protocolo, nota, cod_ciclo, cod_etapa, dat_avaliacao, dimensao_avaliacao)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

INSERT INTO public.indicadores_hom_dimensao(
protocolo, nota, cod_ciclo, cod_etapa, dat_avaliacao, dimensao_avaliacao,nome_servico)
(
SELECT
t1.protocolo,
t1.cod_etapa,
t1.cod_ciclo,
t1.nota,
t1.dat_avaliacao,
split_part(split_part(t1.dimensao_avaliacao, ',', n.n), ',', 1) dimensao_avaliacao,
t1.nome_servico
FROM indicadores_hom as t1
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
t1.dat_avaliacao,
t1.nome_servico
);
