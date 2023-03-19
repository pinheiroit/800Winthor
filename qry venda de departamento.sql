SELECT codsec,secao,codepto,round(venda_atual,2) venda_atual,round(venda_anterior,2) venda_anterior,case when margem_atual = 0 or venda_atual = 0 then 0 else round(((margem_atual/venda_atual)*100),2) end margem_atual,
    case when margem_anterior = 0 or venda_anterior = 0 then 0 else round(((margem_anterior/venda_anterior)*100),2) end margem_anterior,
    case when venda_atual = 0 or venda_anterior = 0 then 0 else round(( ((venda_atual) / venda_anterior) *100)-100,2) end evo
    from pcprodut p left join pcmov m on p.codprod = m.codprod where m.codoper='S' and   m.dtcancel is null and
    m.numtransvenda in (select numtransvenda from pcnfsaid where tipovenda in ('VV','VP') and dtsaida between :dataAntIni and :dataFim and codfilial in (:Filial))
    and   m.dtmov between :dataAntIni and :dataFim
    and   m.codfilial in (:Filial) group by m.codsec,m.codepto) order by venda_atual desc

