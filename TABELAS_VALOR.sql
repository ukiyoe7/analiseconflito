WITH TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                                 WHERE TBPSITUACAO='A'
                                  AND (TBPDTVALIDADE IS NULL OR TBPDTVALIDADE>='TODAY')),
                                  
TABPROMO AS (SELECT TBPCODIGO FROM TABPRECO WHERE TBPCODIGO=1642), 

 TABPROD AS (SELECT DISTINCT PROCODIGO FROM TBPPRODU T
                                  INNER JOIN TABPROMO TP ON T.TBPCODIGO=TP.TBPCODIGO
                                   ),
 
 PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
                                  
    CLITB AS (SELECT DISTINCT C.TBPCODIGO,C.CLICODIGO FROM CLITBP C
                  INNER JOIN TBPRECO  T ON C.TBPCODIGO=T.TBPCODIGO),
                                  
TAB AS (SELECT C.CLICODIGO,
         T.PROCODIGO,
          MAX(TBPPCOVENDA2)MXVALOR
  FROM TBPPRODU T
   LEFT JOIN PRECO PC ON PC.PROCODIGO=T.PROCODIGO
    INNER JOIN TABPROD TP ON T.PROCODIGO=TP.PROCODIGO
      INNER JOIN CLITB C ON T.TBPCODIGO=C.TBPCODIGO
       WHERE T.TBPCODIGO<>1642
       GROUP BY 1,2)
      
SELECT C.CLICODIGO,
        T.TBPCODIGO TBPCODIGO_TAB,
         T.PROCODIGO PROCODIGO_TAB,
           TBPPCOVENDA2 VALOR_TAB
  FROM TBPPRODU T
   LEFT JOIN PRECO PC ON PC.PROCODIGO=T.PROCODIGO
    INNER JOIN TABPROD TP ON T.PROCODIGO=TP.PROCODIGO
      INNER JOIN CLITB C ON T.TBPCODIGO=C.TBPCODIGO
       INNER JOIN TAB TA ON TA.CLICODIGO=C.CLICODIGO AND T.TBPPCDESCTO2=TA.MXVALOR
        WHERE T.TBPCODIGO<>1642
       
       
       
       
       
       