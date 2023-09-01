WITH CLI as (
SELECT DISTINCT C.CLICODIGO,
                 CLIPCDESCPRODU
                  FROM CLIEN C
                   WHERE CLICLIENTE='S'),
                  
                    -- PREÇOS
                               
                      PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
                               
                        -- TAB PRECO
                               
                          TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                            WHERE TBPSITUACAO='A'
                             AND (TBPDTVALIDADE=NULL OR TBPDTVALIDADE>='TODAY') AND TBPCODIGO=1642),
                                 
                                  -- PRODUTO 
                               
                                 PROD AS (SELECT 
                                           DISTINCT 
                                            T.PROCODIGO,
                                              PREPCOVENDA2
                                              FROM TBPPRODU T
                                               INNER JOIN TBPRECO TP ON T.TBPCODIGO=TP.TBPCODIGO
                                                INNER JOIN PRECO PC ON PC.PROCODIGO=T.PROCODIGO
                                                 AND T.PROCODIGO='LA0182')
                                                 
      SELECT 
       CLICODIGO,
        PROCODIGO,
          PREPCOVENDA2*2 PRECO_TABELA,
           CLIPCDESCPRODU DESCTO_GERAL,
           ROUND(PREPCOVENDA2*(1- CLIPCDESCPRODU*1.00/100)*2,2) PRECO_GERAL  
            FROM CLI
             CROSS JOIN PROD  
            
            