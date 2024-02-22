SELECT
         ai.invoice_num, 
         xte.transaction_number   xte_trx_number ,    ----���ӵ��� invoice_num, ���Y�Ǫ�����bug,�зǥ\��ק�invoice number, �S���P�B�ק�,validate invoice�|�X�{�L�k�p��|�����~(�]��ZX_LINES.TRX_NUMBER�]���@�P)
         ai.invoice_date, 
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
                                gl.chart_of_accounts_id,
                                xal.code_combination_id
                               )      account_code,        ----------�|�p��إN��
         xla_oa_functions_pkg.get_ccid_description
                                (gl.chart_of_accounts_id,
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
     AND ai.invoice_id                  =  xte.source_id_int_1     ---- �� invocie_id �hŪ��
     AND xte.entity_code                =  'AP_INVOICES'
     AND xte.application_id             =  200                     ---- 200 = SQLAP 
     AND xte.application_id             =  xe.application_id 
     AND xte.entity_id                  =  xe.entity_id            ---- �@�iinvoice �i��|���G�ӥH�W��event_id 
     AND xe.application_id              =  xah.application_id
     AND xe.event_id                    =  xah.event_id 
     AND xah.ae_header_id               =  xal.ae_header_id 
     AND xah.ledger_id                  =  gl.ledger_id 
