## ANALISE DE CONFLITOS 
## 01.09.2023
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)

con2 <- dbConnect(odbc::odbc(), "reproreplica", timeout = 10,encoding="Latin1")

## BASE ==================

base_analise <- dbGetQuery(con2, statement = read_file('BASE_ANALISE.sql'))

View(base_analise)


## PACOTES ==================


pacotes <- dbGetQuery(con2, statement = read_file('PACOTES.sql'))

View(pacotes)

## COMBINADOS ==================

comb <- dbGetQuery(con2, statement = read_file('COMBINADOS.sql'))

View(comb)

## TABELAS ==================


pacotes <- dbGetQuery(con2, statement = read_file('TABELAS.sql'))

View(pacotes)


## RELREPRO ==================


pacotes <- dbGetQuery(con2, statement = read_file('RELREPRO.sql'))

View(pacotes)


## DESCT GERAL ==================

descto_geral <- dbGetQuery(con2, statement = read_file('DESCTO_GERAL.sql'))

View(descto_geral)


## MONTAGEM ==================

montagem <- dbGetQuery(con2, statement = read_file('MONTAGEM.sql'))

View(montagem)


montagem %>% .[duplicated(.$CLICODIGO),]

## SET JOINS  =====================

conflict_set <- 
left_join(base_analise,
           descto_geral %>% select(-PROCODIGO),by="CLICODIGO") %>% 
            left_join(.,pacotes,by="CLICODIGO") %>% 
             left_join(.,comb,by="CLICODIGO") 

View(conflict_set)

## WRITE CSV  =====================


write.csv2(conflict_set,file = "conflict_set.csv" ,row.names = FALSE ,na="")








