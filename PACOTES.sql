WITH 

CLI AS (SELECT * FROM PCTCLI WHERE PCTSITUACAO<>'C'),

TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                                 WHERE TBPSITUACAO='A'
                                  AND (TBPDTVALIDADE=NULL OR TBPDTVALIDADE>='TODAY')),
                               
TBPROD AS (SELECT TB.PROCODIGO
                    FROM TBPPRODU TB
                     WHERE TBPCODIGO=1642),

PCT AS (
       SELECT CLICODIGO,
        PCTDTFIM,
         PCTDTSUSP
         ,P.* FROM PCTPRO P
          INNER JOIN CLI C ON P.PCTNUMERO=C.PCTNUMERO
           INNER JOIN TBPROD T ON  P.PROCODIGO=T.PROCODIGO),

PCT1 AS (  
      SELECT DISTINCT 
        CLICODIGO,
         MIN(PCPSALDO) SALDO 
          FROM PCT
           WHERE PCTDTFIM>='TODAY' AND PCPSALDO>0
            GROUP BY 1)
            
      SELECT DISTINCT 
        P.CLICODIGO,
         PROCODIGO,
          PCTNUMERO,
           SALDO,
            PCPPCOUNIT VLR_PC_PCT,
             PCPPCOUNIT*2 VLR_PAR_PCT
              FROM PCT P
               INNER JOIN PCT1 P1 ON P1.SALDO=P.PCPSALDO AND P.CLICODIGO=P1.CLICODIGO
                WHERE PCTDTFIM>='TODAY' AND PCPSALDO>0
                 GROUP BY 1,2,3,4,5
            

