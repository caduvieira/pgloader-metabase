\copy (SELECT cod_processo,configuracao_orgao_id, protocolo, nome_orgao, nome_servico, cod_ciclo, cod_etapa, nome_etapa, cod_tipo_etapa, nome_tipo_etapa, ide_finalizado, status_processo, dat_abertura, dat_encerramento, dat_conclusao_etapa, id_fase_processo, nome_fase_processo, cod_servico, cod_orgao, situacao_atual FROM indicadores) TO '/tmp/indicadores.csv' DELIMITER ',' CSV HEADER;