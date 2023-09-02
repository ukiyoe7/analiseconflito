## ANALISE DE CONFLITOS 
## 01.09.2023
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)

con2 <- dbConnect(odbc::odbc(), "reproreplica", timeout = 10,encoding="Latin1")


## CLIENTES ==================

cli<- dbGetQuery(con2, statement = read_file('CLIENTES.sql'))

inativos<- dbGetQuery(con2, statement = read_file('INATIVOS.sql'))

clien <-
anti_join(cli,inativos,by="CLICODIGO")

View(clien)


## TAB PROMO ==================

tab_promo <- dbGetQuery(con2, statement = read_file('TAB_PROMO.sql'))

View(tab_promo)


## CLI PROMO ==================

cli_promo <- dbGetQuery(con2, statement = read_file('CLI_PROMO.sql'))

View(cli_promo)


## PACOTES ==================


pacotes <- dbGetQuery(con2, statement = read_file('PACOTES.sql'))

View(pacotes)

## COMBINADOS ==================

comb <- dbGetQuery(con2, statement = read_file('COMBINADOS.sql'))

View(comb)

## TABELAS ==================


tabelas1 <- dbGetQuery(con2, statement = read_file('TABELAS.sql'))

View(tabelas1)

tabelas %>% .[duplicated(.$CLICODIGO),]


## RELREPRO ==================


relrepro <- dbGetQuery(con2, statement = read_file('RELREPRO.sql'))

View(relrepro)

## DESCT GERAL ==================

descto_geral <- dbGetQuery(con2, statement = read_file('DESCTO_GERAL.sql'))

View(descto_geral)


## MONTAGEM ==================


## gera tabela com a montagem

montagem <- dbGetQuery(con2, statement = read_file('MONTAGEM.sql'))

View(montagem)

montagem_tab <- dbGetQuery(con2, statement = read_file('MONTAGEM_TAB.sql')) %>% 
  mutate(VALOR_MONT3=if_else(!is.na(VALOR_MONT1),VALOR_MONT1,VALOR_MONT2))

View(montagem_tab)


## desconto geal montagem

descto_geral_mont <- dbGetQuery(con2, statement = read_file('DESCTO_GERAL_MONT.sql')) 

View(descto_geral_mont)


## mesclar cliente montagem desconto geral

join_cli_promo_mont <-
 left_join(clien,descto_geral_mont,by="CLICODIGO")  %>% select(-CLIPCDESCPRODU)
View(join_cli_promo_mont)

## mesclar tabelas

join_geraL_tab_mont <-
 left_join(merge_cli_promo,montagem_tab,by=c("CLICODIGO","PROCODIGO_MONT")) %>% 
  mutate(VALOR_MONT4=if_else(is.na(TBPCODIGO_MONT),PRECO_MONT_GERAL,VALOR_MONT3)) %>% 
   select(CLICODIGO,PROCODIGO_MONT,VALOR_MONT4)
  
  View(join_geraL_tab_mont)


  merge_mont %>% .[duplicated(.$CLICODIGO),]

## SET JOINS  =====================

merge_cli_promo <- merge(clien,tab_promo)

conflict_set <- 
left_join(merge_cli_promo,cli_promo,by="CLICODIGO") %>% 
           left_join(.,descto_geral %>% select(-PROCODIGO),by="CLICODIGO") %>% 
            left_join(.,pacotes,by="CLICODIGO") %>% 
             left_join(.,comb,by="CLICODIGO") %>% 
              left_join(.,tabelas1,by="CLICODIGO") %>% 
               left_join(.,montagem,by="CLICODIGO")

View(conflict_set)

## WRITE CSV  =====================


write.csv2(conflict_set,file = "conflict_set.csv" ,row.names = FALSE ,na="")


##  TESTS =====================================================


test2 <- dbGetQuery(con2, statement = read_file('TEST.sql'))

View(test2)




