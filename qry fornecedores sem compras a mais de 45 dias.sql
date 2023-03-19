  SELECT   a.codfornec, a.fornecedor,MAX(B.CODCOMPRADOR) CodigoComprador, c.nome_guerra as comprador, MAX (b.dtemissao)
    FROM   pcfornec a, pcpedido b , pcempr c
   WHERE   a.codfornec = b.codfornec and b.codcomprador = c.matricula AND a.codfornec <> 61
GROUP BY   a.codfornec, a.fornecedor ,c.nome_guerra
  HAVING   (TRUNC (SYSDATE) - MAX (b.dtemissao)) > 45
