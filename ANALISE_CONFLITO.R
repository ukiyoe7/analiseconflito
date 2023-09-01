## ANALISE DE CONFLITOS 
## 01.09.2023
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)

con3 <- dbConnect(odbc::odbc(), "repro_prod", timeout = 10,encoding="Latin1")
con2 <- dbConnect(odbc::odbc(), "reproreplica", timeout = 10,encoding="Latin1")

## QUERIES ==================

base_analise <- dbGetQuery(con2, statement = read_file('BASE_ANALISE.sql'))

View(base_analise)


descto_geral <- dbGetQuery(con2, statement = read_file('DESCTO_GERAL.sql'))

View(descto_geral)



comb <- dbGetQuery(con2, statement = read_file('COMBINADOS.sql'))

View(comb)


pacotes <- dbGetQuery(con2, statement = read_file('PACOTES.sql'))

View(pacotes)

pacotes %>% group_by(CLICODIGO) %>% tally() %>% View()


## SET CALC =====================

conflict_set <- 
left_join(base_analise,pacotes,by="CLICODIGO")

View(conflict_set)











