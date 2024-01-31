select 
FND_FLEX_EXT.GET_SEGS('SQLGL','GL#', GLl.CHART_OF_ACCOUNTS_ID , gb.CODE_COMBINATION_ID) ACCOUNT_CODE,
NVL(GB.BEGIN_BALANCE_DR,0) - NVL(GB.BEGIN_BALANCE_CR,0)  期初餘額,
NVL(GB.PERIOD_NET_DR,0) - NVL(GB.PERIOD_NET_CR,0) 本月借貸, 
NVL(GB.BEGIN_BALANCE_DR,0) - NVL(GB.BEGIN_BALANCE_CR,0) + NVL(GB.PERIOD_NET_DR,0) - NVL(GB.PERIOD_NET_CR,0)  期末餘額, 
gb.*
from 
GL_LEDGERS GLL , 
gl_code_combinations  gcc ,
gl_balances  gb 
where 1=1
and gb.ledger_id  = 2021
and gb.code_combination_id = gcc.code_combination_id 
and gb.currency_code = 'NTD'
and gb.period_name = '2023-09'
and GB.LEDGER_ID = GLL.LEDGER_ID
;


select 
'''' || GB.PERIOD_NAME PERIOD_NAME,
GCC.SEGMENT3,
FND_FLEX_EXT.GET_SEGS('SQLGL','GL#', GLL.CHART_OF_ACCOUNTS_ID , GCC.CODE_COMBINATION_ID)     ACCOUNT_CODE,
NVL(GB.BEGIN_BALANCE_DR,0) - NVL(GB.BEGIN_BALANCE_CR,0)  PERIOD_BEGIN_BALANCE,
NVL(GB.BEGIN_BALANCE_DR,0) - NVL(GB.BEGIN_BALANCE_CR,0) + NVL(GB.PERIOD_NET_DR,0) - NVL(GB.PERIOD_NET_CR,0)  PERIOD_END_BALANCE, 
gb.*
from 
GL_LEDGERS GLL , 
gl_code_combinations  gcc ,
gl_balances  gb 
where 1=1
and gb.ledger_id  = 2022
AND GB.LEDGER_ID = GLL.LEDGER_ID
and gb.code_combination_id = gcc.code_combination_id
and gcc.segment3 in ( '13041000','13045000')
and gb.currency_code = 'NTD'
AND gb.period_name IN ( '21-11','21-10')
ORDER BY GB.PERIOD_NAME , GCC.SEGMENT3
;
