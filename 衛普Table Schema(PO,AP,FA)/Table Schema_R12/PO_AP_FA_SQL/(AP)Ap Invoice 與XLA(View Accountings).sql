SELECT
         ai.invoice_num, 
         xte.transaction_number   xte_trx_number ,    ----應該等於 invoice_num, 但某些版本有bug,標準功能修改invoice number, 沒有同步修改,validate invoice會出現無法計算稅的錯誤(因為ZX_LINES.TRX_NUMBER也不一致)
         ai.invoice_date, 
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
                               )      account_code,        ----------會計科目代號
         xla_oa_functions_pkg.get_ccid_description
                                (gl.chart_of_accounts_id,
                                 xal.code_combination_id
                                )     account_description,
         xal.description              ae_line_description,             ----------會計科目描述
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
         ap_invoices_all                ai 
   WHERE 1 = 1
     AND ai.org_id                      =  nvl(:p_org_id , ai.org_id)
     AND ai.invoice_num                 =  nvl(:p_invoice_num , ai.invoice_num)
     AND ai.invoice_id                  =  nvl(:p_invoice_id , ai.invoice_id)
     AND ai.invoice_date               >=  :p_invoice_date
     AND ai.invoice_id                  =  xte.source_id_int_1     ---- 用 invocie_id 去讀取
     AND xte.entity_code                =  'AP_INVOICES'
     AND xte.application_id             =  200                     ---- 200 = SQLAP 
     AND xte.application_id             =  xe.application_id 
     AND xte.entity_id                  =  xe.entity_id            ---- 一張invoice 可能會有二個以上的event_id 
     AND xe.application_id              =  xah.application_id
     AND xe.event_id                    =  xah.event_id 
     AND xah.ae_header_id               =  xal.ae_header_id 
     AND xah.ledger_id                  =  gl.ledger_id 
