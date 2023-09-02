WITH CLI as (
SELECT DISTINCT C.CLICODIGO,
                 CLIPCDESCPRODU
                  FROM CLIEN C
                   WHERE CLICLIENTE='S'),
                  
                    -- PREÇOS
                               
                      PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
                                 
                         -- PRODUTO 
                               
                                 PROD AS (SELECT 
                                            P.PROCODIGO,
                                             PREPCOVENDA2
                                              FROM PRODU P
                                               INNER JOIN PRECO PE ON P.PROCODIGO=PE.PROCODIGO
                                                AND P.PROCODIGO='MOVS')
                                                 
      SELECT 
       CLICODIGO,
        PROCODIGO PROCODIGO_MONT,
          PREPCOVENDA2 PRECO_TABELA_MONT,
            IIF(CLIPCDESCPRODU IS NULL,
             PREPCOVENDA2,
              ROUND(PREPCOVENDA2*(1- CLIPCDESCPRODU*1.00/100),2)) PRECO_GERAL_MONT 
               FROM CLI
                CROSS JOIN PROD  
             
             
               