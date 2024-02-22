SELECT
         ac.check_number, 
         xte.transaction_number   xte_trx_number ,   
         ac.check_date, 
         xe.event_id,
         xe.event_type_code, 
         xah.accounting_date, 
         xah.gl_transfer_status_code,     --- 是否已拋轉 GL  
         xah.je_category_name,
         xah.description              ae_header_description, 
         xal.code_combination_id,
         xal.accounting_class_code, 
         fnd_flex_ext.get_segs ('SQLGL',
                                'GL#',
                                gl.chart_of_accounts_id,
                                xal.code_combination_id
                               )      account_code,
         xla_oa_functions_pkg.get_ccid_description
                                (gl.chart_of_accounts_id,
                                 xal.code_combination_id
                                )     account_description,
         xal.description              ae_line_description, 
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
         gl_ledgers                     gl ,
         xla_ae_lines                   xal ,
         xla_ae_headers                 xah ,
         xla_events                     xe , 
         xla.xla_transaction_entities   xte , 
         ap_checks_all                  ac 
   WHERE 1 = 1
     AND ac.org_id                      =  nvl(:p_org_id , ac.org_id)
     AND ac.check_number                =  nvl(:p_check_number , ac.check_number)
     AND ac.check_id                    =  nvl(:p_check_id , ac.check_id)
     AND ac.check_date                 >=  :p_check_date
     AND ac.check_id                    =  xte.source_id_int_1     ---- 用 CHECK_ID 去讀取
     AND xte.entity_code                =  'AP_PAYMENTS'
     AND xte.application_id             =  200                     ---- 200 = SQLAP 
     AND xte.application_id             =  xe.application_id 
     AND xte.entity_id                  =  xe.entity_id    
     AND xe.application_id              =  xah.application_id
     AND xe.event_id                    =  xah.event_id 
     AND xah.ae_header_id               =  xal.ae_header_id 
     AND xah.ledger_id                  =  gl.ledger_id 
