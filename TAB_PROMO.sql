WITH PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
                               
           TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                                 WHERE TBPSITUACAO='A'
                                  AND (TBPDTVALIDADE=NULL OR TBPDTVALIDADE>='TODAY'))
                            
                               
                                   SELECT TB.PROCODIGO,
                                              TBPPCDESCTO2 DESCTO_PROMO,
                                               ROUND(PREPCOVENDA2*(1-TBPPCDESCTO2*1.00/100)*2,2) VALOR_PROMO
                                                FROM TBPPRODU TB
                                                 LEFT JOIN PRECO PC ON PC.PROCODIGO=TB.PROCODIGO
                                                  WHERE TBPCODIGO=1642 
                                                
