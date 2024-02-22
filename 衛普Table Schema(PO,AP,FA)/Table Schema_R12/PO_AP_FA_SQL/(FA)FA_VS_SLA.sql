--注意很重要:FA_AEL_GL_V view 沒有折舊分錄

--Query Depreciation Accounting
SELECT te.source_id_int_1 asset_id, te.source_id_char_1 book_type_code,h.period_name ,
       l.code_combination_id,
       fnd_flex_ext.get_segs ('SQLGL',
                              'GL#',
                              gl.chart_of_accounts_id,
                              l.code_combination_id
                             ) ACCOUNT_CODE,
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
       te.transaction_number, h.application_id, te.*
  FROM xla_transaction_entities te,
       xla_events e,
       xla_ae_lines l,
       xla_ae_headers h,
       xla_gl_ledgers_v gl
 WHERE 1 = 1
   AND te.source_id_int_1 = :p_asset_id
   AND te.source_id_char_1 = :p_book_type_code
   AND te.entity_code = 'DEPRECIATION'
  AND h.period_name = :p_period_name
   AND te.entity_id = e.entity_id
   AND e.event_id = h.event_id
   AND h.ae_header_id = l.ae_header_id
   AND gl.ledger_id = h.ledger_id;

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

--FA ADDITIONS VS SLASELECT
H.PERIOD_NAME,
H.ACCOUNTING_DATE,
 L.CODE_COMBINATION_ID,
       FND_FLEX_EXT.GET_SEGS('SQLGL','GL#', GL.CHART_OF_ACCOUNTS_ID, 
      L.CODE_COMBINATION_ID) ACCOUNT,
       XLA_OA_FUNCTIONS_PKG.GET_CCID_DESCRIPTION(GL.CHART_OF_ACCOUNTS_ID,
                                                 L.CODE_COMBINATION_ID) ACCOUNT_DESCRIPTION,
L.ACCOUNTING_CLASS_CODE,      H.COMPLETED_DATE,
L.ACCOUNTED_DR,                            L.ACCOUNTED_CR,
L.CREATED_BY,                                  L.CREATION_DATE,
L.CURRENCY_CODE,                         L.DESCRIPTION LINE_DESCRIPTION,
H.DOC_SEQUENCE_ID,                     H.DOC_SEQUENCE_VALUE,
L.ENCUMBRANCE_TYPE_ID,          L.ENTERED_DR,
L.ENTERED_CR,                                 E.CREATION_DATE EVENT_CREATION_DATE,
L.CURRENCY_CONVERSION_DATE,       L.CURRENCY_CONVERSION_RATE,
L.CURRENCY_CONVERSION_TYPE,        H.ACCOUNTING_DATE,       L.GL_SL_LINK_ID,
H.PERIOD_NAME,               H.JE_CATEGORY_NAME,     H.AE_HEADER_ID,
L.AE_LINE_NUM,                H.PRODUCT_RULE_TYPE_CODE,
H.PRODUCT_RULE_CODE,       H.EVENT_TYPE_CODE,
H.ACCOUNTING_ENTRY_STATUS_CODE,
H.ACCOUNTING_ENTRY_TYPE_CODE,
DECODE(L.PARTY_TYPE_CODE, 'C', L.PARTY_ID) CUSTOMER_ID,
DECODE(L.PARTY_TYPE_CODE, 'C', L.PARTY_SITE_ID) CUSTOMER_SITE_ID,
TE.TRANSACTION_NUMBER,       H.APPLICATION_ID,       TE.SOURCE_ID_INT_1,      TE.SECURITY_ID_INT_1,
L.*
FROM XLA_TRANSACTION_ENTITIES TE,       XLA_EVENTS               E,       XLA_AE_LINES             L,
XLA_AE_HEADERS           H, XLA_GL_LEDGERS_V         GL
WHERE 1 = 1
AND H.PERIOD_NAME = 'Jan-08'
--AND TE.SOURCE_ID_INT_1 = 160202 --FA_TRANSACTION_HEADERS.TRANSACTION_HEADER_ID
AND E.EVENT_TYPE_CODE='ADDITIONS'
AND H.APPLICATION_ID=140 --FND_APPLICATION.APPLICATION_ID
AND TE.ENTITY_ID = E.ENTITY_ID
AND E.EVENT_ID = H.EVENT_ID
AND H.AE_HEADER_ID = L.AE_HEADER_ID
AND GL.LEDGER_ID = H.LEDGER_ID
ORDER BY H.AE_HEADER_ID, L.AE_LINE_NUM;
--=============================================================
--FA DEPRECIATION VS SLASELECT
SELECT
H.PERIOD_NAME,
H.ACCOUNTING_DATE,
 L.CODE_COMBINATION_ID,
 TE.SOURCE_ID_INT_1,
L.ACCOUNTING_CLASS_CODE,      H.COMPLETED_DATE,
L.ACCOUNTED_DR,                            L.ACCOUNTED_CR,
L.CREATED_BY,                                  L.CREATION_DATE,
L.CURRENCY_CODE,                         L.DESCRIPTION LINE_DESCRIPTION,
H.DOC_SEQUENCE_ID,                     H.DOC_SEQUENCE_VALUE,
L.ENCUMBRANCE_TYPE_ID,          L.ENTERED_DR,
L.ENTERED_CR,                                 E.CREATION_DATE EVENT_CREATION_DATE,
L.CURRENCY_CONVERSION_DATE,       L.CURRENCY_CONVERSION_RATE,
L.CURRENCY_CONVERSION_TYPE,        H.ACCOUNTING_DATE,       L.GL_SL_LINK_ID,
H.PERIOD_NAME,               H.JE_CATEGORY_NAME,     H.AE_HEADER_ID,
L.AE_LINE_NUM,                H.PRODUCT_RULE_TYPE_CODE,
H.PRODUCT_RULE_CODE,       H.EVENT_TYPE_CODE,
H.ACCOUNTING_ENTRY_STATUS_CODE,
H.ACCOUNTING_ENTRY_TYPE_CODE,
DECODE(L.PARTY_TYPE_CODE, 'C', L.PARTY_ID) CUSTOMER_ID,
DECODE(L.PARTY_TYPE_CODE, 'C', L.PARTY_SITE_ID) CUSTOMER_SITE_ID,
TE.TRANSACTION_NUMBER,       H.APPLICATION_ID,       TE.SOURCE_ID_INT_1,      TE.SECURITY_ID_INT_1,
TE.*
--,
--L.*
FROM XLA_TRANSACTION_ENTITIES TE,       XLA_EVENTS               E,       XLA_AE_LINES             L,
XLA_AE_HEADERS           H
WHERE 1 = 1
AND H.PERIOD_NAME = 'Jan-08'
--AND TE.SOURCE_ID_INT_1 = 160202 --FA_TRANSACTION_HEADERS.TRANSACTION_HEADER_ID
AND E.EVENT_TYPE_CODE='DEPRECIATION'   --'ADDITIONS'
--AND TE.SOURCE_ID_INT_1=109798
AND H.APPLICATION_ID=140 --FND_APPLICATION.APPLICATION_ID
AND TE.ENTITY_ID = E.ENTITY_ID
AND E.EVENT_ID = H.EVENT_ID
AND H.AE_HEADER_ID = L.AE_HEADER_ID
ORDER BY H.AE_HEADER_ID, L.AE_LINE_NUM;

