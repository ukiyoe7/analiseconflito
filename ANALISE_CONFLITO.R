## OVERVIEW ACORDOS
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)

con3 <- dbConnect(odbc::odbc(), "repro_prod", timeout = 10,encoding="Latin1")
con2 <- dbConnect(odbc::odbc(), "reproreplica", timeout = 10,encoding="Latin1")




df <- dbGetQuery(con2, statement = read_file('ANALISE_CONFLITO_LA.sql'))

View(df)


## TABLES =====================================================


tab_promo <- 
  dbGetQuery(con2,"
             WITH PRECO AS (SELECT PROCODIGO,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1),
             
             PROD AS (SELECT PROCODIGO,PRODESCRICAO FROM PRODU WHERE PROSITUACAO='A')
             
             SELECT T.PROCODIGO, 
                     PRODESCRICAO,
                      ROUND(PREPCOVENDA2*(1-TBPPCDESCTO2*1.00/100)*2,2) PROMO FROM TBPPRODU T
             LEFT JOIN PRECO P ON T.PROCODIGO=P.PROCODIGO
             LEFT JOIN PROD PR ON T.PROCODIGO=PR.PROCODIGO
             WHERE TBPCODIGO=1642") 

View(tab_promo)


comb_promo_prod <-dbGetQuery(con3,"
             WITH TBCOMB AS (SELECT TBPCODIGO FROM TABPRECO 
             WHERE  TBPTABCOMB='S' AND TBPSITUACAO='A'),
             
             PRODPROMO AS (SELECT PROCODIGO FROM TBPPRODU WHERE TBPCODIGO=1642),
             
             PRODA AS (SELECT P.PROCODIGO,PRODESCRICAO PROA FROM PRODU P
             INNER JOIN PRODPROMO PR ON PR.PROCODIGO=P.PROCODIGO
             WHERE PROSITUACAO='A'),
             
             PRODB AS (SELECT PROCODIGO,PRODESCRICAO PROB FROM PRODU WHERE PROSITUACAO='A'),
             
             PRECOA AS(SELECT PROCODIGO,PREPCOVENDA2 PRA FROM PREMP WHERE EMPCODIGO=1),
             
             PRECOB AS(SELECT PROCODIGO,PREPCOVENDA2 PRB FROM PREMP WHERE EMPCODIGO=1),
             
             CLITB AS (SELECT TBPCODIGO,CLICODIGO FROM CLITBPCOMB WHERE CLICODIGO=)
             
             SELECT 
              CLICODIGO,
             T.TBPCODIGO,
             PROCODIGOA,
                     PROA,
                      CCPCOVENDAPROA2,
                      CCINDICEPROA2,
                       PROCODIGOB,
                        PROB,
                         CCPCOVENDAPROB,
                         CCINDICEPROB2, 
                          ROUND(PRA*(1-CCINDICEPROA2*1.00/100)*2+PRB*(1-CCINDICEPROB2*1.00/100),2) COMBO
                          FROM TBPCOMBPROPRO T
             INNER JOIN TBCOMB TB ON TB.TBPCODIGO=T.TBPCODIGO
              LEFT JOIN PRODA PA ON PA.PROCODIGO=T.PROCODIGOA
               LEFT JOIN PRODB PB ON PB.PROCODIGO=T.PROCODIGOB
                LEFT JOIN PRECOA PRA ON PRA.PROCODIGO=T.PROCODIGOA   
                 LEFT JOIN PRECOB PRB ON PRB.PROCODIGO=T.PROCODIGOB
                  LEFT JOIN CLITB CT ON CT.TBPCODIGO=T.TBPCODIGO
                             ") 

View(comb_promo_prod)


inner_join(tab_promo,tab_promo_comb,by="PROCODIGO") %>% View()


