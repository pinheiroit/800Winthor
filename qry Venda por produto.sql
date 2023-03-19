select codprod,produto,codcategoria,round(venda_atual,2) venda_atual,round(venda_anterior,2) venda_anterior, case when venda_atual = 0 or venda_anterior = 0 then 0 else round(( ((venda_atual) / venda_anterior) *100)-100,2) end evo
    from (select m.codprod,p.descricao as produto,p.codcategoria,sum(case when m.dtmov between :dataIni and :dataFim then (m.qt*m.punit) else 0 end)  venda_atual,
    sum(case when m.dtmov between :dataAntIni and :dataAntFim then (m.qt*m.punit) else 0 end) venda_anterior 
    from pcprodut p left join pcmov m on p.codprod = m.codprod where m.codoper='S' and m.dtcancel is null and 
    m.numtransvenda in (select numtransvenda from pcnfsaid where tipovenda in ('VV','VP') and dtsaida between :dataAntIni and :dataFim and codfilial in (1)) 
    and   m.dtmov between :dataAntIni and :dataFim
    and   p.codcategoria in (141) and m.codfilial in (1) group by m.codprod,p.descricao,p.codcategoria) order by venda_atual desc 
  
