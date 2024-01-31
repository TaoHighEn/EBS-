select 
FND_FLEX_EXT.GET_SEGS('SQLGL','GL#', GLl.CHART_OF_ACCOUNTS_ID , gb.CODE_COMBINATION_ID)     ACCOUNT_CODE,
gll.currency_code  fun_curr,   --本幣
gb.begin_balance_dr,
gb.begin_balance_cr,
gb.period_net_dr,
gb.period_net_cr,
nvl(gb.begin_balance_dr,0) -
nvl(gb.begin_balance_cr,0) + 
nvl(gb.period_net_dr,0) -
nvl(gb.period_net_cr,0)           原幣期末餘額, 
nvl(gb.begin_balance_dr_beq,0) -
nvl(gb.begin_balance_cr_beq,0) + 
nvl(gb.period_net_dr_beq,0) -
nvl(gb.period_net_cr_beq,0)        本幣目前餘額,
ROUND(
(
nvl(gb.begin_balance_dr,0) -
nvl(gb.begin_balance_cr,0) + 
nvl(gb.period_net_dr,0) -
nvl(gb.period_net_cr,0)
) *  :P_Revaluation_rate  , 2 )              本幣重估餘額,      
gb.*
from 
gl_ledgers gll , 
gl_code_combinations gcc ,
gl_balances gb
where 1=1
and gb.ledger_id = 2136
and gb.ledger_id = gll.ledger_id
and gb.code_combination_id = gcc.code_combination_id
and gb.currency_code =   :p_currency_code    ----原幣
and gb.period_name =  :p_period_name    
and ----會計科目條件
(
gcc.segment2 = '1147' or
( gcc.segment2 = '1113' and gcc.segment3 = 'N45' )
)
;


select 
FND_FLEX_EXT.GET_SEGS('SQLGL','GL#', GLl.CHART_OF_ACCOUNTS_ID , gb.CODE_COMBINATION_ID)     ACCOUNT_CODE,
gll.currency_code  fun_curr,   --本幣
gb.begin_balance_dr,
gb.begin_balance_cr,
gb.period_net_dr,
gb.period_net_cr,
nvl(gb.begin_balance_dr,0) -
nvl(gb.begin_balance_cr,0) + 
nvl(gb.period_net_dr,0) -
nvl(gb.period_net_cr,0)           原幣期末餘額, 
nvl(gb.begin_balance_dr_beq,0) -
nvl(gb.begin_balance_cr_beq,0) + 
nvl(gb.period_net_dr_beq,0) -
nvl(gb.period_net_cr_beq,0)        本幣目前餘額,
ROUND(
(
nvl(gb.begin_balance_dr,0) -
nvl(gb.begin_balance_cr,0) + 
nvl(gb.period_net_dr,0) -
nvl(gb.period_net_cr,0)
) *  :P_Revaluation_rate     ---重估匯率
 , gc.precision 
 )                本幣重估餘額,      
'GL_BALNACES', gb.*
from 
gl_currencies gc,
gl_ledgers gll , 
gl_code_combinations gcc ,
gl_balances gb
where 1=1
and gb.ledger_id = :p_ledger_id
and gb.ledger_id = gll.ledger_id
and gll.currency_code = gc.currency_code 
and gb.code_combination_id = gcc.code_combination_id
and gb.currency_code =   :p_currency_code    ----原幣
and gb.period_name =  :p_period_name    
and gcc.code_combination_id = :p_code_combination_id   
;