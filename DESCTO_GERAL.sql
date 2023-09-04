WITH PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
                               
                        -- TAB PRECO
                               
                          TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                            WHERE TBPSITUACAO='A'
                             AND (TBPDTVALIDADE=NULL OR TBPDTVALIDADE>='TODAY') AND TBPCODIGO=1642)
                                 
                                  -- PRODUTO 
                               
                                        SELECT 
                                           DISTINCT 
                                            T.PROCODIGO,
                                              PREPCOVENDA2
                                              FROM TBPPRODU T
                                               INNER JOIN PRECO PC ON PC.PROCODIGO=T.PROCODIGO
                                                INNER JOIN TBPRECO TP ON T.TBPCODIGO=TP.TBPCODIGO
            
            