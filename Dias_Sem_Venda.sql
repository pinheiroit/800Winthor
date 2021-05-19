select pcest.codfilial FL, 
       pcprodut.descricao,
       pcprodut.embalagem,
       pcprodut.unidade UN,
       pcprodut.codepto,
       pcdepto.descricao depto,
       pcprodut.codsec,
       pcsecao.descricao secao,
       pcprodut.codfornec,
       pcfornec.fornecedor,
       pcfornec.codcomprador,
       pcest.qtestger,
       pcest.dtultent,
       pcest.dtultsaida,
       ---Criar uma condição onde se a entrada for maior que a data da última venda, considero ela como referência para a quantidade de dias.
       nvl(round(((case when pcest.dtultent > pcest.dtultsaida then trunc(sysdate)- pcest.dtultent else SYSDATE-pcest.dtultsaida end)),0),0) qtdias
 from  pcest , pcprodut, pcfornec , pcdepto, pcsecao
where  pcest.codprod = pcprodut.codprod
  and  pcprodut.codfornec = pcfornec.codfornec
  and  pcprodut.codsec = pcsecao.codsec
  and  pcprodut.codepto = pcdepto.codepto
  and  pcest.qtestger > 0
  and  pcest.codfilial = :FILIAL
  and  pcprodut.codepto = :DEPTO
  and  (sysdate - pcest.dtultsaida) >= :DIAS_SEMVENDA
order
   by  pcest.codfilial, (sysdate - pcest.dtultsaida) desc
