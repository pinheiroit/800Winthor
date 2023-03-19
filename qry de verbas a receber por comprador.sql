select NUMVERBA,codfornec,codcomprador,(debito-credito) saldo
from   (select A.NUMVERBA,(select codfornec from pcverba where numverba = a.numverba) codfornec,(select codcomprador from pcverba where numverba = a.numverba) codcomprador,
               sum(decode(a.tipo,'D',a.valor,0)) Debito,
               sum(decode(a.tipo,'C',a.valor,0)) Credito
       from pcmovcrfor a
group by A.NUMVERBA) where (debito-credito) >0
 
 
 
 select * from pcmovcrfor where numverba in (12194,10337,10336,10338)
 
 select * from pcfornec where codfornec = 1073
