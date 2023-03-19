SELECT
  max(a.DTMOV) AS ult_entrada,
  a.CODPROD,
  b.DESCRICAO,
  b.CODSEC,
  (SELECT
    pcsecao.DESCRICAO FROM
    pcsecao WHERE
    pcsecao.CODSEC = b.CODSEC) AS secao,
  (SELECT
    pcest.QTGIRODIA FROM
    pcest WHERE
    pcest.CODPROD = a.CODPROD AND pcest.CODFILIAL = a.CODFILIAL) AS Qtgirodia,
  (SELECT
    pchistest.QTESTGER FROM
    pchistest WHERE
    pchistest.CODPROD = a.CODPROD AND pchistest.CODFILIAL = a.CODFILIAL AND pchistest.DATA = (a.dtmov - 1)) AS
  estoque_dia_anterior,
  (SELECT
    pcest.QTESTGER FROM
    pcest WHERE
    pcest.CODPROD = a.CODPROD AND pcest.CODFILIAL = a.CODFILIAL) AS estoque,
  b.QTUNITCX AS fator_cx,
  (SELECT
    emb.PVENDA FROM
    vw_preco_mercale emb WHERE
    emb.CODFILIAL = a.CODFILIAL AND emb.QTUNIT = 1 AND emb.CODAUXILIAR = a.CODAUXILIAR AND emb.NUMSEQATU IN (SELECT
      Max(vw_preco_mercale.NUMSEQATU) FROM
      vw_preco_mercale WHERE
      vw_preco_mercale.CODFILIAL = a.CODFILIAL AND vw_preco_mercale.CODAUXILIAR = emb.CODAUXILIAR)) AS preco,
  (SELECT
    emb.MARGEMPRECIFICACAO FROM
    vw_preco_mercale emb WHERE
    emb.CODFILIAL = a.CODFILIAL AND emb.QTUNIT = 1 AND emb.CODAUXILIAR = a.CODAUXILIAR AND emb.NUMSEQATU IN (SELECT
      Max(vw_preco_mercale.NUMSEQATU) FROM
      vw_preco_mercale WHERE
      vw_preco_mercale.CODFILIAL = a.CODFILIAL AND vw_preco_mercale.CODAUXILIAR = emb.CODAUXILIAR)) AS margem_preco,
  (SELECT
    CASE
      WHEN pcest.QTGIRODIA = 0 OR pcest.QTESTGER = 0
      THEN 0
      ELSE round(pcest.QTESTGER / pcest.QTGIRODIA)
    END AS Est_dias FROM
    pcest WHERE
    pcest.CODFILIAL = a.CODFILIAL AND pcest.CODPROD = a.CODPROD) AS Dias_est,
  :Dias AS Dias_p_Comprar,
  (SELECT
    (pcest.QTGIRODIA * :Dias) - pcest.QTESTGER FROM
    pcest WHERE
    pcest.CODPROD = a.CODPROD AND pcest.CODFILIAL = a.CODFILIAL) AS Sugestao,
  Sum(a.QTCONT) AS entrada_periodo,
  round(Avg(a.PUNITCONT), 2) AS pcompra_periodo,
  round(Sum(a.QTCONT * a.PUNITCONT), 2) AS valor_periodo,
  (SELECT
    pcest.QTPEDIDA FROM
    pcest WHERE
    pcest.CODFILIAL = a.CODFILIAL AND pcest.CODPROD = a.CODPROD) AS qtpedida,
    (SELECT 
    SUM(DECODE(CODOPER,'SP',QT,0) FROM PCMOV WHERE CODOPER='SP' AND codprod = A.CODPROD AND codfilial = a.codfilial and dtcancel is null) perda
FROM
  pcmov a,
  pcprodut b
WHERE
  a.CODPROD = b.CODPROD
  AND a.DTMOV BETWEEN :Datai AND :Dataf
  AND a.CODFILIAL = :filial
  AND a.CODOPER = 'E'
  AND a.CODEPTO IN (:CODEPTO)
  AND a.CODSEC IN (:CODSEC)
GROUP BY
  a.DTMOV,
  a.CODPROD,
  b.DESCRICAO,
  b.CODSEC,
  a.CODFILIAL,
  a.CODAUXILIAR,
  b.qtunitcx

