WITH TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO 
                                 WHERE TBPSITUACAO='A'
                                  AND (TBPDTVALIDADE=NULL OR TBPDTVALIDADE>='TODAY') AND TBPTABCOMB='S'),
                                  
    CLITB AS (SELECT DISTINCT C.TBPCODIGO,CLICODIGO FROM CLITBPCOMB C
                  INNER JOIN TBPRECO  T ON C.TBPCODIGO=T.TBPCODIGO),                              
                                  
PRODA AS (SELECT DISTINCT PROCODIGO2 FROM PRODU WHERE PROCODIGO2='LA0182'), 

PRODB AS (SELECT DISTINCT PROCODIGO FROM PRODU WHERE PROCODIGO='MOVS'), 

PRECOA AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),

 PRECOB AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1)


SELECT
CLICODIGO,
 TBP.TBPCODIGO TBPCODIGO_COMB,
  PROCODIGOA PROD_A_COMB,
    CCINDICEPROA2 DESCTO_A_COMB,
    ROUND(PRCA.PREPCOVENDA2*(1-CCINDICEPROA2*1.00/100),2) VALOR_LENTE_COMB,
      CCPCOVENDAPROA2 VALOR_A_COMB,
       PROCODIGOB PROD_B_COMB,
         CCINDICEPROB2 DESCTO_B_COMB,
          ROUND(PRCB.PREPCOVENDA2*(1-CCINDICEPROB2*1.00/100),2) VALOR_MONTAGEM_COMB,
            CCPCOVENDAPROB2 VALOR_B_COMB,
             ROUND(PRCA.PREPCOVENDA2*(1-CCINDICEPROA2*1.00/100),2)*2+ROUND(PRCB.PREPCOVENDA2*(1-CCINDICEPROB2*1.00/100),2) TOTAL



FROM TBPCOMBPROPRO TBP
              INNER JOIN PRODA PA ON PA.PROCODIGO2=TBP.PROCODIGOA
              
               INNER JOIN PRODB PB ON PB.PROCODIGO=TBP.PROCODIGOB 
               
                LEFT JOIN PRECOA PRCA ON PRCA.PROCODIGO=TBP.PROCODIGOA
                 
                 LEFT JOIN PRECOB PRCB ON PRCB.PROCODIGO=TBP.PROCODIGOB
                 
                  INNER JOIN CLITB CT ON TBP.TBPCODIGO=CT.TBPCODIGO

                  
                 
