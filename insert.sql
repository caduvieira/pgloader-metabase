ALTER TABLE indicadores ADD COLUMN IF NOT EXISTS situacao_atual varchar(3);

UPDATE indicadores 
SET situacao_atual = 'sim'
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

DROP TABLE IF EXISTS public.indicadores_cvi;

CREATE TABLE public.indicadores_cvi
(
    cod_processo integer NOT NULL,
    configuracao_orgao_id integer,
    protocolo character varying(100) COLLATE pg_catalog."default" NOT NULL DEFAULT NULL::character varying,
    nome_orgao character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    nome_servico character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cod_ciclo smallint NOT NULL,
    cod_etapa smallint NOT NULL,
    nome_etapa character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cod_tipo_etapa smallint,
    nome_tipo_etapa character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    ide_finalizado character varying(1) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    status_processo character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cpf_cidadao character varying(50) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    dat_abertura timestamp without time zone,
    dat_encerramento timestamp without time zone NOT NULL,
    dat_conclusao_etapa timestamp without time zone,
    nota integer,
    dimensao_avaliacao text COLLATE pg_catalog."default",
    dat_avaliacao timestamp without time zone,
    id_fase_processo numeric(19,0) DEFAULT NULL::numeric,
    nome_fase_processo character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cod_servico integer NOT NULL,
    cod_orgao integer NOT NULL,
    atendente text COLLATE pg_catalog."default",
    situacao_atual character varying(3) COLLATE pg_catalog."default",
    CONSTRAINT indicadores_cvi_pkey PRIMARY KEY (cod_processo, protocolo, cod_servico, cod_orgao, cod_etapa, dat_encerramento, cod_ciclo)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

INSERT INTO public.indicadores_cvi(
cod_processo, configuracao_orgao_id, protocolo, nome_orgao, nome_servico, cod_ciclo, cod_etapa, nome_etapa, cod_tipo_etapa, nome_tipo_etapa, ide_finalizado, status_processo, cpf_cidadao, dat_abertura, dat_encerramento, dat_conclusao_etapa, nota, dimensao_avaliacao, dat_avaliacao, id_fase_processo, nome_fase_processo, cod_servico, cod_orgao, atendente, situacao_atual)
(
SELECT * FROM indicadores WHERE cod_servico IN (1159,6906)
);

DROP TABLE IF EXISTS public.indicadores_cvi_dimensao;

CREATE TABLE public.indicadores_cvi_dimensao
(
    protocolo character varying(100) COLLATE pg_catalog."default" NOT NULL DEFAULT NULL::character varying,
    nota integer NOT NULL,
    cod_ciclo smallint NOT NULL,
    cod_etapa smallint NOT NULL,
    dat_avaliacao timestamp without time zone NOT NULL,
    dimensao_avaliacao text COLLATE pg_catalog."default" NOT NULL,
    nome_servico character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT indicadores_cvi_dimensao_pkey PRIMARY KEY (protocolo, nota, cod_ciclo, cod_etapa, dat_avaliacao, dimensao_avaliacao)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

INSERT INTO public.indicadores_cvi_dimensao(
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
t1.dat_avaliacao,
t1.nome_servico
);

--- Pesca
DROP TABLE IF EXISTS public.indicadores_pesca;

CREATE TABLE public.indicadores_pesca
(
    cod_processo integer NOT NULL,
    configuracao_orgao_id integer,
    protocolo character varying(100) COLLATE pg_catalog."default" NOT NULL DEFAULT NULL::character varying,
    nome_orgao character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    nome_servico character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cod_ciclo smallint NOT NULL,
    cod_etapa smallint NOT NULL,
    nome_etapa character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cod_tipo_etapa smallint,
    nome_tipo_etapa character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    ide_finalizado character varying(1) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    status_processo character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cpf_cidadao character varying(50) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    dat_abertura timestamp without time zone,
    dat_encerramento timestamp without time zone NOT NULL,
    dat_conclusao_etapa timestamp without time zone,
    nota integer,
    dimensao_avaliacao text COLLATE pg_catalog."default",
    dat_avaliacao timestamp without time zone,
    id_fase_processo numeric(19,0) DEFAULT NULL::numeric,
    nome_fase_processo character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cod_servico integer NOT NULL,
    cod_orgao integer NOT NULL,
    atendente text COLLATE pg_catalog."default",
    situacao_atual character varying(3) COLLATE pg_catalog."default",
    CONSTRAINT indicadores_pesca_pkey PRIMARY KEY (cod_processo, protocolo, cod_servico, cod_orgao, cod_etapa, dat_encerramento, cod_ciclo)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

INSERT INTO public.indicadores_pesca(
cod_processo, configuracao_orgao_id, protocolo, nome_orgao, nome_servico, cod_ciclo, cod_etapa, nome_etapa, cod_tipo_etapa, nome_tipo_etapa, ide_finalizado, status_processo, cpf_cidadao, dat_abertura, dat_encerramento, dat_conclusao_etapa, nota, dimensao_avaliacao, dat_avaliacao, id_fase_processo, nome_fase_processo, cod_servico, cod_orgao, atendente, situacao_atual)
(
SELECT * FROM indicadores WHERE cod_servico IN (10008,10010)
);

DROP TABLE IF EXISTS public.indicadores_pesca_dimensao;

CREATE TABLE IF NOT EXISTS public.indicadores_pesca_dimensao
(
    protocolo character varying(100) COLLATE pg_catalog."default" NOT NULL DEFAULT NULL::character varying,
    nota integer NOT NULL,
    cod_ciclo smallint NOT NULL,
    cod_etapa smallint NOT NULL,
    dat_avaliacao timestamp without time zone NOT NULL,
    dimensao_avaliacao text COLLATE pg_catalog."default" NOT NULL,
    nome_servico character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT indicadores_pesca_dimensao_pkey PRIMARY KEY (protocolo, nota, cod_ciclo, cod_etapa, dat_avaliacao, dimensao_avaliacao)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

INSERT INTO public.indicadores_pesca_dimensao(
protocolo, nota, cod_ciclo, cod_etapa, dat_avaliacao, dimensao_avaliacao, nome_servico)
(
SELECT
t1.protocolo,
t1.cod_etapa,
t1.cod_ciclo,
t1.nota,
t1.dat_avaliacao,
split_part(split_part(t1.dimensao_avaliacao, ',', n.n), ',', 1) dimensao_avaliacao,
t1.nome_servico
FROM indicadores_pesca as t1
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
