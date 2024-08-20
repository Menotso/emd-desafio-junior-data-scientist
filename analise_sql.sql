-- 1: Quantos chamados foram abertos no dia 01/04/2023?
-- R: 1756 chamados foram abertoes neste dia.
SELECT 
    COUNT(*) AS chamados
FROM 
    `datario.adm_central_atendimento_1746.chamado`
WHERE 
    DATE(data_inicio) = '2023-04-01'

-- 2. Qual o tipo de chamado que teve mais teve chamados abertos no dia 01/04/2023?
-- R: Estacionamento irregular com 366 chamados abertos.
SELECT 
    tipo, COUNT(*) AS chamadas_por_tipo 
FROM 
    `datario.adm_central_atendimento_1746.chamado`
WHERE 
    DATE(data_inicio) = '2023-04-01'
GROUP BY 
    tipo
ORDER BY 
    chamadas_por_tipo DESC

-- 3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
-- R: Campo Grande, Tijuca e Barra da Tijuca. Importante salientar que há 73 chamados não associados a um bairro, por isso o bairro 128 foi incluído no top 3.
SELECT 
  `datario.adm_central_atendimento_1746.chamado`.id_bairro,
  `datario.dados_mestres.bairro`.nome as nome_bairro,
  COUNT(*) AS qtd_chamado 
FROM 
  `datario.adm_central_atendimento_1746.chamado`
LEFT JOIN 
  `datario.dados_mestres.bairro`
  ON `datario.adm_central_atendimento_1746.chamado`.id_bairro = `datario.dados_mestres.bairro`.id_bairro
WHERE
  DATE(data_inicio) = '2023-04-01'
GROUP BY
  id_bairro, nome_bairro
ORDER BY
  qtd_chamado DESC

-- 4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
-- R: subprefeitura 'Zona Norte', com 510 chamados abertos.
SELECT 
  `datario.dados_mestres.bairro`.subprefeitura,
  COUNT(*) AS qtd_chamado 
FROM 
  `datario.adm_central_atendimento_1746.chamado`
LEFT JOIN 
  `datario.dados_mestres.bairro`
  ON `datario.adm_central_atendimento_1746.chamado`.id_bairro = `datario.dados_mestres.bairro`.id_bairro
WHERE
  DATE(data_inicio) = '2023-04-01'
GROUP BY
  subprefeitura
ORDER BY
  qtd_chamado DESC

/*
5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
R: Sim, existem 73 chamados abertos que não foram associados a um bairro ou subprefeitura.
    Pode ocorrer por dois motivos: 
    1. Erro de digitação/inserção; ou
    2. A informação de bairro/subprefeitura foi corrompida pelo próprio código do sistema que o insere.
*/
SELECT 
  `datario.dados_mestres.bairro`.nome as nome_bairro,
  `datario.dados_mestres.bairro`.subprefeitura,
  COUNT(*) AS qtd_chamado 
FROM 
  `datario.adm_central_atendimento_1746.chamado`
LEFT JOIN 
  `datario.dados_mestres.bairro`
  ON `datario.adm_central_atendimento_1746.chamado`.id_bairro = `datario.dados_mestres.bairro`.id_bairro
WHERE
  DATE(data_inicio) = '2023-04-01'
GROUP BY
  nome_bairro, subprefeitura
ORDER BY
  qtd_chamado DESC

-- 6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
-- R: 42.830 chamados abertos nas datas acima mencionadas, incluindo extremidades.
SELECT 
  subtipo, COUNT(*) as chamados_por_subtipo
FROM 
  `datario.adm_central_atendimento_1746.chamado`
WHERE 
  DATE(data_inicio) BETWEEN '2022-01-01' AND '2023-12-31' AND subtipo = 'Perturbação do sossego'
GROUP BY 
  subtipo

-- 7. Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).
-- R:  834 chamados durante o Rock in Rio, 241 chamados durante o Carnaval e 139 chamados durante o Reveillon.
SELECT 
  evento,
  COUNT(*) as chamados_por_evento
FROM 
  `datario.adm_central_atendimento_1746.chamado`
LEFT JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`
  ON DATE(`datario.adm_central_atendimento_1746.chamado`.data_inicio) 
    BETWEEN 
      DATE(`datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`.data_inicial) AND DATE(`datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`.data_final)
WHERE 
  subtipo = 'Perturbação do sossego'
GROUP BY 
  evento
