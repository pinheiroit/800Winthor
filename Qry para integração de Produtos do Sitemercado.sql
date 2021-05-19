SELECT 
             EMB.CODFILIAL AS ID_LOJA,
             SEC.DESCRICAO AS DEPARTAMENTO,
             CAT.CATEGORIA AS CATEGORIA,
             SUB.SUBCATEGORIA AS SUBCATEGORIA,
             MAR.MARCA AS MARCA,
             EMB.UNIDADE AS UNIDADE,
             EMB.EMBALAGEM AS VOLUME,
             EMB.CODAUXILIAR AS CODIGO_BARRA,
             NVL(EMB.DESCRICAOECF,PROD.DESCRICAO) AS NOME,
             PROD.DTCADASTRO AS DT_CADASTRO,
             PROD.dtultaltcom AS DT_ULTIMA_ALTERACAO,
             EMB.PVENDA VLR_PRODUTO,
            nvl((select nvl(NVL(item.vlofertaatac,item.vloferta),0)
       from pcofertaprogramadac cab,
              pcofertaprogramadai item
              where cab.codoferta = item.codoferta
              and  item.codauxiliar = emb.codauxiliar
              and  cab.codfilial = item.codfilial
              and  item.codauxiliar = prod.codauxiliar
              and  cab.dtcancel is null
              and  cab.codfilial=1
              and  cab.dtinicial <= trunc(sysdate)
              and  cab.dtfinal >= trunc(sysdate)),0) as vlr_promocao,
             nvl((EST.QTESTGER-EST.QTBLOQUEADA),0) AS QTD_ESTOQUE_ATUAL,
             nvl(EMB.QTMINGONDOLA,0) AS QT_ESTOQUE_MINIMO,
             NVL(EMB.DESCRICAOECF,PROD.DESCRICAO) AS DESCRICAO,
             case when PROD.OBS2 = 'FL' THEN 'N' ELSE 'S' END AS ATIVO,
             EMB.CODPROD AS PLU,
             nvl(EST.VALORULTENT,0) AS VLR_COMPRA,
             'N' AS VALIDADE_PROXIMA,
             0   AS VLR_ATACADO,
             0   AS QTD_ATACADO,
             ''  AS IMAGE_URL
             FROM   PCEMBALAGEM EMB, PCPRODUT PROD, PCSECAO SEC,PCCATEGORIA CAT, PCSUBCATEGORIA SUB, PCEST EST,
             PCMARCA MAR
             WHERE PROD.CODPROD = EMB.CODPROD
             AND   PROD.CODSEC = SEC.codsec
             AND   PROD.CODCATEGORIA = CAT.CODCATEGORIA
             AND   PROD.CODSUBCATEGORIA = SUB.CODSUBCATEGORIA
             AND   PROD.CODPROD = EST.CODPROD
             AND   PROD.CODMARCA = MAR.CODMARCA
             AND   EMB.CODFILIAL = 1
             AND   EST.CODFILIAL = 1 
             AND   PROD.DTEXCLUSAO IS NULL
             AND   EMB.QTUNIT = 1 
             AND   PROD.REVENDA='S'
             AND   EST.QTESTGER > 2
AND length(TO_CHAR(EMB.CODAUXILIAR)) <> 14
AND   SEC.DESCRICAO NOT IN('EMBALAGENS','IMOBILIZADO','INSUMOS','MATERIA PRIMA')

