## ANALISE DE CONFLITOS 
## 01.09.2023
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)

con3 <- dbConnect(odbc::odbc(), "repro_prod", timeout = 10,encoding="Latin1")
con2 <- dbConnect(odbc::odbc(), "reproreplica", timeout = 10,encoding="Latin1")

## QUERIES ==================

df <- dbGetQuery(con2, statement = read_file('ANALISE_CONFLITO_LA.sql'))

View(df)



comb <- dbGetQuery(con2, statement = read_file('COMBINADOS.sql'))

View(comb)


pacotes <- dbGetQuery(con2, statement = read_file('PACOTES.sql'))

View(pacotes)

pacotes %>% group_by(CLICODIGO) %>% tally() %>% View()


## SET CALC =====================

conflict_set <- 
left_join(df,pacotes,by="CLICODIGO")











