WITH CLI AS (
SELECT DISTINCT C.CLICODIGO,
                  CLINOMEFANT,
                   C.GCLCODIGO,
                      GCLNOME,  
                       SETOR
                         FROM CLIEN C
                          INNER JOIN (SELECT CLICODIGO,ZODESCRICAO SETOR FROM ENDCLI E
                           INNER JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA WHERE ZOCODIGO IN (20))Z ON 
                            E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                             LEFT JOIN GRUPOCLI GR ON C.GCLCODIGO=GR.GCLCODIGO
                              WHERE CLICLIENTE='S'),
                              
                              -- PREÇOS
                               
                               PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
                               
                                -- TAB PRECO
                               
                                TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                                 WHERE TBPSITUACAO='A'
                                  AND (TBPDTVALIDADE=NULL OR TBPDTVALIDADE>='TODAY')),
                                 
                                  -- PRODUTO 
                               
                                   PROD AS (SELECT TB.PROCODIGO,
                                              TBPPCDESCTO2 DESCTO_PROMO,
                                               ROUND(PREPCOVENDA2*(1-TBPPCDESCTO2*1.00/100)*2,2) VALOR_PROMO
                                                FROM TBPPRODU TB
                                                 LEFT JOIN PRECO PC ON PC.PROCODIGO=TB.PROCODIGO
                                                  WHERE TBPCODIGO=1642 AND TB.PROCODIGO='LA0182')
                                                
                                                
                              
SELECT * FROM CLI
 CROSS JOIN PROD
 


