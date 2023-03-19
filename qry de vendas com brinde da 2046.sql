 
   --select * from pcpromi where codigo = 560;
   
   
   select codigo,
          descricao,
          (select
                sum(qt)
                from pcmov 
                where codoper = 'S' 
                and dtmov between pcpromc.dtinicio and pcpromc.dtfim 
                and codfilial = pcpromc.codfilial 
                and numtransvenda in (select numtransvenda from (select numtransvenda,sum(qt) from pcmov where codprod = 79411  and dtmov between '05-mai-2022' and '07-mai-2022' group by numtransvenda having sum(qt) >= 30))
                and codauxiliar in (select pcpromi.codauxiliar
                                from pcpromi 
                                where codigo = pcpromc.codigo
                                ))  venda,
          (select 
                sum(qt)
                from pcmov 
                where codoper='S'
                and punit between 0.01 and 1
                and dtmov between pcpromc.dtinicio and pcpromc.dtfim
                and codfilial = pcpromc.codfilial
                and codauxiliar = pcpromc.codauxiliar) brinde 
                                from pcpromc where codigo = 561;
   
