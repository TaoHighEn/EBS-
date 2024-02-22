
--Query Transaction Accounting
SELECT  
         ft.asset_id,
         te.source_id_char_1 book_type_code,h.period_name ,
         e.event_type_code, l.code_combination_id,
         fnd_flex_ext.get_segs ('SQLGL',
                                'GL#',
                                gl.chart_of_accounts_id,
                                l.code_combination_id
                               ) account_code,
         xla_oa_functions_pkg.get_ccid_description
                                (gl.chart_of_accounts_id,
                                 l.code_combination_id
                                ) account_description,
         l.accounting_class_code, h.completed_date, l.accounted_dr,
         l.accounted_cr, l.created_by, l.creation_date, l.currency_code,
         l.description line_description, h.doc_sequence_id,
         h.doc_sequence_value, l.encumbrance_type_id, l.entered_dr,
         l.entered_cr, e.creation_date event_creation_date,
         l.currency_conversion_date, l.currency_conversion_rate,
         l.currency_conversion_type, h.accounting_date, l.gl_sl_link_id,
         h.period_name, h.je_category_name, h.ae_header_id, l.ae_line_num,
         h.product_rule_type_code, h.product_rule_code, h.event_type_code,
         h.accounting_entry_status_code, h.accounting_entry_type_code,
         DECODE (l.party_type_code, 'C', l.party_id) customer_id,
         DECODE (l.party_type_code, 'C', l.party_site_id) customer_site_id,
         te.transaction_number, h.application_id, te.source_id_int_1,
         te.security_id_int_1
FROM     xla_transaction_entities te,
         xla_events e,
         xla_ae_lines l,
         xla_ae_headers h,
         xla_gl_ledgers_v gl,
         fa_transaction_history_trx_v ft
   WHERE 1 = 1
     AND ft.asset_id = :p_asset_id
     AND ft.book_type_code = :p_book_type_code
     AND h.period_name = :p_period_name
     AND ft.transaction_header_id =
                      NVL (:p_transaction_header_id, ft.transaction_header_id)
     AND te.source_id_int_1 = ft.transaction_header_id
     AND te.entity_code = 'TRANSACTIONS'
     AND e.event_type_code = NVL (:p_event_type_code, e.event_type_code)
     AND h.application_id = 140               --FND_APPLICATION.APPLICATION_ID
     AND te.entity_id = e.entity_id
     AND e.event_id = h.event_id
     AND h.ae_header_id = l.ae_header_id
     AND gl.ledger_id = h.ledger_id
ORDER BY h.ae_header_id, l.ae_line_num;