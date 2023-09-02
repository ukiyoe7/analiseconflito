SELECT DISTINCT C.CLICODIGO,
                  CLINOMEFANT,
                   C.GCLCODIGO COD_GRUPO,
                     GCLNOME NOME_GRUPO,
                      CLIPCDESCPRODU,
                       SETOR
                         FROM CLIEN C
                           INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO,ZODESCRICAO SETOR FROM ENDCLI E
                              INNER JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA WHERE ZOCODIGO IN (20))Z ON 
                               E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                                LEFT JOIN GRUPOCLI GR ON C.GCLCODIGO=GR.GCLCODIGO
                                 WHERE CLICLIENTE='S'