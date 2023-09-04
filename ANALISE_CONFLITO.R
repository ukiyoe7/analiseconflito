## ANALISE DE CONFLITOS 
## 01.09.2023
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)

con2 <- dbConnect(odbc::odbc(), "reproreplica", timeout = 10,encoding="Latin1")


## CLIENTES ==================

cli<- dbGetQuery(con2, statement = read_file('CLIENTES.sql'))

inativos<- dbGetQuery(con2, statement = read_file('INATIVOS.sql'))

clien <- anti_join(cli,inativos,by="CLICODIGO")

View(clien)


## DESCONTO GERAL ==================

descto_geral <- dbGetQuery(con2, statement = read_file('DESCTO_GERAL.sql'))

View(descto_geral)

descto_geral <-
 merge(clien,descto_geral) %>% 
  mutate(VALOR_DESCTO_GERAL= round(PREPCOVENDA2*(1- CLIPCDESCPRODU*1.00/100)*2,2)) %>% 
   select(CLICODIGO,PROCODIGO,VALOR_DESCTO_GERAL)

View(descto_geral)


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


tabelas <- dbGetQuery(con2, statement = read_file('TABELAS.sql'))

View(tabelas)


tabelas_valor <- dbGetQuery(con2, statement = read_file('TABELAS_VALOR.sql'))

View(tabelas_valor)

tabelas %>% .[duplicated(.$CLICODIGO),]


## RELREPRO ==================


relrepro <- dbGetQuery(con2, statement = read_file('RELREPRO.sql'))

View(relrepro)



## MONTAGEM ==================


## gera tabela com a montagem

montagem <- dbGetQuery(con2, statement = read_file('MONTAGEM.sql'))

View(montagem)


## desconto geal montagem

descto_geral_mont <- dbGetQuery(con2, statement = read_file('DESCTO_GERAL_MONT.sql')) 

View(descto_geral_mont)


## mesclar cliente montagem desconto geral

join_cli_promo_mont <-
  left_join(clien,descto_geral_mont,by="CLICODIGO")  %>% select(-CLIPCDESCPRODU)
View(join_cli_promo_mont)

## DESCTO TABELAS

mont_valor_tab <- dbGetQuery(con2, statement = read_file('MONTAGEM_VALOR_TAB.sql'))

mont_descto_tab <- dbGetQuery(con2, statement = read_file('MONTAGEM_DESCTO_TAB.sql'))

mont_tab <-
left_join(clien %>% select(CLICODIGO),mont_valor_tab,by=c("CLICODIGO")) %>% 
   left_join(.,mont_descto_tab,by=c("CLICODIGO")) 

View(mont_tab)

mont_tab %>% .[duplicated(.$CLICODIGO),]


## DESCTO GERAL DESCTO TABELAS

montagem <- 
left_join(join_cli_promo_mont,mont_tab,by="CLICODIGO") %>% .[,c(1,6:16)]


montagem %>% .[duplicated(.$CLICODIGO),]

## SET JOINS  =====================

merge_cli_promo <- merge(clien,tab_promo)

View(merge_cli_promo)

conflict_set <- 
left_join(merge_cli_promo,cli_promo,by="CLICODIGO") %>% 
           left_join(.,descto_geral,by=c("CLICODIGO","PROCODIGO")) %>% 
            left_join(.,pacotes,by=c("CLICODIGO","PROCODIGO")) %>% 
             left_join(.,comb,by=c("CLICODIGO","PROCODIGO")) %>% 
              left_join(.,tabelas,by=c("CLICODIGO","PROCODIGO")) %>% 
               left_join(.,montagem,by="CLICODIGO")

View(conflict_set)

## WRITE CSV  =====================


write.csv2(conflict_set,file = "conflict_set.csv" ,row.names = FALSE ,na="")


##  TESTS =====================================================


test2 <- dbGetQuery(con2, statement = read_file('TEST.sql'))

View(test2)




