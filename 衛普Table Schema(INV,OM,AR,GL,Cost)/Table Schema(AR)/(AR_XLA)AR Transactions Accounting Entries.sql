SELECT
         gll.name         ledger_name,
         rct.trx_number ,
         xte.ledger_id,  
         xte.entity_code, 
         rct.trx_date, 
         xe.event_id,
         xe.event_type_code, 
         xah.accounting_date, 
         xah.gl_transfer_status_code,     --- �O�_�w���� GL  
         xah.je_category_name,
         xah.description              ae_header_description, 
         xal.code_combination_id,
         xal.accounting_class_code, 
         fnd_flex_ext.get_segs ('SQLGL',
                                'GL#',
                                gll.chart_of_accounts_id,
                                xal.code_combination_id
                               )      account_code,        ----------�|�p��إN��
         xla_oa_functions_pkg.get_ccid_description
                                (gll.chart_of_accounts_id,
                                 xal.code_combination_id
                                )     account_description,
         xal.description              ae_line_description,             ----------�|�p��شy�z
         xal.currency_code,
         xal.entered_dr, 
         xal.entered_cr, 
         xal.accounted_dr, 
         xal.accounted_cr, 
         xal.ae_header_id,
         xal.ae_line_num, 
         xal.gl_sl_link_id, 
         xal.gl_sl_link_table 
         , xal.*
    FROM 
         gl_ledgers                     gll ,
         xla_ae_lines                   xal ,
         xla_ae_headers                 xah ,
         xla_events                     xe , 
         xla.xla_transaction_entities   xte ,
         hr_operating_units             hou,
         ra_customer_trx_all            rct  
   WHERE 1 = 1
     AND rct.trx_number                 =  :p_trx_number 
     AND rct.ORG_ID                     =  :p_org_id
     AND rct.ORG_ID                     =  hou.ORGANIZATION_ID 
    -------- �H�U3 ��������~��Ψ� xla.xla_transaction_entities_N1 INDEX 
     AND hou.SET_OF_BOOKS_ID            =  xte.LEDGER_ID 
     AND xte.entity_code                =  'TRANSACTIONS'
     AND rct.customer_trx_id            =  NVL(  xte.source_id_int_1  , -99)
    -----  AND rct.customer_trx_id            =   xte.source_id_int_1    ----�`�N�P�H�W�o�ӱ��󪺤��P�I
     --------
     AND xte.application_id             =  222                     ---- 222 = AR
     AND xte.application_id             =  xe.application_id(+) 
     AND xte.entity_id                  =  xe.entity_id(+)            ---- �@�iinvoice �i��|���G�ӥH�W��event_id 
--
     AND xe.application_id              =  xah.application_id(+) 
     AND xe.event_id                    =  xah.event_id(+) 

     AND xah.ae_header_id               =  xal.ae_header_id(+)  
--
     AND xah.ledger_id                  =  gll.ledger_id(+)           ----�`�N: ���p�]�w secondary ledger, ����P�@�� transaction �|���� xla accountings �b���P��ledger_id
